---------------------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /
-- \   \   \/    � Copyright 2018 Xilinx, Inc. All rights reserved.
--  \   \        This file contains confidential and proprietary information of Xilinx, Inc.
--  /   /        and is protected under U.S. and international copyright and other
-- /___/   /\    intellectual property laws.
-- \   \  /  \
--  \___\/\___\
--
---------------------------------------------------------------------------------------------
-- Device:              7-Series
-- Author:              Defossez
-- Entity Name:         TxRx_5x2_7to1_Toplevel
-- Purpose:             Full design containing transmitter and receiver.
--                      Fuve data channel + one clock transmitter to a five data channel
--                      and one clock receiver.
--
-- Tools:               Vivado_2017.4 or later
-- Limitations:         VHDL-2008
--
-- Vendor:              Xilinx Inc.
-- Version:             0.01
-- Filename:            TxRx_5x2_7to1_Toplevel.vhd
-- Date Created:        Mar 2018
-- Date Last Modified:  Mar 2018
---------------------------------------------------------------------------------------------
-- Disclaimer:
--		This disclaimer is not a license and does not grant any rights to the materials
--		distributed herewith. Except as otherwise provided in a valid license issued to you
--		by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
--		ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
--		WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
--		TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
--		PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
--		negligence, or under any other theory of liability) for any loss or damage of any
--		kind or nature related to, arising under or in connection with these materials,
--		including for any direct, or any indirect, special, incidental, or consequential
--		loss or damage (including loss of data, profits, goodwill, or any type of loss or
--		damage suffered as a result of any action brought by a third party) even if such
--		damage or loss was reasonably foreseeable or Xilinx had been advised of the
--		possibility of the same.
--
-- CRITICAL APPLICATIONS
--		Xilinx products are not designed or intended to be fail-safe, or for use in any
--		application requiring fail-safe performance, such as life-support or safety devices
--		or systems, Class III medical devices, nuclear facilities, applications related to
--		the deployment of airbags, or any other applications that could lead to death,
--		personal injury, or severe property or environmental damage (individually and
--		collectively, "Critical Applications"). Customer assumes the sole risk and
--		liability of any use of Xilinx products in Critical Applications, subject only to
--		applicable laws and regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
-- Contact:    e-mail  hotline@xilinx.com        phone   + 1 800 255 7778
---------------------------------------------------------------------------------------------
-- Revision History:
--
---------------------------------------------------------------------------------------------
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_UNSIGNED.all;
library UNISIM;
    use UNISIM.vcomponents.all;
library xil_defaultlib;
    use xil_defaultlib.all;
library Transmitter_Lib;
    use Transmitter_Lib.all;
library Receiver_Lib;
    use Receiver_Lib.all;
