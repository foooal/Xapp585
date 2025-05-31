##############################################################################
## Copyright (c) 2012-2015 Xilinx, Inc.
## This design is confidential and proprietary of Xilinx, All Rights Reserved.
##############################################################################
##   ____  ____
##  /   /\/   /
## /___/  \  /   Vendor: Xilinx
## \   \   \/    Version: 1.2
##  \   \        Filename: top5x2_7to1_ddr_rx.xdc
##  /   /        Date Last Modified:  02MAR2018
## /___/   /\    Date Created: 30JUN2012
## \   \  /  \
##  \___\/\___\
## 
##Device: 	7 Series
##Purpose:  	DDR receiver timing constraints for Vivado
##
##Reference:	XAPP585
##    
##Revision History:
##    Rev 1.0 - First created (nicks)
##    Rev 1.2 - Updated format (brandond)
##    Rev 1.3 - Updated (defossez)
##############################################################################
##  Disclaimer: 
##		This disclaimer is not a license and does not grant any rights to the materials 
##      distributed herewith. Except as otherwise provided in a valid license issued to 
##      you by Xilinx, and to the maximum extent permitted by applicable law: 
##      (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, 
##      AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, 
##      OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, 
##      NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall 
##      not be liable (whether in contract or tort, including negligence, or under any 
##      other theory of liability) for any loss or damage of any kind or nature related
##      to, arising under or in connection with these materials, including for any 
##      direct, or any indirect, special, incidental, or consequential loss or damage 
##      (including loss of data, profits, goodwill, or any type of loss or damage 
##      suffered as a result of any action brought by a third party) even if such 
##      damage or loss was reasonably foreseeable or Xilinx had been advised of the 
##      possibility of the same.
##  Critical Applications:
##		Xilinx products are not designed or intended to be fail-safe, or for use in any 
##      application requiring fail-safe performance, such as life-support or safety devices or 
##      systems, Class III medical devices, nuclear facilities, applications related to the 
##      deployment of airbags, or any other applications that could lead to death, personal 
##      injury, or severe property or environmental damage (individually and collectively, 
##      "Critical Applications"). Customer assumes the sole risk and liability of any use of 
##      Xilinx products in Critical Applications, subject only to applicable laws and 
##      regulations governing limitations on product liability.
##
##  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
##
##############################################################################
#
# In sdc, all clocks are related by default. This differs from ucf, where clocks are 
# unrelated unless specified otherwise. 
# DDR receiver timing constraints
#----------------------------------------------------------------------------------------------
create_clock -add -name clkin1_p -period 5.833 [get_ports clkin1_p]

# Need to ignore re-timing paths from pixel clock to clk_d4 through the gearbox
#set_false_path  -from [get_pins -hier -filter {name =~ *gb0*ram_inst*}] \
#                -to [get_pins -hier -filter {name =~ *gb0*dataout*/D}]
# Below constraints create warnings in synthesis but are applied during implementation.
set_false_path  -from [get_pins {*/*/gb*/loop*[*].ram_inst/RAM*/CLK}] \
                -to [get_pins {*/*/gb*/loop*[*].dataout_reg[*]/D}]
set_false_path  -from [get_pins {*/loop1.loop*[*].rxn/gb*/loop1[*].ram_inst/RAM*/CLK}] \
                -to [get_pins {*/loop*.loop*[*].rxn/gb*/loop*[*].dataout_reg[*]/D}]
# Some domain change flip-flops
set_false_path  -to [get_pins -hier -filter {name =~ *rx*dom_ch*/D}]
set_false_path  -to [get_pins -hier -filter {name =~ *rx*dom_ch*/PRE}]
# Path from clock input to clock input serdes
set_false_path  -from [get_ports clkin1_p] \
                -to [get_pins -hier -filter {name =~ *rx*iserdes_c?/DDLY}]
