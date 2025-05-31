------------------------------------------------------------------------------
-- Copyright (c) 2012-2015 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.2
--  \   \        Filename: serdes_1_to_7_slave_idelay_ddr.vhd
--  /   /        Date Last Modified:  21JAN2015
-- /___/   /\    Date Created: 2SEP2011
-- \   \  /  \
--  \___\/\___\
--
--Device:     7 Series
--Purpose:      1 to 7 DDR receiver slave data receiver
--        Data formatting is set by the DATA_FORMAT parameter.
--        PER_CLOCK (default) format receives bits for 0, 1, 2 .. on the same sample edge
--        PER_CHANL format receives bits for 0, 7, 14 ..  on the same sample edge
--
--Reference:    XAPP585
--
--Revision History:
--    Rev 1.0 - First created (nicks)
--    Rev 1.1 - PER_CLOCK and PER_CHANL descriptions swapped
--    Rev 1.2 - State machine moved to a new level of hierarchy, updated format
--    Rev 1.3 - joined the debug busses together in one bus (defossez)
--              debug <= s_delay_val_in & m_delay_val_in & bslip & c_delay_in & int_dcw_debug;
------------------------------------------------------------------------------
--
--  Disclaimer:
--
--        This disclaimer is not a license and does not grant any rights to the materials
--              distributed herewith. Except as otherwise provided in a valid license issued to you
--              by Xilinx, and to the maximum extent permitted by applicable law:
--              (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS,
--              AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
--              INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR
--              FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether in contract
--              or tort, including negligence, or under any other theory of liability) for any loss or damage
--              of any kind or nature related to, arising under or in connection with these materials,
--              including for any direct, or any indirect, special, incidental, or consequential loss
--              or damage (including loss of data, profits, goodwill, or any type of loss or damage suffered
--              as a result of any action brought by a third party) even if such damage or loss was
--              reasonably foreseeable or Xilinx had been advised of the possibility of the same.
--
--  Critical Applications:
--
--        Xilinx products are not designed or intended to be fail-safe, or for use in any application
--        requiring fail-safe performance, such as life-support or safety devices or systems,
--        Class III medical devices, nuclear facilities, applications related to the deployment of airbags,
--        or any other applications that could lead to death, personal injury, or severe property or
--        environmental damage (individually and collectively, "Critical Applications"). Customer assumes
--        the sole risk and liability of any use of Xilinx products in Critical Applications, subject only
--        to applicable laws and regulations governing limitations on product liability.
--
--  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all ;

library unisim ;
    use unisim.vcomponents.all ;
library Receiver_Lib;
    use Receiver_Lib.all;

entity serdes_1_to_7_slave_idelay_ddr is generic (
    D             : integer := 8 ;                -- Set the number of inputs
    DIFF_TERM        : boolean := FALSE ;                -- Enable or disable internal differential termination
    REF_FREQ         : real := 200.0 ;                   -- Parameter to set reference frequency used by idelay controller
     HIGH_PERFORMANCE_MODE     : string := "FALSE" ;                -- Parameter to set HIGH_PERFORMANCE_MODE of input delays to reduce jitter
    DATA_FORMAT         : string := "PER_CLOCK") ;            -- Used to determine method for mapping input parallel word to output serial words