---------------------------------------------------------------------------------------------
-- Entity generic description
---------------------------------------------------------------------------------------------
-- N                : Set the number of channels
-- D                : Set the number of outputs per channel
-- -- -- TRANSMITTER
-- TX_DATA_FORMAT   : Determine method for mapping input parallel word to output serial words.
--                  : "PER_CLOCK" or "PER_CHANL" data formatting
-- TX_MMCM_MODE     : Parameter to set multiplier for MMCM divider to get VCO in correct
--                  : operating range. 1 multiplies input clock by 7, 2 multiplies clock
--                  : by 14, etc
-- TX_MMCM_MODE_REAL    : Parameter to set multiplier for MMCM multiplier to get VCO in correct
--                      : operating range. 1.000 multiplies input clock by 7, 2.000 multiplies
--                      : clock by 14, etc
-- TX_CLOCK         : Parameter to set transmission clock buffer type, BUFIO, BUF_H, BUF_G
-- TX_INTER_CLOCK   : Parameter to set intermediate clock buffer type, BUFR, BUF_H, BUF_G
-- TX_PIXEL_CLOCK   : Parameter to set final clock buffer type, BUF_R, BUF_H, BUF_G
-- TX_USE_PLL       : Parameter to enable PLL use rather than MMCM use, note, PLL does not
--                  : support BUFIO and BUFR
-- TX_CLKIN_PERIOD  : clock period (ns) of input clock on clkin_p
-- TX_DIFF_TERM     : Enable or disable internal differential termination
-- TX_CLK_FORM      : Format of the ouput clock 3/4 or 4/3 format (format = High/Low)
-- -- -- RECEIVER
-- RX_SAMPL_CLOCK   : Parameter to set sampling clock buffer type, BUFIO, BUF_H, BUF_G
-- RX_INTER_CLOCK   : Parameter to set intermediate clock buffer type, BUFR, BUF_H, BUF_G
-- RX_PIXEL_CLOCK   : Parameter to set final clock buffer type, BUF_R, BUF_H, BUF_G
-- RX_USE_PLL       : Parameter to enable PLL use rather than MMCM use, note, PLL does
--                  : not support BUFIO and BUFR
-- RX_CLKIN_PERIOD  : clock period (ns) of input clock on clkin_p
-- RX_REF_FREQ      : Parameter to set reference frequency used by idelay controller.
-- RX_HIGH_PERFORMANCE_MODE : Parameter to set HIGH_PERFORMANCE_MODE of input delays to
--                          : reduce jitter
-- RX_MMCM_MODE     : Parameter to set multiplier for MMCM divider to get VCO in correct
--                  : operating range. 1 multiplies input clock by 7, 2 multiplies
--                  : clock by 14, etc
-- RX_MMCM_MODE_REAL    : Parameter to set multiplier for MMCM multiplier to get VCO in
--                      : correct operating range. 1.000 multiplies input clock by 7, 2.000
--                      : multiplies clock by 14, etc
-- RX_DIFF_TERM     : Enable or disable internal differential termination
-- RX_DATA_FORMAT   : Used to determine method for mapping input parallel word to
--                  : output serial words.
-- RX_BIT_RATE      : Receiver bit rate value in hex(BCD), eg 16'h0585
---------------------------------------------------------------------------------------------
-- Entity pin description
---------------------------------------------------------------------------------------------
-- -- -- TRANSMITTER
-- freqgen_p/n      : Input clock for pixel rate frequency generator.
-- reset            : reset (active high)
-- clkoutx_p/n      : lvds channel clock output
-- dataoutx_p/n     : lvds channel data outputs
-- Create as many data and clock outpts as there are channels specified for N.
-- The data outputs for each channel must be as wide as the value given for D.
-- tx_clkgen_state  : Status bus used for debuging purposes. shows the clock buffers used
--                  : 00 = BUFG, 01 = BUFR, 10 = BUFH
--                  : 6 = 0, 54 = rxclk, 32 = rxclk_d4, 10 = pixel_clock
-- -- -- RECEIVER
-- rx_reset         : reset (active high)
-- rx_refclkin      : Reference clock for input delay control
-- clkin1_p/n       : lvds channel 1 clock input
-- datain1_p/n      : lvds channel 1 data inputs
-- clkin2_p/n       : lvds channel 2 clock input
-- datain2_p/n      : lvds channel 2 data inputs
-- bit_time_value   : in the master calculated bit time value for
--                  : slave devices. value passed from master to slaves.
-- status           : Status bus, shows the clock buffers used
--                  : 00 = BUFG, 01 = BUFR, 10 = BUFH
--                  : 6 = 0, 54 = rxclk, 32 = rxclk_d4, 10 = pixel_clock
-- eye_info         : eye info from slaves & master (32-bit per channel).
-- m_delay_1hot     : Master delay control value as a one-hot vector.
--                  : Bus representing all channels.
-- debug            : debug bus for slave & master receiver
--             : debug <= s_delay_val_in & m_delay_val_in & bslip & c_delay_in & int_dcw_debug;
---------------------------------------------------------------------------------------------
entity TxRx_5x2_7to1_Toplevel is
    generic (
        N                   : integer := 2;
        D                   : integer := 5;
        --
        TX_DATA_FORMAT      : string    := "PER_CLOCK";
        TX_MMCM_MODE        : integer   := 1;
        TX_MMCM_MODE_REAL   : real      := 1.000;
        TX_CLOCK            : string    := "BUFIO";
        TX_INTER_CLOCK      : string    := "BUF_R";
        TX_PIXEL_CLOCK      : string    := "BUF_G";
        TX_USE_PLL          : boolean   := FALSE;
        TX_CLKIN_PERIOD     : real      := 6.000;
        TX_DIFF_TERM        : boolean   := TRUE;
        TX_CLK_FORM         : string    := "3/4";
        --
        RX_SAMPL_CLOCK      : string    := "BUF_G";
        RX_INTER_CLOCK      : string    := "BUF_G";
        RX_PIXEL_CLOCK      : string    := "BUF_G";
        RX_USE_PLL          : boolean   := FALSE;
        RX_HIGH_PERFORMANCE_MODE : string := "FALSE";
        RX_CLKIN_PERIOD     : real      := 6.600;
        RX_MMCM_MODE        : integer   := 1;
        RX_MMCM_MODE_REAL   : real      := 1.000;
        RX_REF_FREQ         : real      := 200.0;
        RX_DIFF_TERM        : boolean   := TRUE;
        RX_DATA_FORMAT      : string    := "PER_CLOCK";
        RX_BIT_RATE         : std_logic_vector(15 downto 0) := X"1050";
        RX_EN_EYE_MON       : string(1 to 3)    := "yes";
        RX_EN_DCD_COR       : string(1 to 3)    := "no ";
        RX_EN_PHS_DET       : string(1 to 3)    := "yes"
    );
    port (
        -- Transmitter
        tx_freqgen_p        : in  std_logic;
        tx_freqgen_n        : in  std_logic;
        tx_reset            : in  std_logic;
        tx_datain           : in  std_logic_vector(((D*N)*7)-1 downto 0);
        tx_pixel_clk        : out std_logic;
        tx_mmcm_lckd        : out std_logic;
        clkout_p            : out std_logic_vector(N-1 downto 0);
        clkout_n            : out std_logic_vector(N-1 downto 0);
        dataout_p           : out std_logic_vector((N*D)-1 downto 0);
        dataout_n           : out std_logic_vector((N*D)-1 downto 0);
        -- Receiver
        clkin_p             : in  std_logic_vector(N-1 downto 0);
        clkin_n             : in  std_logic_vector(N-1 downto 0);
        datain_p            : in  std_logic_vector((N*D)-1 downto 0);
        datain_n            : in  std_logic_vector((N*D)-1 downto 0);
        rx_reset            : in  std_logic;
        rx_refclkin         : in  std_logic;
        rx_pixel_clk        : out std_logic;
        rx_mmcm_lckdpsbs    : out std_logic_vector(N-1 downto 0);
        rx_clk_d4           : out std_logic;
        rx_clk_dataout      : out std_logic_vector((7*N)-1 downto 0);
        rx_dataout          : out std_logic_vector((7*(N*D))-1 downto 0);
        -- Debug
        tx_clkgen_state     : out std_logic_vector(6 downto 0);
        --
        rx_bit_time_value   : out std_logic_vector(4 downto 0);
        rx_status           : out std_logic_vector(6 downto 0);
        rx_eye_info         : out std_logic_vector((32*(D*N))-1 downto 0);
        rx_m_delay_1hot     : out std_logic_vector((32*(D*N))-1 downto 0);
        rx_debug            : out std_logic_vector((((12*D)+6)*N)-1 downto 0)
    );