#----------------------------------------------------------------------------------------------
# Pin constraints
#   Design used on a KC705 Xilinx Development Board (XC7K325T-FFG900 -2).
#   Connections to the FMC connector, FMC_LPC_LA...
#   All input available in the IO-Bank 13   
#----------------------------------------------------------------------------------------------                                                                    
set_property PACKAGE_PIN 	AB27 	[get_ports clkin1_p];
set_property PACKAGE_PIN 	AC27 	[get_ports clkin1_n];		
set_property PACKAGE_PIN 	Y30 	[get_ports {datain1_p[0]}]; 
set_property PACKAGE_PIN 	AA30 	[get_ports {datain1_n[0]}];	
set_property PACKAGE_PIN 	AB29 	[get_ports {datain1_p[1]}];	
set_property PACKAGE_PIN 	AB30 	[get_ports {datain1_n[1]}];	
set_property PACKAGE_PIN 	AK29 	[get_ports {datain1_p[2]}];	
set_property PACKAGE_PIN 	AK30 	[get_ports {datain1_n[2]}];	
set_property PACKAGE_PIN 	AE30 	[get_ports {datain1_p[3]}];	
set_property PACKAGE_PIN 	AF30 	[get_ports {datain1_n[3]}];	
set_property PACKAGE_PIN 	AC26 	[get_ports {datain1_p[4]}];	
set_property PACKAGE_PIN 	AD26 	[get_ports {datain1_n[4]}];	
set_property PACKAGE_PIN 	AD27 	[get_ports clkin2_p];			
set_property PACKAGE_PIN 	AD28 	[get_ports clkin2_n];		
set_property PACKAGE_PIN 	AD29 	[get_ports {datain2_p[0]}];	
set_property PACKAGE_PIN 	AE29 	[get_ports {datain2_n[0]}];	
set_property PACKAGE_PIN 	AE28 	[get_ports {datain2_p[1]}];	
set_property PACKAGE_PIN 	AF28 	[get_ports {datain2_n[1]}];	
set_property PACKAGE_PIN 	AJ28 	[get_ports {datain2_p[2]}];	
set_property PACKAGE_PIN 	AJ29 	[get_ports {datain2_n[2]}];	
set_property PACKAGE_PIN 	AG30 	[get_ports {datain2_p[3]}];	
set_property PACKAGE_PIN 	AH30 	[get_ports {datain2_n[3]}];	
set_property PACKAGE_PIN 	AJ27 	[get_ports {datain2_p[4]}];	
set_property PACKAGE_PIN 	AK28 	[get_ports {datain2_n[4]}];	

set_property DIFF_TERM 		TRUE 	[get_ports clkin1_p];		
set_property DIFF_TERM 		TRUE 	[get_ports clkin1_n];		
set_property DIFF_TERM 		TRUE 	[get_ports {datain1_p[0]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain1_n[0]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain1_p[1]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain1_n[1]}];	
set_property DIFF_TERM		TRUE 	[get_ports {datain1_p[2]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain1_n[2]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain1_p[3]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain1_n[3]}];	
set_property DIFF_TERM 		TRUE	[get_ports {datain1_p[4]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain1_n[4]}];	
set_property DIFF_TERM 		TRUE 	[get_ports clkin2_p];		
set_property DIFF_TERM 		TRUE 	[get_ports clkin2_n];		
set_property DIFF_TERM 		TRUE 	[get_ports {datain2_p[0]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain2_n[0]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain2_p[1]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain2_n[1]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain2_p[2]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain2_n[2]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain2_p[3]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain2_n[3]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain2_p[4]}];	
set_property DIFF_TERM 		TRUE 	[get_ports {datain2_n[4]}];	

set_property IOSTANDARD 	LVDS_25 [get_ports clkin1_p];		
set_property IOSTANDARD 	LVDS_25 [get_ports clkin1_n];
set_property IOSTANDARD 	LVDS_25 [get_ports {datain1_p[0]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain1_n[0]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain1_p[1]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain1_n[1]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain1_p[2]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain1_n[2]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain1_p[3]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain1_n[3]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain1_p[4]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain1_n[4]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports clkin2_p];		
set_property IOSTANDARD 	LVDS_25 [get_ports clkin2_n];		
set_property IOSTANDARD 	LVDS_25 [get_ports {datain2_p[0]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain2_n[0]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain2_p[1]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain2_n[1]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain2_p[2]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain2_n[2]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain2_p[3]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain2_n[3]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain2_p[4]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {datain2_n[4]}];	

set_property PACKAGE_PIN 	AE23 	[get_ports {refclkin}];                                                                         
set_property PACKAGE_PIN 	Y20 	[get_ports {reset}];                                                                      
set_property PACKAGE_PIN 	Y23 	[get_ports {dummy}];                                                                      

set_property IOSTANDARD 	LVCMOS25 [get_ports refclkin];	# Example placement
set_property IOSTANDARD 	LVCMOS25 [get_ports reset];		# Example placement    
set_property IOSTANDARD 	LVCMOS25 [get_ports dummy];		# Example placement    