port     (
    clkin_p            :  in std_logic ;                -- Input from LVDS clock pin
    clkin_n            :  in std_logic ;                -- Input from LVDS clock pin
    datain_p        :  in std_logic_vector(D-1 downto 0) ;        -- Input from LVDS receiver pin
    datain_n        :  in std_logic_vector(D-1 downto 0) ;        -- Input from LVDS receiver pin
    enable_phase_detector    :  in std_logic ;                -- Enables the phase detector logic when high
    enable_monitor        :  in std_logic ;                -- Enables the eye monitoring logic when high
    reset            :  in std_logic ;                -- Reset line
    idelay_rdy        :  in std_logic ;                -- input delays are ready
    rxclk            :  in std_logic ;                -- Global/BUFIO rx clock network
    pixel_clk        :  in std_logic ;                -- Global/Regional clock output
    rxclk_d4        :  in std_logic ;                -- Global/Regional clock output
    bitslip_finished    : out std_logic ;                -- bitslipping finished, synchronous to pixel_clk
    clk_data        : out std_logic_vector(6 downto 0) ;          -- received clock data
    rx_data            : out std_logic_vector((7*D)-1 downto 0) ;      -- Output data
    bit_time_value        :  in std_logic_vector(4 downto 0) ;        -- Calculated bit time value for slave devices
    eye_info         : out std_logic_vector(32*D-1 downto 0) ;    -- eye info
    m_delay_1hot        : out std_logic_vector(32*D-1 downto 0) ;      -- Master delay control value as a one-hot vector
    del_mech        :  in std_logic ;                 -- '0' = square, '1' = assume 10% DCD
    rst_iserdes        :  in std_logic ;                -- reset serdes input
    gb_rst_in         :  in std_logic_vector(1 downto 0) ;        -- gearbox reset signals to slaves
    -- debug bus corrected by defossez 07Mar 18
    --debug            : out std_logic_vector(10*D+5 downto 0)) ;      -- Debug bus
    debug            : out std_logic_vector(((12*D)+6)-1 downto 0)) ;      -- Debug bus

end serdes_1_to_7_slave_idelay_ddr ;

architecture arch_serdes_1_to_7_slave_idelay_ddr of serdes_1_to_7_slave_idelay_ddr is
----------------------------------------------------------------------------------------------
-- Constants, signals and Attributes
----------------------------------------------------------------------------------------------
signal    m_delay_val_in        : std_logic_vector(5*D-1 downto 0) ;
signal    s_delay_val_in        : std_logic_vector(5*D-1 downto 0) ;
signal    cdataout        : std_logic_vector(3 downto 0) ;
signal    cdataouta        : std_logic_vector(3 downto 0) ;
signal    cdataoutb        : std_logic_vector(3 downto 0) ;
signal    cdataoutc        : std_logic_vector(3 downto 0) ;
signal    rx_clk_in        : std_logic ;
signal    bsstate            : integer range 0 to 3 ;
signal    bslip            : std_logic ;
signal    bslipreq        : std_logic ;
signal    bslipr_dom_ch        : std_logic ;
signal    bcount            : std_logic_vector(3 downto 0) ;
signal    pdcount            : std_logic_vector(6*D-1 downto 0) ;
signal    clk_iserdes_data    : std_logic_vector(6 downto 0) ;
signal    clk_iserdes_data_d    : std_logic_vector(6 downto 0) ;
signal    enable            : std_logic ;
signal    flag1            : std_logic ;
signal    flag2            : std_logic ;
signal    state2            : integer range 0 to 3 ;
signal    state2_count        : std_logic_vector(3 downto 0) ;
signal    scount            : std_logic_vector(5 downto 0) ;
signal    locked_out        : std_logic ;
signal    locked_out_dom_ch    : std_logic ;
signal    chfound            : std_logic ;
signal    chfoundc        : std_logic ;
signal    c_delay_in        : std_logic_vector(4 downto 0) ;
signal    rx_data_in_p        : std_logic_vector(D-1 downto 0) ;
signal    rx_data_in_n        : std_logic_vector(D-1 downto 0) ;
signal    rx_data_in_m        : std_logic_vector(D-1 downto 0) ;
signal    rx_data_in_s        : std_logic_vector(D-1 downto 0) ;
signal    rx_data_in_md        : std_logic_vector(D-1 downto 0) ;
signal    rx_data_in_sd        : std_logic_vector(D-1 downto 0) ;
signal    mdataout        : std_logic_vector(4*D-1 downto 0) ;
signal    mdataoutd        : std_logic_vector(4*D-1 downto 0) ;
signal    sdataout        : std_logic_vector(4*D-1 downto 0) ;
signal    sdataoutc        : std_logic_vector(4*D-1 downto 0) ;
signal    dataout            : std_logic_vector(7*D-1 downto 0) ;
signal    jog             : std_logic ;
signal    ramouta         : std_logic_vector((D*6)-1 downto 0) ;
signal    ramoutb         : std_logic_vector((D*6)-1 downto 0) ;
signal    slip_count         : std_logic_vector(2 downto 0) ;
signal    bslip_ack_dom_ch    : std_logic ;
signal    bslip_ack        : std_logic ;
signal    bstate             : integer range 0 to 3 ;
signal    data_different        : std_logic ;
signal    data_different_dom_ch    : std_logic ;
signal    s_ovflw         : std_logic_vector(D-1 downto 0) ;
signal    s_hold             : std_logic_vector(D-1 downto 0) ;
signal    bs_finished        : std_logic ;
signal    not_bs_finished_dom_ch    : std_logic ;
signal     not_rxclk        : std_logic ;
signal     rx_clk_in_to_mmcm    : std_logic ;
signal     rx_clk_in_d        : std_logic ;
signal     local_reset_dom_ch    : std_logic ;
signal    bt_val             : std_logic_vector(4 downto 0) ;
signal    gbin            : std_logic_vector(4*(D+1)-1 downto 0) ;
signal    gbout            : std_logic_vector(7*(D+1)-1 downto 0) ;
signal     retry            : std_logic ;
signal     no_clock        : std_logic ;
signal     no_clock_dom_ch        : std_logic ;
signal    c_loop_cnt        : std_logic_vector(1 downto 0) ;
-- Add by defossez on 07 Mar 18
--  dcw = delay_controller_wrap
signal int_dcw_debug    : std_logic_vector((2*D)-1 downto 0);