end TxRx_5x2_7to1_Toplevel;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture TxRx_5x2_7to1_Toplevel_arch of TxRx_5x2_7to1_Toplevel is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
constant Low : std_logic := '0';
constant High : std_logic := '1';
constant LowVec : std_logic_vector(255 downto 0) := (others => '0');
-- Transmitter
signal int_tx_mmcm_lckd : std_logic;
signal int_tx_pixel_clk : std_logic;
-- Rreceiver
signal int_rx_clk_d4                : std_logic;
signal int_delay_ready              : std_logic;
signal int_rx_pixel_clk             : std_logic;
signal int_rx_mmcm_lckdpsbs         : std_logic_vector(N-1 downto 0);
signal int_enable_phase_detector    : std_logic;
signal int_enable_monitor           : std_logic;
signal int_dcd_correct              : std_logic;
signal int_rx_bit_time_value        : std_logic_vector(4 downto 0);
signal int_rx_status                : std_logic_vector(6 downto 0);
signal int_rx_eye_info              : std_logic_vector((32*(D*N))-1 downto 0);
signal int_rx_m_delay_1hot          : std_logic_vector((32*(D*N))-1 downto 0);
signal int_rx_debug                 : std_logic_vector((((12*D)+6)*N)-1 downto 0);
signal int_dcd_rx_bit_time_value    : std_logic_vector(4 downto 0);
signal int_dcd_rx_status            : std_logic_vector(6 downto 0);
signal int_dcd_rx_eye_info          : std_logic_vector((32*(D*N))-1 downto 0);
signal int_dcd_rx_m_delay_1hot      : std_logic_vector((32*(D*N))-1 downto 0);
signal int_dcd_rx_debug             : std_logic_vector((((12*D)+6)*N)-1 downto 0);
-- attributes
attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of TxRx_5x2_7to1_Toplevel_arch : architecture is "TRUE";
--attribute KEEP : string;
 --   attribute KEEP of int_rx_status : signal is "TRUE";
