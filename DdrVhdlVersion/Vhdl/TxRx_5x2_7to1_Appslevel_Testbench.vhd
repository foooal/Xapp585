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
-- Entity Name:         TxRx_5x2_7to1_Appslevel_Testbench
-- Purpose:             Create a test bench for an 5x2 7to1-1to7 Synchronous data
--                      capturing design
-- This is the simulation setup:
--
--      DTU                                       UUT
--  +-----------+                             +-----------+
--  |           |-----------------------------|           |
--  |           |-----------------------------|           |
--  |           |-----  All inputs and    ----|           |
--  |           |-----  outputs of the    ----|           |
--  |           |-----  UUT are connected ----|           |
--  |           |-----  to the DTU        ----|           |
--  |           |-----------------------------|           |
--  |           |-----------------------------|           |
--  +-----------+                             +-----------+
--      The DTU makes are all necessary signals (clocks, resets, enables, data inputs, ...)
--      are generated for the UUT to start functioning. The UUT provides its outputs
--      back to the TDU in order to let the user do something with that information.
--      Like make the simulation interactive or ...
--
--
-- Tools:               QuestaSim_10.5b and Vivado_2017.4 or higher
-- Limitations: TESTBENCH VHDL-2008
--                       DON'T USE THIS FILE FOR COMPILATION NOR INTEGRATION.
--
-- Vendor:              Xilinx Inc.
-- Version:             V.1.0
-- Filename:            TxRx_5x2_7to1_Appslevel_Testbench.vhd
-- Date Created:        Feb 2018
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
--  Rev. Jan 2018
--      Adapt the test bench to Vivado_2017.3 and QuestaSim_10.6b
--      Make the simulation more user friendly.
---------------------------------------------------------------------------------------------
-- Naming Conventions:
--  Generics start with:                                    "C_*"
--  Ports
--      All words in the label of a port name start with a upper case, AnInputPort.
--      Active low ports end in                             "*_n"
--      Active high ports of a differential pair end in:    "*_p"
--      Ports being device pins end in _pin                 "*_pin"
--      Reset ports end in:                                 "*Rst"
--      Enable ports end in:                                "*Ena", "*En"
--      Clock ports end in:                                 "*Clk", "ClkDiv", "*Clk#"
--  Signals and constants
--      Signals and constant labels start with              "Int*"
--      Registered signals end in                           "_d#"
--      User defined types:                                 "*_TYPE"
--      State machine next state:                           "*_Ns"
--      State machine current state:                        "*_Cs"
--      Counter signals end in:                             "*Cnt", "*Cnt_n"
--   Processes:                                 "<Entity_><Function>_PROCESS"
--   Component instantiations:                  "<Entity>_I_<Component>_<Function>"
---------------------------------------------------------------------------------------------
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_UNSIGNED.all;
    use STD.textio.all;
library UNISIM;
    use UNISIM.vcomponents.all;
---------------------------------------------------------------------------------------------
entity TxRx_5x2_7to1_Appslevel_Testbench is
-- Declarations
end TxRx_5x2_7to1_Appslevel_Testbench;
---------------------------------------------------------------------------------------------
architecture TxRx_5x2_7to1_Appslevel_Testbench_struct of TxRx_5x2_7to1_Appslevel_Testbench is
---------------------------------------------------------------------------------------------
-- Component Instantiation
---------------------------------------------------------------------------------------------
-- This component must reflect the setup of the entity.
component TxRx_5x2_7to1_Appslevel
    generic (
        C_DebugChnl     : string;    -- "Chnl1" or "Chnl2"
        C_DebugLane     : string;    -- "Ln1", "Ln2", "Ln3", "Ln4" or "Ln5"
        C_Simulation    : string    -- "yes", "no"
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
        -- I2C controller
        i2c_data            : inout std_logic;
        i2c_clock           : inout std_logic
    );
