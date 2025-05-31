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
-- Device:              7_series
-- Author:              Defossez
-- Entity Name:         TxRx_5x2_7to1_Appslevel_Tester
-- Purpose:             File with stimuli for the designs test bench
-- Tools:               QuestaSim_10.5b
-- Limitations:  TESTBENCH / STIMULUS and VHDL-2008
--               DON'T USE THIS FILE FOR COMPILATION NOR INTEGRATION.
--
-- Vendor:              Xilinx Inc.
-- Version:             V!.0
-- Filename:            TxRx_5x2_7to1_Appslevel_Tester.vhd
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
--  Rev.
--
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
    use IEEE.std_logic_textio.all;
    use std.textio.all;
    use IEEE.std_logic_arith.all;
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
entity TxRx_5x2_7to1_Appslevel_Tester is
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
end TxRx_5x2_7to1_Appslevel_Tester;
---------------------------------------------------------------------------------------------
-- Architecture Declarations
---------------------------------------------------------------------------------------------
architecture TxRx_5x2_7to1_Appslevel_Tester_flow of TxRx_5x2_7to1_Appslevel_Tester is
---------------------------------------------------------------------------------------------
-- Signals and constants
constant Low                : std_logic := '0';
constant LowVec             : std_logic_vector(255 downto 0) := (others => '0');
constant High               : std_logic := '1';
--constant C_ClockPeriod      : time := C_ClockPeriod ;
--constant C_RefClkPeriod     : time := C_RefClkPeriod;
--
signal Int_tx_freqgen_p        : std_logic;
signal Int_tx_freqgen_n        : std_logic;
--signal Int_clkout1_p           : std_logic;
--signal Int_clkout1_n           : std_logic;
--signal Int_dataout1_p          : std_logic_vector(4 downto 0);
--signal Int_dataout1_n          : std_logic_vector(4 downto 0);
--signal Int_clkout2_p           : std_logic;
--signal Int_clkout2_n           : std_logic;
--signal Int_dataout2_p          : std_logic_vector(4 downto 0);
--signal Int_dataout2_n          : std_logic_vector(4 downto 0);
--signal Int_clkin1_p            : std_logic;
--signal Int_clkin1_n            : std_logic;
--signal Int_datain1_p           : std_logic_vector(4 downto 0);
--signal Int_datain1_n           : std_logic_vector(4 downto 0);
--signal Int_clkin2_p            : std_logic;
--signal Int_clkin2_n            : std_logic;
--signal Int_datain2_p           : std_logic_vector(4 downto 0);
--signal Int_datain2_n           : std_logic_vector(4 downto 0);
signal Int_refclkin_p          : std_logic;
signal Int_refclkin_n          : std_logic;
signal Int_rx_dummy            : std_logic;
signal Int_Si570_to_sma_p      : std_logic;
signal Int_Si570_to_sma_n      : std_logic;
signal Int_i2c_data            : std_logic;
signal Int_i2c_clock           : std_logic;
---------------------------------------------------------------------------------------------
begin
-- Connect the internal signals to the entity ports.
tx_freqgen_p        <= Int_tx_freqgen_p ;
tx_freqgen_n        <= Int_tx_freqgen_n ;
--Int_clkout1_p     <= clkout1_p        ;
--Int_clkout1_n     <= clkout1_n        ;
--Int_dataout1_p    <= dataout1_p       ;
--Int_dataout1_n    <= dataout1_n       ;
--Int_clkout2_p     <= clkout2_p        ;
--Int_clkout2_n     <= clkout2_n        ;
--Int_dataout2_p    <= dataout2_p       ;
--Int_dataout2_n    <= dataout2_n       ;
--clkin1_p          <= Int_clkin1_p     ;
--clkin1_n          <= Int_clkin1_n     ;
--datain1_p         <= Int_datain1_p    ;
--datain1_n         <= Int_datain1_n    ;
--clkin2_p          <= Int_clkin2_p     ;
--clkin2_n          <= Int_clkin2_n     ;
--datain2_p         <= Int_datain2_p    ;
--datain2_n         <= Int_datain2_n    ;
refclkin_p          <= Int_refclkin_p   ;
refclkin_n          <= Int_refclkin_n   ;
Int_rx_dummy        <= rx_dummy         ;
Int_Si570_to_sma_n  <= Si570_to_sma_p   ;
Int_Si570_to_sma_n  <= Si570_to_sma_n   ;
Int_i2c_data        <= i2c_data         ;
Int_i2c_clock       <= i2c_clock        ;
---------------------------------------------------------------------------------------------
-- Main Proces to run the simulation.
-- Assign values to inputs of the tester.
-- The result of this will be available in the waveform window of the simulator.
---------------------------------------------------------------------------------------------
MainProc : process
    begin
        -- Put some text on screen
        assert false
        report CR &
        "                                                           " & CR &
        " Simulation of the design using VHDL-2008 syntax options.  " & CR &
        "                                                           " & CR &
        " Using the powerful VHDL-2008 'external signals' extension " & CR &
        " for simulation. Thsi allows indirect read and write to    " & CR &
        " signals in teh design without the need to express them as " & CR &
        " simulation signals. See comments add to the ..._Tester.vhd" & CR &
        " source code.                                              " & CR &
        " Do not forget to specify the use of VHDL-2008 in the      " & CR &
        " modelsim.in file.                                         " & CR &
        "                                                           " & CR
        severity note;
    --
    -- Sim_probe_out0, Sim_probe_out1 and Sim_probe_out3 are signals in the source code of
    -- "TxRx_5x2_7to1TxRx_5x2_7to1_Appslevel". These signals are normally outputs of the
    -- VIO core in teh design.
    -- For simulation the VIO core is not used, but its inputs and outputs are preserved
    -- for simulation debug purposes.
    -- The VIO inputs (outputs from the design) can be used here in the ..._Tester code
    -- to observe signals (write then to a file or so) The VIO outputs (inputs to the design)
    -- can be used here in the ..._Tester code to force a state on teh signals.
    -- Behavior for simulation is that way exactly that of the VIO.
    --
    -- VIO - Sim_probe_out0 = tx_reset
    -- VIO - Sim_probe_out1 = rx_reset
    -- VIO - Sim_probe_out3 = shift_pattern
    <<signal .txrx_5x2_7to1_appslevel_testbench.UUT.Sim_probe_out0 : std_logic_vector(0  downto 0)>> <= "1";
    <<signal .txrx_5x2_7to1_appslevel_testbench.UUT.Sim_probe_out1 : std_logic_vector(0  downto 0)>> <= "1";
    <<signal .txrx_5x2_7to1_appslevel_testbench.UUT.Sim_probe_out3 : std_logic_vector(34 downto 0)>> <= "00000000000000000000000000000000000";
    wait for C_RefClkPeriod*100;
    <<signal .txrx_5x2_7to1_appslevel_testbench.UUT.Sim_probe_out3 : std_logic_vector(34 downto 0)>> <= C_Shift_Pattern;
    wait for C_RefClkPeriod*100;
    <<signal .txrx_5x2_7to1_appslevel_testbench.UUT.Sim_probe_out0 : std_logic_vector(0  downto 0)>> <= "0";
    wait for C_ClockPeriod*1000;
    <<signal .txrx_5x2_7to1_appslevel_testbench.UUT.Sim_probe_out1 : std_logic_vector(0  downto 0)>> <= "0";
    wait for C_ClockPeriod*1000;
    --
    assert false
    report "That's All Folks !"
    severity warning;
    wait;
end process MainProc;
---------------------------------------------------------------------------------------------
-- Architecture Concurrent Statements
---------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
-- Generate Clock
TheClock : process
    variable TempOne : std_logic := '0';
begin
    if (TempOne = '0') then
        wait for 100 ps;
        TempOne := '1';
    else
        Int_tx_freqgen_n <= '1';
        Int_tx_freqgen_p <= '0';
         wait for C_ClockPeriod/2;
        Int_tx_freqgen_n <= '0';
        Int_tx_freqgen_p <= '1';
        wait for C_ClockPeriod/2;
    end if;
end process;
--
TheRefClock : process
    variable TempOne : std_logic := '0';
begin
    if (TempOne = '0') then
        wait for 100 ps;
        TempOne := '1';
    else
        Int_refclkin_n <= '1';
        Int_refclkin_p <= '0';
        wait for C_RefClkPeriod/2;
        Int_refclkin_n <= '0';
        Int_refclkin_p <= '1';
        wait for C_RefClkPeriod/2;
    end if;
end process;
-------------------------------------------------------------------------------------------
end TxRx_5x2_7to1_Appslevel_Tester_flow;