--attribute LOC : string;
--        attribute LOC of  : label is ;
---------------------------------------------------------------------------------------------
begin
--
---------------------------------------------------------------------------------------------
-- TRANSMITTER CORE
-- The transmitter core is constructed out of two lower hierarchical cores.
--  - n_x_serdes_7_to_1_diff_ddr
--      Above core contains following hierarchy: "serdes_7_t0_1_diff_ddr"
--  - clock_generator_pll_7_to_1_diff_ddr
-- The connections of these cores and assembly in the top level "Ddr_Tx_5x2_7to1"
-- are discussed in that file.
---------------------------------------------------------------------------------------------
Txd : entity Transmitter_Lib.Ddr_Tx_5x2_7to1
    generic map (
       N                => N, --
       D                => D, --
       DATA_FORMAT      => TX_DATA_FORMAT, --
       MMCM_MODE        => TX_MMCM_MODE, --
       MMCM_MODE_REAL   => TX_MMCM_MODE_REAL, --
       TX_CLOCK         => TX_CLOCK, --
       INTER_CLOCK      => TX_INTER_CLOCK, --
       PIXEL_CLOCK      => TX_PIXEL_CLOCK, --
       USE_PLL          => TX_USE_PLL, --
       CLKIN_PERIOD     => TX_CLKIN_PERIOD, --
       DIFF_TERM        => TX_DIFF_TERM, --
       CLK_FORM         => TX_CLK_FORM --
    )
    port map (
        freqgen_p       => tx_freqgen_p, -- in
        freqgen_n       => tx_freqgen_n, -- in
        Reset           => tx_reset, -- in
        datain          => tx_datain, -- in
        mmcm_lckd       => int_tx_mmcm_lckd, -- out
        pixel_clk       => int_tx_pixel_clk, -- out
        clkout_p        => clkout_p, -- out
        clkout_n        => clkout_n, -- out
        dataout_p       => dataout_p, -- out
        dataout_n       => dataout_n, -- out
        clkgen_state    => tx_clkgen_state  -- out
    );
--
tx_pixel_clk <= int_tx_pixel_clk;
tx_mmcm_lckd <= int_tx_mmcm_lckd;
--
---------------------------------------------------------------------------------------------
-- RECEIVER CORE
-- The receiver core is constructed out of several hierarcical blocks.
--
-- The attributes of this instantiated component are discussed above at the entity.
-- The ports are discussed here:
-- clkin_p         : in [N-1:0]     -- Input from LVDS clock pin. There is one such an
-- clkin_n         : in [N-1:0]     -- Input per used channel (N).
-- datain_p        : in [(D*N)-1:0] -- Input from LVDS receiver pin. All databit from
-- datain_n        : in [(D*N)-1:0] -- all used channels are combined in one bus.
-- enable_phase_detector : in       -- Enables the phase detector logic when high
-- enable_monitor  : in             -- Enables the eye monitoring logic when high
-- reset           : in             -- Reset line
-- idelay_rdy      : in             -- input delays are ready
-- rxclk           : out            -- Global/BUFIO rx clock network
-- rxclk_d4        : out            -- Global/Regional clock output
-- pixel_clk       : out            -- Global/Regional clock output
-- rx_mmcm_lckd    : out            -- MMCM locked, synchronous to rxclk_d4
-- rx_mmcm_lckdps  : out            -- MMCM locked and phase shifting finished,
--                 :                -- synchronous to rxclk_d4
-- rx_mmcm_lckdpsbs: out [N-1:0]    -- MMCM locked and phase shifting finished and
--                                  -- bitslipping finished, synchronous to pixel_clk
-- clk_data        : out [(7*N)-1:0]      -- received clock data
-- rx_data         : out [((7*N)*D)-1:0]  -- Output data
-- dcd_correct     : in                   -- '0' = square, '1' = assume 10% DCD
-- bit_rate_value  : in [15:0]            -- Bit rate in Mbps in hex(BCD), eg 16'h0585
--                                        -- This is a generic value.
--   Below are signals used for debug purposes.
-- bit_time_value  : out [4:0]            -- in the master calculated bit time value for
--                                        -- slave devices. value passed from master to slaves.
-- status          : out [6:0]            -- Shows the clock buffers used with the MMCM in rx0
--                                        -- 00 = BUFG, 01 = BUFR, 10 = BUFH
--                                        -- 6 = MMCM/PLL (MMCM = 1)
--                                        -- 54 = rxclk, 32 = rxclk_d4, 10 = pixel_clock
-- eye_info        : out [(32*(D*N))-1:0] -- eye info from slaves & master (32-bit per channel).
-- m_delay_1hot    : out [(32*(D*N))-1:0] -- Master delay control value as a one-hot vector.
--                                        -- Bus representing all channels.
-- rxn_debug       : out [(((12*D)+6)*N)-1:0] -- debug bus for slave & master receiver
--      debug <= s_delay_val_in & m_delay_val_in & bslip & c_delay_in & int_dcw_debug;
---------------------------------------------------------------------------------------------
-- Insert IDELAY_CONTROL to keep track of PVT.
idly_ctrlL : IDELAYCTRL
    port map (REFCLK => rx_refclkin, RST => rx_reset, RDY => int_delay_ready);