constant RX_SWAP_MASK     : std_logic_vector(D-1 downto 0) := (others => '0') ;    -- pinswap mask for input data bits (0 = no swap (default), 1 = swap). Allows inputs to be connected the wrong way round to ease PCB routing.

attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of arch_serdes_1_to_7_slave_idelay_ddr : architecture is "TRUE";
----------------------------------------------------------------------------------------------
begin

clk_data <= clk_iserdes_data ;
-- Modified by defossez on 07 Mar 18
--debug <= s_delay_val_in & m_delay_val_in & bslip & c_delay_in ;
debug <= s_delay_val_in & m_delay_val_in & bslip & c_delay_in & int_dcw_debug;
--          [(5*D)-1:0]      [(5*D)-1:0]       1      [4:0]      [(D*2)-1:0]
--                     (10*D)             +    1      + 5         + (2*D)
--                                       (12*D)+6 ====================> [((12*D)+6)-1 downto 0]
--
bitslip_finished <= bs_finished and not reset ;
bt_val <= bit_time_value ;

process (rxclk_d4, reset) begin                -- generate local reset
if reset = '1' then
    local_reset_dom_ch <= '1' ;
elsif rxclk_d4'event and rxclk_d4 = '1' then
    if idelay_rdy = '0' or retry = '1' then
        local_reset_dom_ch <= '1' ;
    else
        local_reset_dom_ch <= '0' ;
    end if ;
end if ;
end process ;

-- Bitslip state machine, split over two clock domains

