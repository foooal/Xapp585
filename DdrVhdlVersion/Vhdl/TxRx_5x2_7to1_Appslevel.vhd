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
-- Entity Name:         TxRx_5x2_7to1_Appslevel
-- Purpose:             Full design containing transmitter and receiver.
--                      Fuve data channel + one clock transmitter to a five data channel
--                      and one clock receiver. The design targets the KC705 7-Series
--                      Xilinx development board and is stuffed with VIO, ILA and clock
--                      generator controlled (clock generator for the transmitter inputs
--                      frequency).
--
-- Tools:               Vivado_2017.4 or later
-- Limitations:         VHDL-2008
--
-- Vendor:              Xilinx Inc.
-- Version:             0.01
-- Filename:            TxRx_5x2_7to1_Appslevel.vhd
-- Date Created:        Mar 2018
-- Date Last Modified:  Mar 2018
---------------------------------------------------------------------------------------------
-- Disclaimer:
--        This disclaimer is not a license and does not grant any rights to the materials
--        distributed herewith. Except as otherwise provided in a valid license issued to you
--        by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
--        ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
--        WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
--        TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
--        PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
--        negligence, or under any other theory of liability) for any loss or damage of any
--        kind or nature related to, arising under or in connection with these materials,
--        including for any direct, or any indirect, special, incidental, or consequential
--        loss or damage (including loss of data, profits, goodwill, or any type of loss or
--        damage suffered as a result of any action brought by a third party) even if such
--        damage or loss was reasonably foreseeable or Xilinx had been advised of the
--        possibility of the same.
--
-- CRITICAL APPLICATIONS
--        Xilinx products are not designed or intended to be fail-safe, or for use in any
--        application requiring fail-safe performance, such as life-support or safety devices
--        or systems, Class III medical devices, nuclear facilities, applications related to
--        the deployment of airbags, or any other applications that could lead to death,
--        personal injury, or severe property or environmental damage (individually and
--        collectively, "Critical Applications"). Customer assumes the sole risk and
--        liability of any use of Xilinx products in Critical Applications, subject only to
--        applicable laws and regulations governing limitations on product liability.
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
library Osc_Control_Lib;
    use Osc_Control_Lib.all;
---------------------------------------------------------------------------------------------
entity TxRx_5x2_7to1_Appslevel is
    generic (
        C_DebugChnl     : string(1 to 5) := "Chnl1";    -- "Chnl1" or "Chnl2"
        C_DebugLane     : string(1 to 3) := "Ln1";      -- "Ln1", "Ln2", "Ln3", "Ln4" or "Ln5"
        C_Simulation    : string(1 to 3) := "no "       -- "yes", "no ", BUT DO NOT TOUCH THIS HERE.
    );
    port (
        -- Transmitter
        tx_freqgen_p        : in  std_logic;
        tx_freqgen_n        : in  std_logic;
        clkout1_p           : out std_logic;
        clkout1_n           : out std_logic;
        dataout1_p          : out std_logic_vector(4 downto 0);
        dataout1_n          : out std_logic_vector(4 downto 0);
        clkout2_p           : out std_logic;
        clkout2_n           : out std_logic;
        dataout2_p          : out std_logic_vector(4 downto 0);
        dataout2_n          : out std_logic_vector(4 downto 0);
        -- Receiver
        clkin1_p            : in  std_logic;
        clkin1_n            : in  std_logic;
        datain1_p           : in  std_logic_vector(4 downto 0);
        datain1_n           : in  std_logic_vector(4 downto 0);
        clkin2_p            : in  std_logic;
        clkin2_n            : in  std_logic;
        datain2_p           : in  std_logic_vector(4 downto 0);
        datain2_n           : in  std_logic_vector(4 downto 0);
        -- Stuff
        refclkin_p          : in  std_logic;
        refclkin_n          : in  std_logic;
        rx_dummy            : out std_logic;
        Si570_to_sma_p      : out std_logic;
        Si570_to_sma_n      : out std_logic;
        -- I2C comtroller
        i2c_data            : inout std_logic;
        i2c_clock           : inout std_logic
    );