--
gen_0 : case RX_EN_PHS_DET generate
    when "yes" => int_enable_phase_detector <= High;
    when others => int_enable_phase_detector <= Low;
end generate gen_0;
--
gen_1 : case RX_EN_EYE_MON generate
    when "yes" => int_enable_monitor <= High;
    when others => int_enable_monitor <= Low;
end generate gen_1;
--
gen_2 : case RX_EN_DCD_COR generate
    when "yes" => int_dcd_correct <= High;
    when others => int_dcd_correct <= Low;
end generate gen_2;
--
Rxd : entity Receiver_Lib.n_x_serdes_1_to_7_mmcm_idelay_ddr
    generic map (
        N                       => N,
        D                       => D,
        SAMPL_CLOCK             => RX_SAMPL_CLOCK,
        INTER_CLOCK             => RX_INTER_CLOCK,
        PIXEL_CLOCK             => RX_PIXEL_CLOCK,
        USE_PLL                 => RX_USE_PLL,
        HIGH_PERFORMANCE_MODE   => RX_HIGH_PERFORMANCE_MODE,
        CLKIN_PERIOD            => RX_CLKIN_PERIOD,
        MMCM_MODE               => RX_MMCM_MODE,
        MMCM_MODE_REAL          => RX_MMCM_MODE_REAL,
        REF_FREQ                => RX_REF_FREQ,
        DIFF_TERM               => RX_DIFF_TERM,
        DATA_FORMAT             => RX_DATA_FORMAT
    )
    port map (
        clkin_p                 => clkin_p,
        clkin_n                 => clkin_n,
        datain_p                => datain_p,
        datain_n                => datain_n,
        enable_phase_detector   => int_enable_phase_detector,
        enable_monitor          => int_enable_monitor,
        dcd_correct             => int_dcd_correct,
        rxclk                   => open,
        rxclk_d4                => int_rx_clk_d4,
        idelay_rdy              => int_delay_ready,
        pixel_clk               => rx_pixel_clk,
        reset                   => rx_reset,
        rx_mmcm_lckd            => open,
        rx_mmcm_lckdps          => open,
        rx_mmcm_lckdpsbs        => rx_mmcm_lckdpsbs,
        clk_data                => rx_clk_dataout,
        rx_data                 => rx_dataout,
        bit_rate_value          => RX_BIT_RATE,
        bit_time_value          => int_rx_bit_time_value,
        status                  => rx_status, --int_rx_status,
        eye_info                => int_rx_eye_info,
        m_delay_1hot            => int_rx_m_delay_1hot,
        debug                   => int_rx_debug
    );
--
rx_clk_d4 <= int_rx_clk_d4;
-- Register the control outputs of the receiver before sending then to a VIO.
reg_ctrl_sigs : process (int_rx_clk_d4)
begin
    if (int_rx_clk_d4'event and int_rx_clk_d4 = '1') then
        int_dcd_rx_bit_time_value   <= int_rx_bit_time_value;
        --int_dcd_rx_status           <= int_rx_status;
        int_dcd_rx_eye_info         <= int_rx_eye_info;
        int_dcd_rx_m_delay_1hot     <= int_rx_m_delay_1hot;
        int_dcd_rx_debug            <= int_rx_debug;
        --
        rx_bit_time_value <= int_dcd_rx_bit_time_value;
        --rx_status         <= int_dcd_rx_status;
        rx_eye_info       <= int_dcd_rx_eye_info;
        rx_m_delay_1hot   <= int_dcd_rx_m_delay_1hot;
        rx_debug          <= int_dcd_rx_debug;
    end if;
end process;
---------------------------------------------------------------------------------------------
end TxRx_5x2_7to1_Toplevel_arch;