process (pixel_clk) begin
if pixel_clk'event and pixel_clk = '1' then
    locked_out_dom_ch <= locked_out ;
    if locked_out_dom_ch = '0' then
        bsstate <= 2 ;
        enable <= '0' ;
        bslipreq <= '0' ;
        bcount <= X"0" ;
        jog <= '0' ;
        slip_count <= "000" ;
        bs_finished <= '0' ;
        retry <= '0' ;
    else
           bslip_ack_dom_ch <= bslip_ack ;
        enable <= '1' ;
           if enable = '1' then
               if clk_iserdes_data /= "1100001" then flag1 <= '1' ; else flag1 <= '0' ; end if ;
               if clk_iserdes_data /= "1100011" then flag2 <= '1' ; else flag2 <= '0' ; end if ;
                 if bsstate = 0 then
                   if flag1 = '1' and flag2 = '1' then
                            bslipreq <= '1' ;                    -- bitslip needed
                            bsstate <= 1 ;
                        else
                            bs_finished <= '1' ;                    -- bitslip done
                        end if ;
               elsif bsstate = 1 then                            -- wait for bitslip ack from other clock domain
                        if bslip_ack_dom_ch = '1' then
                            bslipreq <= '0' ;                    -- bitslip low
                            bcount <= X"0" ;
                            slip_count <= slip_count + 1 ;
                            bsstate <= 2 ;
                        end if ;
               elsif bsstate = 2 then
                        bcount <= bcount + 1 ;
                   if bcount = "1111" then
                            if slip_count = "101" then
                                jog <= not jog ;
                                if jog = '1' then
                                    retry <= '1' ;
                                end if ;
                            end if ;
                            bsstate <= 0 ;
                        end if ;
               end if ;
           end if ;
    end if ;
end if ;
end process ;

process (rxclk_d4) begin
if rxclk_d4'event and rxclk_d4 = '1' then
    not_bs_finished_dom_ch <= not bs_finished ;
    bslipr_dom_ch <= bslipreq ;
    if locked_out = '0' then
        bslip <= '0' ;
        bslip_ack <= '0' ;
        bstate <= 0 ;
    elsif bstate = 0 and bslipr_dom_ch = '1' then
        bslip <= '1' ;
        bslip_ack <= '1' ;
        bstate <= 1 ;
    elsif bstate = 1 then
        bslip <= '0' ;
        bslip_ack <= '1' ;
        bstate <= 2 ;
    elsif bstate = 2 and bslipr_dom_ch = '0' then
        bslip_ack <= '0' ;
        bstate <= 0 ;
    end if ;
end if ;
end process ;

-- Clock input

iob_clk_in : IBUFGDS generic map(
    DIFF_TERM         => DIFF_TERM)
port map (
    I                => clkin_p,
    IB               => clkin_n,
    O                 => rx_clk_in);

idelay_cm : IDELAYE2
generic map (
    REFCLK_FREQUENCY        => REF_FREQ,
    HIGH_PERFORMANCE_MODE   => HIGH_PERFORMANCE_MODE,
    IDELAY_VALUE            => 1,
    DELAY_SRC               => "IDATAIN",
    IDELAY_TYPE             => "VAR_LOAD",
    PIPE_SEL                => "FALSE",     -- ***
    SIGNAL_PATTERN          => "DATA",      -- ***
    CINVCTRL_SEL            => "FALSE",     -- ***
    IS_C_INVERTED           => '0',         -- ***
    IS_DATAIN_INVERTED      => '0',         -- ***
    IS_IDATAIN_INVERTED     => '0'          -- ***
)
port map (
    DATAOUT            => rx_clk_in_d,
    C            => rxclk_d4,
    CE            => '0',
    INC            => '0',
    DATAIN            => '0',
    IDATAIN            => rx_clk_in,
    LD            => '1',
    LDPIPEEN        => '0',
    REGRST            => '0',
    CINVCTRL        => '0',
    CNTVALUEIN        => c_delay_in,
    CNTVALUEOUT        => open);

not_rxclk <= not rxclk ;

iserdes_cm : ISERDESE2 generic map(
    DATA_WIDTH             => 4,
    DATA_RATE              => "DDR",
    SERDES_MODE            => "MASTER",
    IOBDELAY            => "IFD",
    INTERFACE_TYPE         => "NETWORKING")
