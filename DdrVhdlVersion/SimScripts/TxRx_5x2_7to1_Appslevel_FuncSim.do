#--------------------------------------------------------------------------------------------
#- � Copyright 2018, Xilinx, Inc. All rights reserved.
#- This file contains confidential and proprietary information of Xilinx, Inc. and is
#- protected under U.S. and international copyright and other intellectual property laws.
#--------------------------------------------------------------------------------------------
#-
#- Disclaimer:
#-		This disclaimer is not a license and does not grant any rights to the materials
#-		distributed herewith. Except as otherwise provided in a valid license issued to you
#-		by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
#-		ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
#-		WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
#-		TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
#-		PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
#-		negligence, or under any other theory of liability) for any loss or damage of any
#-		kind or nature related to, arising under or in connection with these materials,
#-		including for any direct, or any indirect, special, incidental, or consequential
#-		loss or damage (including loss of data, profits, goodwill, or any type of loss or
#-		damage suffered as a result of any action brought by a third party) even if such
#-		damage or loss was reasonably foreseeable or Xilinx had been advised of the
#-		possibility of the same.
#-
#- CRITICAL APPLICATIONS
#-		Xilinx products are not designed or intended to be fail-safe, or for use in any
#-		application requiring fail-safe performance, such as life-support or safety devices
#-		or systems, Class III medical devices, nuclear facilities, applications related to
#-		the deployment of airbags, or any other applications that could lead to death,
#-		personal injury, or severe property or environmental damage (individually and
#-		collectively, "Critical Applications"). Customer assumes the sole risk and
#-		liability of any use of Xilinx products in Critical Applications, subject only to
#-		applicable laws and regulations governing limitations on product liability.
#-
#- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
#-
#-		Contact:    e-mail  hotline@xilinx.com        phone   + 1 800 255 7778
#-   ____  ____
#-  /   /\/   /
#- /___/  \  / 			Vendor:              Xilinx Inc.
#- \   \   \/ 			Version:             V0.01
#-  \   \        		Filename:            Byte_Top_RxTx_Prbs_FuncSim.do
#-  /   /        		Date Created:        Feb 2018
#- /___/   /\    		Date Last Modified:  Mar 2018
#- \   \  /  \
#-  \___\/\___\
#-
#- Device:          Utrascale
#- Author:          Defossez
#- Entity Name:     Byte_Top_RxTx_Prbs_FuncSim
#- Purpose:         QuestaSim simulation project file.
#- Tools:           Questa-Sim 10.5b
#- Limitations:     none
#-
#- Revision History:
#--------------------------------------------------------------------------------------------
# This script can be executed from within the QuestaSim GUI.
#   - Start Questa-Sim
#   -   Click: [Tools] tab
#   -   Select: Tcl
#   -   Select: Execute Macro
#   -       Browse to find this file (./Simscripts/Byte_TopNative_RxTx_PrbsFuncSim.do).
#   -       Select it and hit [Open].
#--------------------------------------------------------------------------------------------
# In a project the directory containing this and other simulation scripts is: ./SimScripts.
# In a project the directory containing the files used for and by simulation is: ./Simulation.
# It is assumed that QuestaSim is started from within the ./SimScripts directory.
#   Read the ReadMe.md file in the ./SimScript folder (open it with a text editor).
# It is thus necessary to change to the projects ./SimScripts directory in order to run this
# .do file from within QuestaSim.
#--------------------------------------------------------------------------------------------
cd ../Simulation
#--------------------------------------------------------------------------------------------
#- Check if there are already compiled design libraries, if not create it (name it by
#- default 'work'). Create other design libraries depending the hierarchy of the design.
#--------------------------------------------------------------------------------------------
if {![file exists work]} {
    vlib work
}
if {![file exists xil_defaultlib]} {
    vlib xil_defaultlib
}
if {![file exists osc_control_lib]} {
    vlib osc_control_lib
}
if {![file exists receiver_lib]} {
    vlib receiver_lib
}
if {![file exists transmitter_lib]} {
    vlib transmitter_lib
}
#--------------------------------------------------------------------------------------------
#- Compile the source code and drop it it in the correct library.
#-      The "-modelsimini" command attribute can be add to each or selected lines when it is
#-      necessary to use a none default modelsim.ini file. The default modelsim.ini file
#-      resides in the QuestaSim installation directory and points to the directory with
#-      Vivado compiled FPGA libraries. When QuestaSim is started it is picked up
#-      automatically, but when a specific modelsim.ini file must be used, all QuestaSim
#-      commands must have the attribute "-modelsimini" in order to find that specific
#-      modelsim.ini file.
#--------------------------------------------------------------------------------------------
#-
vcom -novopt -work xil_defaultlib   {../Libraries/Ila_Lib/Ctrl_Ila/sim/Ctrl_Ila.vhd}
vcom -novopt -work xil_defaultlib   {../Libraries/Vio_Lib/Ctrl_Vio/sim/Ctrl_Vio.vhd}
#-
vcom -novopt -work osc_control_lib  {../Libraries/Osc_Control_Lib/kcpsm6.vhd}
vcom -novopt -work osc_control_lib  {../Libraries/Osc_Control_Lib/jtag_loader_6.vhd}
vcom -novopt -work osc_control_lib  {../Libraries/Osc_Control_Lib/controller_top.vhd}
vcom -novopt -work osc_control_lib  {../Libraries/Osc_Control_Lib/i2c_controller.vhd}
#-
vcom -novopt -work receiver_lib     {../Libraries/Receiver_Lib/gearbox_4_to_7.vhd}
vcom -novopt -work receiver_lib     {../Libraries/Receiver_Lib/gearbox_4_to_7_slave.vhd}
vcom -novopt -work receiver_lib     {../Libraries/Receiver_Lib/delay_controller_wrap.vhd}
vcom -novopt -work receiver_lib     {../Libraries/Receiver_Lib/serdes_1_to_7_mmcm_idelay_ddr.vhd}
vcom -novopt -work receiver_lib     {../Libraries/Receiver_Lib/serdes_1_to_7_slave_idelay_ddr.vhd}
vcom -novopt -work receiver_lib     {../Libraries/Receiver_Lib/n_x_serdes_1_to_7_mmcm_idelay_ddr.vhd}
#-
vcom -novopt -work transmitter_lib  {../Libraries/Transmitter_Lib/clock_generator_pll_7_to_1_diff_ddr.vhd}
vcom -novopt -work transmitter_lib  {../Libraries/Transmitter_Lib/serdes_7_to_1_diff_ddr.vhd}
vcom -novopt -work transmitter_lib  {../Libraries/Transmitter_Lib/n_x_serdes_7_to_1_diff_ddr.vhd}
vcom -novopt -work transmitter_lib  {../Libraries/Transmitter_Lib/Ddr_Tx_5x2_7to1.vhd}
#-
vcom -novopt -work xil_defaultlib   {../Vhdl/TxRx_5x2_7to1_Toplevel.vhd}
vcom -novopt -work xil_defaultlib   {../Vhdl/TxRx_5x2_7to1_Appslevel.vhd}
vcom -novopt -work xil_defaultlib   {../Vhdl/TxRx_5x2_7to1_Appslevel_Tester.vhd}
vcom -novopt -work xil_defaultlib   {../Vhdl/TxRx_5x2_7to1_Appslevel_Testbench.vhd}
#--------------------------------------------------------------------------------------------
#- Simulate the design with or without SDF files.
#- Simulation with SDF files take the options -sdfmin, -sdftyp, -sdfmax.
#-      The values in the SDF files can be scaled with timing
#-                       (-sdfmax@1.5 scales the max timing by 150%)
#-      The simulation code is by default optimized (faster simulation).
#-      This is a setting in the modelsim.ini file.
#-      I've seen that this option strips sometimes signals from the design and prevents them being
#-      viewed in the waveforms. Therefore, turn the optimisation OFF.
#-      In stead of doing this in the modelsim.ini file, I add a command option to the
#-      vsim command: "-novopt".
#--------------------------------------------------------------------------------------------
# Generate top level simulation file (Without SDF).
vsim -novopt -t ps xil_defaultlib.TxRx_5x2_7to1_Appslevel_Testbench(TxRx_5x2_7to1_Appslevel_Testbench_struct)
#--------------------------------------------------------------------------------------------
#- Invoke from here the waveform file in the QuestaSim viewer.
#- The waveform file can be generated from a initial waveform setup in the GUI.
#--------------------------------------------------------------------------------------------
#- do ../SimScripts/TxRx_5x2_7to1_Appslevel_FuncWave.do
#- do ../SimScripts/TxRx_5x2_7to1_Appslevel_Tx_FreqGen_FuncWave.do
#- do ../SimScripts/TxRx_5x2_7to1_Appslevel_Tx_DataGen_FuncWave.do
#- do ../SimScripts/TxRx_5x2_7to1_Appslevel_Rx_DataClk_FuncWave.do
do ../SimScripts/TxRx_5x2_7to1_Appslevel_Rx_Apps_FuncWave.do
#--------------------------------------------------------------------------------------------
#- Run the simulation
#--------------------------------------------------------------------------------------------
run 90000000
#--------------------------------------------------------------------------------------------