end TxRx_5x2_7to1_Appslevel;
---------------------------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------------------------
architecture TxRx_5x2_7to1_Appslevel_arch of TxRx_5x2_7to1_Appslevel is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
constant Low  : std_logic := '0';
constant High : std_logic := '1';
constant LowVec : std_logic_vector(255 downto 0) := (others => '0');
constant HighVec : std_logic_vector(255 downto 0) := (others => '1');
-- Transmitter
signal int_txd1                  : std_logic_vector(34 downto 0);
signal int_txd2                  : std_logic_vector(34 downto 0);
signal int_txdata                : std_logic_vector(69 downto 0);
signal int_tx_pxlclk_out         : std_logic;
signal int_tx_mmcm_lckd          : std_logic;
signal int_tx_pixel_clk          : std_logic;
signal int_clkout_p              : std_logic_vector(1 downto 0);
signal int_clkout_n              : std_logic_vector(1 downto 0);
signal int_dataout_p             : std_logic_vector(9 downto 0);
signal int_dataout_n             : std_logic_vector(9 downto 0);
-- Rreceiver
signal int_refclk                : std_logic;
signal int_refclk_bufg           : std_logic;
signal int_clkin_p               : std_logic_vector(1 downto 0);
signal int_clkin_n               : std_logic_vector(1 downto 0);
signal int_datain_p              : std_logic_vector(9 downto 0);
signal int_datain_n              : std_logic_vector(9 downto 0);
signal int_rx_pixel_clk          : std_logic;
signal int_rxdall                : std_logic_vector(69 downto 0);
signal int_rxclk_data            : std_logic_vector(13 downto 0);
signal int_rx_mmcm_lckdpsbs      : std_logic_vector(1 downto 0);
signal int_rxd1                  : std_logic_vector(34 downto 0);
signal int_rxd2                  : std_logic_vector(34 downto 0);
signal int_old_rx1               : std_logic_vector(34 downto 0);
signal int_old_rx2               : std_logic_vector(34 downto 0);
-- debug
signal int_shift_pattern         : std_logic_vector(34 downto 0);
signal int_dummy                 : std_logic_vector(0 downto 0);
signal int_dummytoobuf           : std_logic;
signal int_tx_reset              : std_logic_vector(0 downto 0);
signal int_rx_reset              : std_logic_vector(0 downto 0);
signal int_rx_clk_d4             : std_logic;
signal int_rx_status             : std_logic_vector(6 downto 0);
signal int_rx_bit_time_value     : std_logic_vector(4 downto 0);
signal int_tx_clkgen_state       : std_logic_vector(6 downto 0);
signal int_rx_eye_info           : std_logic_vector(319 downto 0);
signal int_rx_m_delay_1hot       : std_logic_vector(319 downto 0);
signal int_rx_debug              : std_logic_vector(131 downto 0);
--
signal int_dbg_rx_eye_info       : std_logic_vector(31 downto 0);
signal int_dbg_rx_m_delay_1hot   : std_logic_vector(31 downto 0);
signal int_dbg_rx_s_delay_val    : std_logic_vector(4 downto 0);
signal int_dbg_rx_m_delay_val    : std_logic_vector(4 downto 0);
signal int_dbg_rx_bitslip        : std_logic_vector(0 downto 0);
signal int_dbg_rx_c_delay_val    : std_logic_vector(4 downto 0);
signal int_dbg_rx_dcw_action     : std_logic_vector(1 downto 0);
signal int_dbg_rx_status         : std_logic_vector(6 downto 0);
signal int_dbg_rx_bit_time_value : std_logic_vector(4 downto 0);
signal int_dbg_tx_clkgen_state   : std_logic_vector(6 downto 0);
signal int_dbg_rxd1              : std_logic_vector(34 downto 0);
signal int_dbg_rxd2              : std_logic_vector(34 downto 0);
signal int_dbg_rx_clk1           : std_logic_vector(6 downto 0);
signal int_dbg_rx_clk2           : std_logic_vector(6 downto 0);
signal int_ila_rxd1              : std_logic_vector(34 downto 0);
signal int_ila_rxd2              : std_logic_vector(34 downto 0);
signal int_ila_rx_clk1           : std_logic_vector(6 downto 0);
signal int_ila_rx_clk2           : std_logic_vector(6 downto 0);
signal int_dbg_d0_rx_mmcm_lckdpsbs     : std_logic_vector(1 downto 0);
signal int_dbg_d1_rx_mmcm_lckdpsbs     : std_logic_vector(1 downto 0);
signal int_ila_rx_mmcm_lckdpsbs  : std_logic_vector(0 downto 0);
signal int_dbg_tx_mmcm_lckd      : std_logic_vector(0 downto 0);
signal int_dbg_rxclk_data        : std_logic_vector(6 downto 0);

-- I2C Clock generator
signal int_ga0toobuf             : std_logic;
signal int_ga1toobuf             : std_logic;
signal int_clki2c                : std_logic;
signal int_i2c_reset             : std_logic_vector(0 downto 0);
signal int_freq_value            : std_logic_vector(23 downto 0);
signal int_prog_freq             : std_logic_vector(0 downto 0);
signal int_freq_acq              : std_logic_vector(0 downto 0);
signal int_freq_rdy              : std_logic_vector(0 downto 0);
signal int_i2c_data_out          : std_logic;
signal int_i2c_data_in           : std_logic;
signal int_i2c_clock_out         : std_logic;
signal int_i2c_clock_in          : std_logic;
-- Ports only used for simulation
signal Sim_probe_in4             : std_logic_vector(31 downto 0);
signal Sim_probe_in5             : std_logic_vector(31 downto 0);
signal Sim_probe_in6             : std_logic_vector(4 downto 0);
signal Sim_probe_in7             : std_logic_vector(4 downto 0);
signal Sim_probe_in8             : std_logic_vector(4 downto 0);
signal Sim_probe_in9             : std_logic_vector(4 downto 0);
signal Sim_probe_in10            : std_logic_vector(0 downto 0);
signal Sim_probe_in11            : std_logic_vector(1 downto 0);
signal Sim_probe_in12            : std_logic_vector(6 downto 0);
signal Sim_probe_in13            : std_logic_vector(6 downto 0);
signal Sim_probe_in15            : std_logic_vector(0 downto 0);
signal Sim_probe_in16            : std_logic_vector(1 downto 0);
signal Sim_probe_out0            : std_logic_vector(0 downto 0);
signal Sim_probe_out1            : std_logic_vector(0 downto 0);
signal Sim_probe_out3            : std_logic_vector(34 downto 0);
--
signal int_ila_rx_dbg_mdataout   : std_logic_vector(19 downto 0);
signal int_ila_rx_dbg_sdataout   : std_logic_vector(19 downto 0);
-- Attributes
attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of TxRx_5x2_7to1_Appslevel_arch : architecture is "TRUE";
attribute KEEP : string;
    attribute KEEP of int_dbg_d1_rx_mmcm_lckdpsbs : signal is "TRUE";
    attribute KEEP of int_dbg_rxd1      : signal is "TRUE";
    attribute KEEP of int_dbg_rxd2      : signal is "TRUE";
    attribute KEEP of int_dbg_rx_clk1   : signal is "TRUE";
    attribute KEEP of int_dbg_rx_clk2   : signal is "TRUE";
    attribute KEEP of int_ila_rx_mmcm_lckdpsbs : signal is "TRUE";
    attribute KEEP of int_ila_rxd1      : signal is "TRUE";
    attribute KEEP of int_ila_rxd2      : signal is "TRUE";
    attribute KEEP of int_ila_rx_clk1   : signal is "TRUE";
    attribute KEEP of int_ila_rx_clk2   : signal is "TRUE";
    -- Only used for simulation.
    -- This generates a lot of warnings (99) during synthesis.
    -- All of them can be ignored.
    attribute KEEP of Sim_probe_in4     : signal is "TRUE";
    attribute KEEP of Sim_probe_in5     : signal is "TRUE";
    attribute KEEP of Sim_probe_in6     : signal is "TRUE";
    attribute KEEP of Sim_probe_in7     : signal is "TRUE";
    attribute KEEP of Sim_probe_in8     : signal is "TRUE";
    attribute KEEP of Sim_probe_in9     : signal is "TRUE";
    attribute KEEP of Sim_probe_in10    : signal is "TRUE";
    attribute KEEP of Sim_probe_in11    : signal is "TRUE";
    attribute KEEP of Sim_probe_in12    : signal is "TRUE";
    attribute KEEP of Sim_probe_in13    : signal is "TRUE";
    attribute KEEP of Sim_probe_in15    : signal is "TRUE";
    attribute KEEP of Sim_probe_in16    : signal is "TRUE";
    attribute KEEP of Sim_probe_out0    : signal is "TRUE";
    attribute KEEP of Sim_probe_out1    : signal is "TRUE";
    attribute KEEP of Sim_probe_out3    : signal is "TRUE";