port map (
    D               => rx_clk_in,
    DDLY             => rx_clk_in_d,
    CE1             => '1',
    CE2             => '1',
    CLK                => rxclk,
    CLKB            => not_rxclk,
    RST             => local_reset_dom_ch,
    CLKDIV          => rxclk_d4,
    CLKDIVP          => '0',
    OCLK            => '0',
    OCLKB            => '0',
    DYNCLKSEL            => '0',
    DYNCLKDIVSEL          => '0',
    SHIFTIN1         => '0',
    SHIFTIN2         => '0',
    BITSLIP         => bslip,
    O             => rx_clk_in_to_mmcm,
    Q8             => open,
    Q7             => open,
    Q6             => open,
    Q5             => open,
    Q4             => cdataout(0),
    Q3             => cdataout(1),
    Q2             => cdataout(2),
    Q1             => cdataout(3),
    OFB             => '0',
    SHIFTOUT1         => open,
    SHIFTOUT2         => open);

process (pixel_clk) begin
if pixel_clk'event and pixel_clk = '1' then            -- retiming
    clk_iserdes_data_d <= clk_iserdes_data ;
    if (clk_iserdes_data /= clk_iserdes_data_d) and (clk_iserdes_data /= "0000000") and (clk_iserdes_data /= "1111111") then
        data_different <= '1' ;
    else
        data_different <= '0' ;
    end if ;
    if (clk_iserdes_data = "0000000") or (clk_iserdes_data = "1111111") then
        no_clock <= '1' ;
    else
        no_clock <= '0' ;
    end if ;
end if ;
end process ;

process (rxclk_d4) begin
if rxclk_d4'event and rxclk_d4 = '1' then            -- clock delay shift state machine
    if local_reset_dom_ch = '1' then
        scount <= "000000" ;
        state2 <= 0 ;
        state2_count <= X"0" ;
        locked_out <= '0' ;
        chfoundc <= '1' ;
        c_delay_in <= bt_val ;                            -- Start the delay line at the current bit period
        c_loop_cnt <= "00" ;
    else
        if scount(5) = '0' then
            if no_clock_dom_ch = '0' then
                scount <= scount + 1 ;
            else
                scount <= "000000" ;
            end if ;
        end if ;
        state2_count <= state2_count + 1 ;
        data_different_dom_ch <= data_different ;
        no_clock_dom_ch <= no_clock ;
        if chfoundc = '1' then
            chfound <= '0' ;
        elsif chfound = '0' and data_different_dom_ch = '1' then
            chfound <= '1' ;
        end if ;
        if (state2_count = "1111" and scount(5) = '1') then
            case (state2) is
            when 0    =>                            -- decrement delay and look for a change
                  if chfound = '1' or (c_loop_cnt = "11" and c_delay_in = "00000") then  -- quit loop if we've been around a few times
                    chfoundc <= '1' ;
                    state2 <= 1 ;
                  else
                    chfoundc <= '0' ;
                    c_delay_in <= c_delay_in - 1 ;
                    if c_delay_in /= "00000" then            -- check for underflow
                        c_delay_in <= c_delay_in - 1 ;
                    else
                        c_delay_in <= bt_val ;
                        c_loop_cnt <= c_loop_cnt + 1 ;
                    end if ;
                  end if ;
            when 1    =>                            -- add half a bit period using input information
                  state2 <= 2 ;                        -- choose the lowest delay value to minimise jitter
                  if c_delay_in < '0' & bt_val(4 downto 1) then
                       c_delay_in <= c_delay_in + ('0' & bt_val(4 downto 1)) ;
                  else
                       c_delay_in <= c_delay_in - ('0' & bt_val(4 downto 1)) ;
                  end if ;
            when others =>                            -- issue locked out signal and wait for a manual command (if required)
                  locked_out <= '1' ;
            end case ;
        end   if ;
    end if ;
end if ;
end process ;

loop3 : for i in 0 to D-1 generate

dc_inst : entity Receiver_Lib.delay_controller_wrap
generic map (
    S             => 4)