end component TxRx_5x2_7to1_Appslevel;
--
-- Below is the representation of the tester.
-- The generic settings for this are defined lower in this file.
component TxRx_5x2_7to1_Appslevel_Tester
    generic (
        C_ClockPeriod       : time;
        C_RefClkPeriod      : time;
        C_Shift_Pattern     : std_logic_vector(34 downto 0)
    );
    port (
        -- Transmitter
        tx_freqgen_p        : out std_logic;
        tx_freqgen_n        : out std_logic;
        --clkout1_p           : in std_logic;
        --clkout1_n           : in std_logic;
        --dataout1_p          : in std_logic_vector(4 downto 0);
        --dataout1_n          : in std_logic_vector(4 downto 0);
        --clkout2_p           : in std_logic;
        --clkout2_n           : in std_logic;
        --dataout2_p          : in std_logic_vector(4 downto 0);
        --dataout2_n          : in std_logic_vector(4 downto 0);
        -- Receiver
        --clkin1_p            : out std_logic;
        --clkin1_n            : out std_logic;
        --datain1_p           : out std_logic_vector(4 downto 0);
        --datain1_n           : out std_logic_vector(4 downto 0);
        --clkin2_p            : out std_logic;
        --clkin2_n            : out std_logic;
        --datain2_p           : out std_logic_vector(4 downto 0);
        --datain2_n           : out std_logic_vector(4 downto 0);
        -- Stuff
        refclkin_p          : out std_logic;
        refclkin_n          : out std_logic;
        rx_dummy            : in std_logic;
        Si570_to_sma_p      : in std_logic;
        Si570_to_sma_n      : in std_logic;
        -- I2C controller
        i2c_data            : inout std_logic;
        i2c_clock           : inout std_logic
    );
end component TxRx_5x2_7to1_Appslevel_Tester;
---------------------------------------------------------------------------------------------
-- Test bench constants configuration documentation.
---------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------
-- Constants:
-- Define the simulation settings here!
----------------------------------------------------------------------------------------------
--
constant Low    : std_logic := '0';
constant LowVec : std_logic_vector(255 downto 0) := (others => '0');
--
constant Sim_C_ClockPeriod   : time := 10.000 ns; -- 100 MHz     6.666 ns; -- 150 MHz
constant Sim_C_RefClkPeriod  : time := 5 ns; -- 200 MHz
constant Sim_C_DebugChnl     : string := "Chnl1"; -- "Chnl1" or "Chnl2"
constant Sim_C_DebugLane     : string := "Ln1";   -- "Ln1", "Ln2", "Ln3", "Ln4" or "Ln5"
constant Sim_C_Simulation    : string := "yes";   -- "yes", "no "
constant Sim_C_Shift_Pattern : std_logic_vector(34 downto 0) := "00000000000000000000000000000000001";
----------------------------------------------------------------------------------------------
-- Signals:
-- Connections between DTU and UUT and UUT and DTU
----------------------------------------------------------------------------------------------
signal Sim_tx_freqgen_p        : std_logic;
signal Sim_tx_freqgen_n        : std_logic;
signal Sim_clkout1_p           : std_logic;
signal Sim_clkout1_n           : std_logic;
signal Sim_dataout1_p          : std_logic_vector(4 downto 0);
signal Sim_dataout1_n          : std_logic_vector(4 downto 0);
signal Sim_clkout2_p           : std_logic;
signal Sim_clkout2_n           : std_logic;
signal Sim_dataout2_p          : std_logic_vector(4 downto 0);
signal Sim_dataout2_n          : std_logic_vector(4 downto 0);
        -- Receiver
signal Sim_clkin1_p            : std_logic;
signal Sim_clkin1_n            : std_logic;
signal Sim_datain1_p           : std_logic_vector(4 downto 0);
signal Sim_datain1_n           : std_logic_vector(4 downto 0);
signal Sim_clkin2_p            : std_logic;
signal Sim_clkin2_n            : std_logic;
signal Sim_datain2_p           : std_logic_vector(4 downto 0);
signal Sim_datain2_n           : std_logic_vector(4 downto 0);
        -- Stuff
signal Sim_refclkin_p          : std_logic;
signal Sim_refclkin_n          : std_logic;
signal Sim_rx_dummy            : std_logic;
signal Sim_Si570_to_sma_p      : std_logic;
signal Sim_Si570_to_sma_n      : std_logic;
        -- I2C comtroller