--attribute LOC : string;
--        attribute LOC of  : label is ;
---------------------------------------------------------------------------------------------
begin
--
refclk_ibuf : IBUFDS
    generic map (IOSTANDARD => "LVDS", IBUF_LOW_PWR => TRUE)
    port map(I => refclkin_p, IB => refclkin_n, O => int_refclk_bufg);
-- "int_refclk_bufg" is at the end of this file used as entry for a BUFR.
-- The BUFR is used for the I2C controller.
refclk_bufg : BUFG
    port map (I => int_refclk_bufg, O => int_refclk);
-- This OBUFDS brings the pixel clock of the transmitter to an output buffer and SMA connector.
-- The pixel clock has the same frequency as the input clock of the MMMCM because it's the
-- feedback clock.
tx_pixel_clock_out : OBUFDS
    generic map (IOSTANDARD => "LVDS_25", SLEW => "SLOW")
    port map (I => int_tx_pxlclk_out, O => Si570_to_sma_p, OB => Si570_to_sma_n);
tx_pixel_clock_oddr : ODDR
    generic map (INIT => '0', SRTYPE => "SYNC", DDR_CLK_EDGE => "OPPOSITE_EDGE") -- bit
    port map (D1 => Low, D2 => High, CE => High, C => int_tx_pixel_clk,
                S => Low, R => Low, Q => int_tx_pxlclk_out);
---------------------------------------------------------------------------------------------
-- TRANSMITTER/RECEIVER CORE
-- generic/attribute values are set for the default Si560 generated frequency of 156 MHz.
--  period = 6.410, bit rate = 1092 (156x7)
---------------------------------------------------------------------------------------------
TxdRxd : entity xil_defaultlib.TxRx_5x2_7to1_Toplevel
    generic map (
        N                   => 2,
        D                   => 5,
        --
        TX_DATA_FORMAT      => "PER_CLOCK",
        TX_MMCM_MODE        => 1,
        TX_MMCM_MODE_REAL   => 1.000,
        TX_CLOCK            => "BUF_G",
        TX_INTER_CLOCK      => "BUF_G",
        TX_PIXEL_CLOCK      => "BUF_G",
        TX_USE_PLL          => FALSE,
        TX_CLKIN_PERIOD     => 6.410,
        TX_DIFF_TERM        => TRUE,
        TX_CLK_FORM         => "3/4",
        --
        RX_SAMPL_CLOCK      => "BUF_G",
        RX_INTER_CLOCK      => "BUF_G",
        RX_PIXEL_CLOCK      => "BUF_G",
        RX_USE_PLL          => FALSE,
        RX_HIGH_PERFORMANCE_MODE => "FALSE",
        RX_CLKIN_PERIOD     => 6.410,
        RX_MMCM_MODE        => 1,
        RX_MMCM_MODE_REAL   => 1.000,
        RX_REF_FREQ         => 200.0,
        RX_DIFF_TERM        => TRUE,
        RX_DATA_FORMAT      => "PER_CLOCK",
        RX_BIT_RATE         => X"1092",
        RX_EN_EYE_MON       => "yes",
        RX_EN_DCD_COR       => "no ",
        RX_EN_PHS_DET       => "yes"
    )
    port map (
        -- Transmitter
        tx_freqgen_p        => tx_freqgen_p, -- in
        tx_freqgen_n        => tx_freqgen_n, -- in
        tx_reset            => int_tx_reset(0), -- in
        tx_datain           => int_txdata, -- in  [((D*N)*7)-1:0]
        tx_pixel_clk        => int_tx_pixel_clk, -- out
        tx_mmcm_lckd        => int_tx_mmcm_lckd, -- out
        clkout_p            => int_clkout_p, -- out [N-1:0]
        clkout_n            => int_clkout_n, -- out [N-1:0]
        dataout_p           => int_dataout_p, -- out [(N*D)-1:0]
        dataout_n           => int_dataout_n, -- out [(N*D)-1:0]
        -- Receiver
        clkin_p             => int_clkin_p, -- in  [N-1:0]
        clkin_n             => int_clkin_n, -- in  [N-1:0]
        datain_p            => int_datain_p, -- in  [(N*D)-1:0]
        datain_n            => int_datain_n, -- in  [(N*D)-1:0]
        rx_reset            => int_rx_reset(0), -- in
        rx_refclkin         => int_refclk, -- in  200MHz for IDELAY_CTRL
        rx_pixel_clk        => int_rx_pixel_clk, -- out
        rx_mmcm_lckdpsbs    => int_rx_mmcm_lckdpsbs, -- out [N-1:0]
        rx_clk_d4           => int_rx_clk_d4, -- out
        rx_clk_dataout      => int_rxclk_data, -- out[(7*N)-1:0]
        rx_dataout          => int_rxdall, -- out [(7*(N*D))-1:0]
        -- Debug
        tx_clkgen_state     => int_tx_clkgen_state, -- out [6:0]
        rx_bit_time_value   => int_rx_bit_time_value, -- out [4:0]
        rx_status           => int_rx_status, -- out [6:0]
        rx_eye_info         => int_rx_eye_info, -- out [(32*(D*N))-1:0]
        rx_m_delay_1hot     => int_rx_m_delay_1hot, -- out [(32*(D*N))-1:0]
        rx_debug            => int_rx_debug -- out [(((12*D)+6)*N)-1:0]
    );