port map (
    m_datain        => mdataout(4*i+3 downto 4*i),
    s_datain        => sdataout(4*i+3 downto 4*i),
    enable_phase_detector    => enable_phase_detector,
    enable_monitor        => enable_monitor,
    reset            => not_bs_finished_dom_ch,
    clk            => rxclk_d4,
    c_delay_in        => c_delay_in,
    m_delay_out        => m_delay_val_in(5*i+4 downto 5*i),
    s_delay_out        => s_delay_val_in(5*i+4 downto 5*i),
    data_out        => mdataoutd(4*i+3 downto 4*i),
    results            => eye_info(32*i+31 downto 32*i),
    m_delay_1hot        => m_delay_1hot(32*i+31 downto 32*i),
    debug           => int_dcw_debug((2*i)+1 downto 2*i), -- add by defossez on 07 Mar 18
    del_mech        => del_mech,
    bt_val            => bt_val) ;

end generate ;

process (rxclk_d4) begin                            -- clock balancing
if rxclk_d4'event and rxclk_d4 = '1' then
    if enable_phase_detector = '1' then
        cdataouta(3 downto 0) <= cdataout(3 downto 0) ;
        cdataoutb(3 downto 0) <= cdataouta(3 downto 0) ;
        cdataoutc(3 downto 0) <= cdataoutb(3 downto 0) ;
    else
        cdataoutc(3 downto 0) <= cdataout(3 downto 0) ;
    end if ;
end if ;
end process ;

-- Data gearbox (includes clock data)

gb0 : entity Receiver_Lib.gearbox_4_to_7_slave
generic map (
    D             => D+1)
port map (
    input_clock        => rxclk_d4,
    output_clock        => pixel_clk,
    datain            => gbin,
    reset            => gb_rst_in,
    jog            => jog,
    dataout            => gbout) ;

gbin <= cdataoutc & mdataoutd ;
clk_iserdes_data <= gbout((D+1)*7-1 downto D*7) ;
dataout <= gbout(D*7-1 downto 0) ;

-- Data bit Receivers

loop0 : for i in 0 to D-1 generate
loop1 : for j in 0 to 6 generate            -- Assign data bits to correct serdes according to required format
    loop1a : if DATA_FORMAT = "PER_CLOCK" generate
        rx_data(D*j+i) <= dataout(7*i+j) ;
    end generate ;
    loop1b : if DATA_FORMAT = "PER_CHANL" generate
        rx_data(7*i+j) <= dataout(7*i+j) ;
    end generate ;
end generate ;

data_in : IBUFDS_DIFF_OUT generic map(
    DIFF_TERM         => DIFF_TERM)
port map (
    I                => datain_p(i),
    IB               => datain_n(i),
    O                 => rx_data_in_p(i),
    OB                 => rx_data_in_n(i));

rx_data_in_m(i) <= rx_data_in_p(i) xor RX_SWAP_MASK(i) ;
rx_data_in_s(i) <= not rx_data_in_n(i) xor RX_SWAP_MASK(i) ;

idelay_m : IDELAYE2
generic map (
    REFCLK_FREQUENCY        => REF_FREQ,
    HIGH_PERFORMANCE_MODE   => HIGH_PERFORMANCE_MODE,
    IDELAY_VALUE            => 0,
    DELAY_SRC               => "IDATAIN",
    IDELAY_TYPE             => "VAR_LOAD",
    PIPE_SEL                => "FALSE",     -- ***
    SIGNAL_PATTERN          => "DATA",      -- ***
    CINVCTRL_SEL            => "FALSE",     -- ***
    IS_C_INVERTED           => '0',         -- ***
    IS_DATAIN_INVERTED      => '0',         -- ***
    IS_IDATAIN_INVERTED     => '0'          -- ***
)
port map (
    DATAOUT            => rx_data_in_md(i),
    C            => rxclk_d4,
    CE            => '0',
    INC            => '0',
    DATAIN            => '0',
    IDATAIN            => rx_data_in_m(i),
    LD            => '1',
    LDPIPEEN        => '0',
    REGRST            => '0',
    CINVCTRL        => '0',
    CNTVALUEIN        => m_delay_val_in(5*i+4 downto 5*i),
    CNTVALUEOUT        => open);