signal Sim_i2c_data            : std_logic;
signal Sim_i2c_clock           : std_logic;
--
---------------------------------------------------------------------------------------------
begin
--
Sim_clkin1_p  <= transport Sim_clkout1_p  after 100 ns;
Sim_clkin1_n  <= transport Sim_clkout1_n  after 100 ns;
Sim_datain1_p <= transport Sim_dataout1_p after 100 ns;
Sim_datain1_n <= transport Sim_dataout1_n after 100 ns;
Sim_clkin2_p  <= transport Sim_clkout2_p  after 100 ns;
Sim_clkin2_n  <= transport Sim_clkout2_n  after 100 ns;
Sim_datain2_p <= transport Sim_dataout2_p after 100 ns;
Sim_datain2_n <= transport Sim_dataout2_n after 100 ns;
--
UUT : TxRx_5x2_7to1_Appslevel
    generic map (
        C_DebugChnl         => Sim_C_DebugChnl,
        C_DebugLane         => Sim_C_DebugLane,
        C_Simulation        => Sim_C_Simulation
    )
    port map (
        -- Transmitter
        tx_freqgen_p        => Sim_tx_freqgen_p, -- in
        tx_freqgen_n        => Sim_tx_freqgen_n, -- in
        clkout1_p           => Sim_clkout1_p   , -- out
        clkout1_n           => Sim_clkout1_n   , -- out
        dataout1_p          => Sim_dataout1_p  , -- out [4:0]
        dataout1_n          => Sim_dataout1_n  , -- out [4:0]
        clkout2_p           => Sim_clkout2_p   , -- out
        clkout2_n           => Sim_clkout2_n   , -- out
        dataout2_p          => Sim_dataout2_p  , -- out [4:0]
        dataout2_n          => Sim_dataout2_n  , -- out [4:0]
        -- Receiver
        clkin1_p            => Sim_clkin1_p    , -- in
        clkin1_n            => Sim_clkin1_n    , -- in
        datain1_p           => Sim_datain1_p   , -- in  [4:0]
        datain1_n           => Sim_datain1_n   , -- in  [4:0]
        clkin2_p            => Sim_clkin2_p    , -- in
        clkin2_n            => Sim_clkin2_n    , -- in
        datain2_p           => Sim_datain2_p   , -- in  [4:0]
        datain2_n           => Sim_datain2_n   , -- in  [4:0]
        -- Stuff
        refclkin_p          => Sim_refclkin_p  , -- in
        refclkin_n          => Sim_refclkin_n  , -- in
        rx_dummy            => Sim_rx_dummy    , -- out
        Si570_to_sma_p      => Sim_Si570_to_sma_p, -- out
        Si570_to_sma_n      => Sim_Si570_to_sma_n, -- out
        -- I2C comtroller
        i2c_data            => Sim_i2c_data    , -- inout
        i2c_clock           => Sim_i2c_clock     -- inout
    );
--
DTU : TxRx_5x2_7to1_Appslevel_Tester
    generic map (
        C_ClockPeriod       => Sim_C_ClockPeriod, --
        C_RefClkPeriod      => Sim_C_RefClkPeriod, --
        C_Shift_Pattern     => Sim_C_Shift_Pattern
    )
    port map (
        -- Transmitter
        tx_freqgen_p        => Sim_tx_freqgen_p, -- out
        tx_freqgen_n        => Sim_tx_freqgen_n, -- out
        --clkout1_p           => Sim_clkout1_p   , -- in
        --clkout1_n           => Sim_clkout1_n   , -- in
        --dataout1_p          => Sim_dataout1_p  , -- in [4:0]
        --dataout1_n          => Sim_dataout1_n  , -- in [4:0]
        --clkout2_p           => Sim_clkout2_p   , -- in
        --clkout2_n           => Sim_clkout2_n   , -- in
        --dataout2_p          => Sim_dataout2_p  , -- in [4:0]
        --dataout2_n          => Sim_dataout2_n  , -- in [4:0]
        -- Receiver
        --clkin1_p            => Sim_clkin1_p    , -- out
        --clkin1_n            => Sim_clkin1_n    , -- out
        --datain1_p           => Sim_datain1_p   , -- out  [4:0]
        --datain1_n           => Sim_datain1_n   , -- out  [4:0]
        --clkin2_p            => Sim_clkin2_p    , -- out
        --clkin2_n            => Sim_clkin2_n    , -- out
        --datain2_p           => Sim_datain2_p   , -- out  [4:0]
        --datain2_n           => Sim_datain2_n   , -- out  [4:0]
        -- Stuff
        refclkin_p          => Sim_refclkin_p  , -- out
        refclkin_n          => Sim_refclkin_n  , -- out
        rx_dummy            => Sim_rx_dummy    , -- in
        Si570_to_sma_p      => Sim_Si570_to_sma_p, -- out
        Si570_to_sma_n      => Sim_Si570_to_sma_n, -- out
        -- I2C comtroller
        i2c_data            => Sim_i2c_data    , -- inout
        i2c_clock           => Sim_i2c_clock    -- inout
    );
-------------------------------------------------------------------------------------------
end TxRx_5x2_7to1_Appslevel_Testbench_struct;
--