---------------------------------------------------------------------------------------------
-- assign data to appropriate outputs
dataout1_p  <= int_dataout_p(4 downto 0);
dataout1_n  <= int_dataout_n(4 downto 0);
clkout1_p   <= int_clkout_p(0);
clkout1_n   <= int_clkout_n(0);
--
dataout2_p  <= int_dataout_p(9 downto 5);
dataout2_n  <= int_dataout_n(9 downto 5);
clkout2_p   <= int_clkout_p(1);
clkout2_n   <= int_clkout_n(1);
---------------------------------------------------------------------------------------------
-- Assemble the channels into a single clock and data input for the receiver core.
int_clkin_p  <= clkin2_p & clkin1_p;
int_clkin_n  <= clkin2_n & clkin1_n;
int_datain_p <= datain2_p & datain1_p;
int_datain_n <= datain2_n & datain1_n;
---------------------------------------------------------------------------------------------
-- USER TRANSMITTER APPLICATIONS
---------------------------------------------------------------------------------------------
-- 'walking one' Data generation for testing, user logic will go here
process (int_tx_pixel_clk, int_tx_mmcm_lckd)
begin
    if (int_tx_pixel_clk'event and int_tx_pixel_clk = '1') then
       if (int_tx_mmcm_lckd = '0') then
            -- Five channels of 7-bit = 35 bits.
            --int_txd1 <= "00000000000000000000000000000000001";
            int_txd1 <= int_shift_pattern;
        else
            int_txd1 <= int_txd1(33 downto 0) & int_txd1(34);
        end if;
    end if;
end process;
-- Assign int_txd1 to int_txd2. Both channels transmit the same stuff.
int_txd2 <= int_txd1;
-- Combine both channels to a single transmitter core input signal bus.
int_txdata <= int_txd2 & int_txd1;
---------------------------------------------------------------------------------------------
-- USER RECEIVER APPLICATIONS
--      int_rxdall and int_rxclk_data run in therx_pixel_clk domain
---------------------------------------------------------------------------------------------
int_rxd1 <= int_rxdall(34 downto 0);
int_rxd2 <= int_rxdall(69 downto 35);
-- Data checking for testing, user logic will go here
process (int_rx_pixel_clk, int_rx_mmcm_lckdpsbs(1))
begin
    if (int_rx_pixel_clk'event and int_rx_pixel_clk = '1') then
        int_old_rx1 <= int_rxd1;
        int_old_rx2 <= int_rxd2;
        if (int_rx_mmcm_lckdpsbs(1) = '0') then
            int_dummy(0) <= '0';
        elsif   int_rxd1 = int_old_rx1(33 downto 0) & int_old_rx1(34) and
                int_rxd2 = int_old_rx2(33 downto 0) & int_old_rx2(34) then
            int_dummy(0) <= '1';
        else
            int_dummy(0) <= '0';
        end if;
    end if;
end process;
--
process (int_rx_pixel_clk, int_rx_reset(0))
begin
    if (int_rx_pixel_clk'event and int_rx_pixel_clk = '1') then
        int_dummytoobuf <= int_dummy(0);
    end if;
end process;
--
obuf_dummy : OBUF
    generic map (IOSTANDARD => "LVCMOS25", DRIVE => 12, SLEW => "SLOW")
    port map (I => int_dummytoobuf, O => rx_dummy);
--
--
--
--
---------------------------------------------------------------------------------------------
-- VIO and Logic around the VIO
-- ILA and ILA Logic.
---------------------------------------------------------------------------------------------
Gen_2 : if C_DebugChnl = "Chnl2" generate
    Gen_Ln : if C_DebugLane = "Ln5" generate
        vio_regs25 : process (int_refclk)
        begin
        if (int_refclk'event and int_refclk = '1') then
            int_dbg_rx_eye_info     <= int_rx_eye_info(319 downto 288);
            int_dbg_rx_m_delay_1hot <= int_rx_m_delay_1hot(319 downto 288);
            int_dbg_rx_s_delay_val  <= int_rx_debug(131 downto 127);
            int_dbg_rx_m_delay_val  <= int_rx_debug(106 downto 102);
            int_dbg_rx_dcw_action   <= int_rx_debug(75 downto 74);
        end if;
        end process;
    elsif C_DebugLane = "Ln4" generate
        vio_regs24 : process (int_refclk)
        begin
        if (int_refclk'event and int_refclk = '1') then
            int_dbg_rx_eye_info     <= int_rx_eye_info(287 downto 256);
            int_dbg_rx_m_delay_1hot <= int_rx_m_delay_1hot(287 downto 256);
            int_dbg_rx_s_delay_val  <= int_rx_debug(126 downto 122);
            int_dbg_rx_m_delay_val  <= int_rx_debug(101 downto 97);
            int_dbg_rx_dcw_action   <= int_rx_debug(73 downto 72);
        end if;
        end process;
    elsif C_DebugLane = "Ln3" generate
        vio_regs23 : process (int_refclk)
        begin
        if (int_refclk'event and int_refclk = '1') then
            int_dbg_rx_eye_info     <= int_rx_eye_info(255 downto 224);
            int_dbg_rx_m_delay_1hot <= int_rx_m_delay_1hot(255 downto 224);
            int_dbg_rx_s_delay_val  <= int_rx_debug(121 downto 117);
            int_dbg_rx_m_delay_val  <= int_rx_debug(96 downto 92);
            int_dbg_rx_dcw_action   <= int_rx_debug(71 downto 70);
        end if;
        end process;
    elsif C_DebugLane = "Ln2" generate
        vio_regs22 : process (int_refclk)
        begin
        if (int_refclk'event and int_refclk = '1') then
            int_dbg_rx_eye_info     <= int_rx_eye_info(223 downto 192);
            int_dbg_rx_m_delay_1hot <= int_rx_m_delay_1hot(223 downto 192);
            int_dbg_rx_s_delay_val  <= int_rx_debug(116 downto 112);
            int_dbg_rx_m_delay_val  <= int_rx_debug(91 downto 87);
            int_dbg_rx_dcw_action   <= int_rx_debug(69 downto 68);
        end if;
        end process;
    elsif C_DebugLane = "Ln1" generate
        vio_regs21 : process (int_refclk)
        begin
        if (int_refclk'event and int_refclk = '1') then
            int_dbg_rx_eye_info     <= int_rx_eye_info(191 downto 160);
            int_dbg_rx_m_delay_1hot <= int_rx_m_delay_1hot(191 downto 160);
            int_dbg_rx_s_delay_val  <= int_rx_debug(111 downto 107);
            int_dbg_rx_m_delay_val  <= int_rx_debug(86 downto 82);
            int_dbg_rx_dcw_action   <= int_rx_debug(67 downto 66);
        end if;
        end process;
    end generate Gen_Ln;
    vio_regs2 : process (int_refclk)
    begin
    if (int_refclk'event and int_refclk = '1') then
        int_dbg_rx_bitslip          <= int_rx_debug(81 downto 81);
        int_dbg_rx_c_delay_val      <= int_rx_debug(80 downto 76);
        int_dbg_rx_bit_time_value   <= int_rx_bit_time_value;
        int_dbg_rx_status           <= int_rx_status;
        int_dbg_tx_clkgen_state     <= int_tx_clkgen_state;
        int_dbg_tx_mmcm_lckd(0)     <= int_tx_mmcm_lckd;
        int_dbg_d0_rx_mmcm_lckdpsbs <= int_rx_mmcm_lckdpsbs;
        int_dbg_rxclk_data          <= int_rxclk_data(13 downto 7);
    end if;
    end process;
end generate Gen_2;
--
Gen_1 : if C_DebugChnl = "Chnl1" generate
    Gen_Ln : if C_DebugLane = "Ln5" generate
        vio_regs15 : process (int_refclk)
        begin
        if (int_refclk'event and int_refclk = '1') then
            int_dbg_rx_eye_info     <= int_rx_eye_info(159 downto 128);
            int_dbg_rx_m_delay_1hot <= int_rx_m_delay_1hot(159 downto 128);
            int_dbg_rx_s_delay_val  <= int_rx_debug(65 downto 61);
            int_dbg_rx_m_delay_val  <= int_rx_debug(40 downto 36);
            int_dbg_rx_dcw_action   <= int_rx_debug(9 downto 8);
        end if;
        end process;
    elsif C_DebugLane = "Ln4" generate
        vio_regs14 : process (int_refclk)
        begin
        if (int_refclk'event and int_refclk = '1') then
            int_dbg_rx_eye_info     <= int_rx_eye_info(127 downto 96);
            int_dbg_rx_m_delay_1hot <= int_rx_m_delay_1hot(127 downto 96);
            int_dbg_rx_s_delay_val  <= int_rx_debug(60 downto 56);
            int_dbg_rx_m_delay_val  <= int_rx_debug(35 downto 31);
            int_dbg_rx_dcw_action   <= int_rx_debug(7 downto 6);
        end if;
        end process;
    elsif C_DebugLane = "Ln3" generate
        vio_regs13 : process (int_refclk)
        begin
        if (int_refclk'event and int_refclk = '1') then
            int_dbg_rx_eye_info     <= int_rx_eye_info(95 downto 64);
            int_dbg_rx_m_delay_1hot <= int_rx_m_delay_1hot(95 downto 64);
            int_dbg_rx_s_delay_val  <= int_rx_debug(55 downto 51);
            int_dbg_rx_m_delay_val  <= int_rx_debug(30 downto 26);
            int_dbg_rx_dcw_action   <= int_rx_debug(5 downto 4);
        end if;
        end process;
    elsif C_DebugLane = "Ln2" generate
        vio_regs12 : process (int_refclk)
        begin
        if (int_refclk'event and int_refclk = '1') then
            int_dbg_rx_eye_info     <= int_rx_eye_info(63 downto 32);
            int_dbg_rx_m_delay_1hot <= int_rx_m_delay_1hot(63 downto 32);
            int_dbg_rx_s_delay_val  <= int_rx_debug(50 downto 46);
            int_dbg_rx_m_delay_val  <= int_rx_debug(25 downto 21);
            int_dbg_rx_dcw_action   <= int_rx_debug(3 downto 2);
        end if;
        end process;
    elsif C_DebugLane = "Ln1" generate
        vio_regs11 : process (int_refclk)
        begin
        if (int_refclk'event and int_refclk = '1') then
            int_dbg_rx_eye_info     <= int_rx_eye_info(31 downto 0);
            int_dbg_rx_m_delay_1hot <= int_rx_m_delay_1hot(31 downto 0);
            int_dbg_rx_s_delay_val  <= int_rx_debug(45 downto 41);
            int_dbg_rx_m_delay_val  <= int_rx_debug(20 downto  16);
            int_dbg_rx_dcw_action   <= int_rx_debug(1 downto 0);
        end if;
        end process;
    end generate Gen_Ln;
    vio_regs1 : process (int_refclk)
    begin
    if (int_refclk'event and int_refclk = '1') then
        int_dbg_rx_bitslip          <= int_rx_debug(15 downto 15);
        int_dbg_rx_c_delay_val      <= int_rx_debug(14 downto 10);
        int_dbg_rx_bit_time_value   <= int_rx_bit_time_value;
        int_dbg_rx_status           <= int_rx_status;
        int_dbg_tx_clkgen_state     <= int_tx_clkgen_state;
        int_dbg_tx_mmcm_lckd(0)     <= int_tx_mmcm_lckd;
        int_dbg_d0_rx_mmcm_lckdpsbs <= int_rx_mmcm_lckdpsbs;
        int_dbg_rxclk_data          <= int_rxclk_data(6 downto 0);
    end if;
    end process;
end generate Gen_1;
---------------------------------------------------------------------------------------------
-- VIO Outputs
-- Operation:
--      1 i2c, RX and TX reset high (design in reset).
--      2 Determine the clock frequency to program the SI560.
--          Examples:
--          Frequency of Si570 must be set in KHz.
--               | Wanted     | Program |
--               | frequency  | value   |
--               |------------|---------|
--               | 100 MHz    | 0186A0  |
--               | 120 MHz    | 01D4C0  |
--               | 140 MH\    | 0222E0  |
--               | 156 MHz    | 026160  | <-- default
--               |            |         |
--      3 Enter the value in: *int_freq_value*, or leave the default value.
--      4 Release the clock generator reset *int_i2c_reset*.
--      5 Toggle *int_prog_freq* (make '1' and then '0' again.)
--      6 Watch *int_freq_acq* and *int_freq_rdy*, these must go to '1'.
--      7 Set a shift value in *int_shift_pattern*, or leave the default value.
--      8 Release tx_reset (= 0).
--      9 Release rx_reset (= 0).
--      - watch the dummy output.
---------------------------------------------------------------------------------------------
-- VIO inputs -- values to check!
-- All status and control signals to the VIO are registered by the rx_clk_d4 clock in the
-- TxRx_5x2_7to1_Toplevel design. rx_clk_d4 is the clock used to generate the signals down
-- in the hierarchy. all signals are in the level also registered by the clock used for
-- the VIO. Timing (CDC) must then brige only from FF to FF).
--
-- int_tx_clkgen_state
--      Status bus, shows the clock buffers used in the transmitter.
--      00 = BUFG, 01 = BUFR, 10 = BUFH
--      6 = 0, 54 = rxclk, 32 = rxclk_d4, 10 = pixel_clock.
-- int_rx_bit_time_value
--      In the master calculated 5-bit bit time value for slave devices.
--      Value passed from master to slaves.
-- int_rx_status
--      Status bus, shows the clock buffers used in the receiver.
--      00 = BUFG, 01 = BUFR, 10 = BUFH
--      6 = MMCM/PLL (MMCM = 1)
--      54 = rxclk, 32 = rxclk_d4, 10 = pixel_clock
-- int_rx_eye_info
--      eye info from slaves & master (32-bit per channel).(D=5, N=2)
--              (32*5)*2 = 320
--                  rxn [319:160], rx0=[159:0]
--              chnl    4,       3,     2,      1,    0
--                  [159:128][127:96][95:64][63:32][31:0]
-- int_rx_m_delay_1hot
--      Master delay control value as a one-hot vector.
--      Bus representing all channels (32-bit*D)*N  (D=5, N=2)
--              (32*5)*2 = 320
--                  rxn [319:160], rx0=[159:0]
--              chnl    4,       3,     2,      1,    0
--                  [159:128][127:96][95:64][63:32][31:0]
-- debug
--      Debug bus for slave & master receiver -- [(((10*D)+8)*N)-1:0]
--              (((10*D)+8)*N)-1:0 for (D=5, N=2) = 116
--                  rxn = [115:58], rx0 = [57:0]
--      debug <= s_delay_val_in & m_delay_val_in & bslip & c_delay_in & int_dcw_debug;
--              s_delay_val_in = Slave delay control value
--              m_delay_val_in = Master delay control value
--              bslip = Bitslip control
--              c_delay_in = delay value found on clock line.
--              int_dcw_debug = acton in delay_controller_wrap.
--      s_delay_val_in & m_delay_val_in & bslip & c_delay_in & int_dcw_debug;
--          25-bit          25-bit         bit      5-bit        2-bits
--          [57:33]         [32:8]          7       [6:2]         [10]
--             |              |
--             +--------------+-------> Chnl   4,      3,     2,    1,   0
--                                          [24:20] [19:15][14:10][9:5][4:0]

---------------------------------------------------------------------------------------------
Gen_10 : if C_Simulation = "no " generate
    ctrl_vio : entity xil_defaultlib.Ctrl_Vio
        port map (
            clk         => int_refclk,
            probe_in0   => int_dummy,                   -- 1-bit
            probe_in1   => int_freq_acq,                -- 1-bit
            probe_in2   => int_freq_rdy,                -- 1-bit
            probe_in3   => LowVec(0 downto 0),          -- 1-bit
            probe_in4   => int_dbg_rx_eye_info,         -- 32-bit
            probe_in5   => int_dbg_rx_m_delay_1hot,     -- 32-bit
            probe_in6   => int_dbg_rx_s_delay_val,      -- 5-bit
            probe_in7   => int_dbg_rx_m_delay_val,      -- 5-bit
            probe_in8   => int_dbg_rx_c_delay_val,      -- 5-bit
            probe_in9   => int_dbg_rx_bit_time_value,   -- 5-bit
            probe_in10  => int_dbg_rx_bitslip,          -- 1-bit
            probe_in11  => int_dbg_rx_dcw_action,       -- 2-bit
            probe_in12  => int_dbg_rx_status,           -- 7-bit
            probe_in13  => int_dbg_tx_clkgen_state,     -- 7-bit
            probe_in14  => LowVec(0 downto 0),          -- 1-bit
            probe_in15  => int_dbg_tx_mmcm_lckd,        -- 1-bits`
            probe_in16  => int_dbg_d0_rx_mmcm_lckdpsbs, -- 2-bit
            probe_in17  => int_dbg_rxclk_data,          -- 7-bit
            probe_in18  => LowVec(6 downto 0),          -- 7-bit
            --
            probe_out0  => int_tx_reset,        -- 1-bit  preprogrammed to '1' = reset
            probe_out1  => int_rx_reset,        -- 1-bit  preprogrammed to '1' = reset
            probe_out2  => int_i2c_reset,       -- 1-bit  preprogrammed to '1' = reset
            probe_out3  => int_shift_pattern,   -- 35-bit preprogrammed "0x000000001"
            probe_out4  => int_freq_value,      -- 24-bit preprogrammed to "0x026160" or 156.25MHz
            probe_out5  => int_prog_freq,       -- 1-bit
            probe_out6  => open,                -- 1-bit
            probe_out7  => open                 -- 1-bit
        );
elsif C_Simulation = "yes" generate
    Sim_probe_in4   <= int_dbg_rx_eye_info;         -- 32-bit
    Sim_probe_in5   <= int_dbg_rx_m_delay_1hot;     -- 32-bit
    Sim_probe_in6   <= int_dbg_rx_s_delay_val;      -- 5-bit
    Sim_probe_in7   <= int_dbg_rx_m_delay_val;      -- 5-bit
    Sim_probe_in8   <= int_dbg_rx_c_delay_val;      -- 5-bit
    Sim_probe_in9   <= int_dbg_rx_bit_time_value;   -- 5-bit
    Sim_probe_in10  <= int_dbg_rx_bitslip;          -- 1-bit
    Sim_probe_in11  <= int_dbg_rx_dcw_action;       -- 2-bit
    Sim_probe_in12  <= int_dbg_rx_status;           -- 7-bit
    Sim_probe_in13  <= int_dbg_tx_clkgen_state;     -- 7-bit
    Sim_probe_in15  <= int_dbg_tx_mmcm_lckd;        -- 1-bits`
    Sim_probe_in16  <= int_dbg_d0_rx_mmcm_lckdpsbs; -- 2-bit
    --
    int_tx_reset        <= Sim_probe_out0;   -- 1-bit
    int_rx_reset        <= Sim_probe_out1;   -- 1-bit
    int_shift_pattern   <= Sim_probe_out3;   -- 35-bit
    --
    int_i2c_reset       <= HighVec(0 downto 0);       -- 1-bit
    int_freq_value      <= LowVec(23 downto 0);
    int_prog_freq       <= LowVec(0 downto 0);
end generate Gen_10;
---------------------------------------------------------------------------------------------
-- ILA
-- The outputs of the receiver are registered before entering the ILA.
-- CDC FF pipe to go from pixel clock to rxclk_d4.
-- If C_Simulation is "no " instantiate the ILA core else do not instantiate the core and
-- just keep the nets with a KEEP attribute for simulation purposes.
---------------------------------------------------------------------------------------------
Gen_12 : if C_Simulation = "no " generate
    process (int_rx_pixel_clk)
    begin
        if (int_rx_pixel_clk'event and int_rx_pixel_clk = '1') then
            int_dbg_d1_rx_mmcm_lckdpsbs(0) <= int_rx_mmcm_lckdpsbs(1);
            int_dbg_rxd1    <= int_rxdall(34 downto 0);
            int_dbg_rxd2    <= int_rxdall(69 downto 35);
            int_ila_rx_mmcm_lckdpsbs(0) <= int_dbg_d1_rx_mmcm_lckdpsbs(0);
            int_ila_rxd1    <= int_dbg_rxd1;
            int_ila_rxd2    <= int_dbg_rxd2;
        end if;
    end process;
    --
    ctrl_ila : entity xil_defaultlib.Ctrl_Ila
        port map (
            clk     => int_rx_pixel_clk,
            probe0  => int_ila_rx_mmcm_lckdpsbs(0 downto 0),    -- 1-bit
            probe1  => int_ila_rxd1(6 downto 0),    -- 7-bit
            probe2  => int_ila_rxd1(13 downto 7),   -- 7-bit
            probe3  => int_ila_rxd1(20 downto 14),  -- 7-bit
            probe4  => int_ila_rxd1(27 downto 21),  -- 7-bit
            probe5  => int_ila_rxd1(34 downto 28),  -- 7-bit
            probe6  => LowVec(6 downto 0),          -- 7-bit
            probe7  => int_ila_rxd2(6 downto 0),    -- 7-bit
            probe8  => int_ila_rxd2(13 downto 7),   -- 7-bit
            probe9  => int_ila_rxd2(20 downto 14),  -- 7-bit
            probe10 => int_ila_rxd2(27 downto 21),  -- 7-bit
            probe11 => int_ila_rxd2(34 downto 28),  -- 7-bit
            probe12 => LowVec(6 downto 0),          -- 7-bit
            probe13 => LowVec(19 downto 0),         -- 20-bit
            probe14 => LowVec(19 downto 0)          -- 20-bit
        );
elsif C_Simulation = "yes" generate
    process (int_rx_pixel_clk)
    begin
        if (int_rx_pixel_clk'event and int_rx_pixel_clk = '1') then
            int_dbg_d1_rx_mmcm_lckdpsbs(0) <= int_rx_mmcm_lckdpsbs(1);
            int_dbg_rxd1    <= int_rxdall(34 downto 0);
            int_dbg_rxd2    <= int_rxdall(69 downto 35);
        end if;
    end process;
end generate Gen_12;
---------------------------------------------------------------------------------------------
-- I2C Clock Controller
-- Picoblaze for control
-- req_frec = Required frequency in KHz, eg 100 MHz would be X"0186A0".
-- program = Pulse high (one cycle) to reprogram si570.
-- ready = High when i570 has been programmed.
-- ack = High when an ACK was received.
--
-- The I2c is controlled by the VIO and the frequency to program the Si570
-- is default set to 156 MHz (calculate the hex value for a frequency in KHz)
-- Examples:
--      | Wanted     | Program |
--      | frequency  | value   |
--      |------------|---------|
--      | 100 MHz    | 0186A0  |
--      | 120 MHz    | 01D4C0  |
--      | 140 MHz    | 0222E0  |
--      | 156 MHz    | 026160  | <- default
--      |            |         |
-- If the design C_Simulation generic/attribute is set to "no " then instantiate the I2C core
-- If the design C_Simulation generic/attribute is set to "yes" then DO NOT instantiate the
-- I2C core and pull the tristate nets to the IOBUF-fers high (tristate).
-- The inputs to the I2C core coming from the VIO are pulled to a level at the VIO core.
---------------------------------------------------------------------------------------------
refclk_bufr : BUFR
    generic map (BUFR_DIVIDE => "4", SIM_DEVICE => "7SERIES")
    port map (I => int_refclk_bufg, CE => High, CLR => Low, O => int_clki2c);
--
i2c_data_obuf : OBUFT
    generic map (IOSTANDARD => "LVCMOS25", DRIVE => 12, SLEW => "SLOW")
    port map (I => Low, T => int_i2c_data_out,  O => i2c_data);
i2c_data_ibuf : IBUF
    generic map (IOSTANDARD => "LVCMOS25", IBUF_LOW_PWR => TRUE)
    port map (I => i2c_data, O => int_i2c_data_in);
i2c_clock_obuf : OBUFT
    generic map (IOSTANDARD => "LVCMOS25", DRIVE => 12, SLEW => "SLOW")
    port map (I => Low, T => int_i2c_clock_out, O => i2c_clock);
i2c_clock_ibuf : IBUF
    generic map (IOSTANDARD => "LVCMOS25", IBUF_LOW_PWR => TRUE)
    port map (I => i2c_clock, O => int_i2c_clock_in);
    --
Gen_20 : if C_Simulation = "no " generate
    i2c_0 : entity Osc_Control_Lib.i2c_controller
        port map (
        clk          => int_clki2c,
        rst          => int_i2c_reset(0),
        program      => int_prog_freq(0),
        req_freq     => int_freq_value,
        sda_out      => int_i2c_data_out,
        scl_out      => int_i2c_clock_out,
        sda_in       => int_i2c_data_in,
        scl_in       => int_i2c_clock_in,
        ack          => int_freq_acq(0),
        ready        => int_freq_rdy(0)
        ) ;
elsif C_Simulation = "yes" generate
    int_i2c_data_out    <= '1';
    int_i2c_clock_out   <= '1';
end generate Gen_20;
--
---------------------------------------------------------------------------------------------
end TxRx_5x2_7to1_Appslevel_arch;