iserdes_m : ISERDESE2 generic map(
    DATA_WIDTH             => 4,
    DATA_RATE              => "DDR",
    SERDES_MODE            => "MASTER",
    IOBDELAY            => "IFD",
    INTERFACE_TYPE         => "NETWORKING")
port map (
    D               => '0',
    DDLY             => rx_data_in_md(i),
    CE1             => '1',
    CE2             => '1',
    CLK               => rxclk,
    CLKB            => not_rxclk,
    RST             => rst_iserdes,
    CLKDIV          => rxclk_d4,
    CLKDIVP          => '0',
    OCLK            => '0',
    OCLKB            => '0',
    DYNCLKSEL            => '0',
    DYNCLKDIVSEL          => '0',
    SHIFTIN1         => '0',
    SHIFTIN2         => '0',
    BITSLIP         => bslip,
    O             => open,
    Q8              => open,
    Q7              => open,
    Q6              => open,
    Q5              => open,
    Q4              => mdataout(4*i+0),
    Q3              => mdataout(4*i+1),
    Q2              => mdataout(4*i+2),
    Q1              => mdataout(4*i+3),
    OFB             => '0',
    SHIFTOUT1        => open,
    SHIFTOUT2         => open);

idelay_s : IDELAYE2
generic map (
    REFCLK_FREQUENCY        => REF_FREQ,
    HIGH_PERFORMANCE_MODE   => HIGH_PERFORMANCE_MODE,
    IDELAY_VALUE            => 0,
    DELAY_SRC               => "IDATAIN",
    IDELAY_TYPE             => "VAR_LOAD",
    PIPE_SEL                => "FALSE",     -- ***
    SIGNAL_PATTERN          => "DATA",      -- ***
    CINVCTRL_SEL            => "FALSE",     -- ***
    IS_C_INVERTED           => '0',         -- ***
    IS_DATAIN_INVERTED      => '0',         -- ***
    IS_IDATAIN_INVERTED     => '0'          -- ***
)
port map (
    DATAOUT            => rx_data_in_sd(i),
    C            => rxclk_d4,
    CE            => '0',
    INC            => '0',
    DATAIN            => '0',
    IDATAIN            => rx_data_in_s(i),
    LD            => '1',
    LDPIPEEN        => '0',
    REGRST            => '0',
    CINVCTRL        => '0',
    CNTVALUEIN        => s_delay_val_in(5*i+4 downto 5*i),
    CNTVALUEOUT        => open);

iserdes_s : ISERDESE2 generic map(
    DATA_WIDTH             => 4,
    DATA_RATE              => "DDR",
--    SERDES_MODE            => "MASTER",
    IOBDELAY            => "IFD",
    INTERFACE_TYPE         => "NETWORKING")
port map (
    D               => '0',
    DDLY             => rx_data_in_sd(i),
    CE1             => '1',
    CE2             => '1',
    CLK               => rxclk,
    CLKB            => not_rxclk,
    RST             => rst_iserdes,
    CLKDIV          => rxclk_d4,
    CLKDIVP          => '0',
    OCLK            => '0',
    OCLKB            => '0',
    DYNCLKSEL            => '0',
    DYNCLKDIVSEL          => '0',
    SHIFTIN1         => '0',
    SHIFTIN2         => '0',
    BITSLIP         => bslip,
    O             => open,
    Q8              => open,
    Q7              => open,
    Q6              => open,
    Q5              => open,
    Q4              => sdataout(4*i+0),
    Q3              => sdataout(4*i+1),
    Q2              => sdataout(4*i+2),
    Q1              => sdataout(4*i+3),
    OFB             => '0',
    SHIFTOUT1        => open,
    SHIFTOUT2         => open);

end generate ;

end arch_serdes_1_to_7_slave_idelay_ddr ;
