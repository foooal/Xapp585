##############################################################################
## Copyright (c) 2012-2015 Xilinx, Inc.
## This design is confidential and proprietary of Xilinx, All Rights Reserved.
##############################################################################
##   ____  ____
##  /   /\/   /
## /___/  \  /   Vendor: Xilinx
## \   \   \/    Version: 1.2
##  \   \        Filename: top5x2_7to1_ddr_tx.xdc
##  /   /        Date Last Modified:  02Mar2018
## /___/   /\    Date Created: 30JUN2012
## \   \  /  \
##  \___\/\___\
## 
##Device: 	7 Series
##Purpose:  	DDR transmitter timing constraints for Vivado
##
##Reference:	XAPP585.pdf
##    
##Revision History:
##    Rev 1.0 - First created (nicks)
##    Rev 1.2 - Updated format (brandond)
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
# In sdc, all clocks are related by default. This differs from ucf, where clocks are unrelated unless specified otherwise. 
# DDR transmitter timing constraints
#----------------------------------------------------------------------------------------------
create_clock -add -name freqgen_p -period 5.833 [get_ports freqgen_p]
#----------------------------------------------------------------------------------------------
# Pin constraints
#   Design used on a KC705 Xilinx Development Board (XC7K325T-FFG900 -2).
#   Connections to the FMC connector, FMC_LPC_LA...
#   All input available in the IO-Bank 13   
#----------------------------------------------------------------------------------------------
                                                                          
set_property PACKAGE_PIN 	AB27 	[get_ports freqgen_p]; 		
set_property PACKAGE_PIN 	AC27 	[get_ports freqgen_n]; 		
set_property PACKAGE_PIN 	AD23 	[get_ports clkout1_p];		
set_property PACKAGE_PIN 	AE24 	[get_ports clkout1_n];		
set_property PACKAGE_PIN 	AC24	[get_ports {dataout1_p[0]}];
set_property PACKAGE_PIN 	AD24 	[get_ports {dataout1_n[0]}];
set_property PACKAGE_PIN 	AB24 	[get_ports {dataout1_p[1]}];
set_property PACKAGE_PIN 	AC25 	[get_ports {dataout1_n[1]}];
set_property PACKAGE_PIN 	AK23 	[get_ports {dataout1_p[2]}];
set_property PACKAGE_PIN 	AK24 	[get_ports {dataout1_n[2]}];
set_property PACKAGE_PIN 	AE25 	[get_ports {dataout1_p[3]}];
set_property PACKAGE_PIN 	AF25 	[get_ports {dataout1_n[3]}];
set_property PACKAGE_PIN 	AJ22 	[get_ports {dataout1_p[4]}];
set_property PACKAGE_PIN 	AJ23 	[get_ports {dataout1_n[4]}];
set_property PACKAGE_PIN 	AE23 	[get_ports clkout2_p];		
set_property PACKAGE_PIN 	AF23 	[get_ports clkout2_n];		
set_property PACKAGE_PIN 	AD21 	[get_ports {dataout2_p[0]}];
set_property PACKAGE_PIN 	AE21 	[get_ports {dataout2_n[0]}];
set_property PACKAGE_PIN 	AA20 	[get_ports {dataout2_p[1]}];
set_property PACKAGE_PIN 	AB20 	[get_ports {dataout2_n[1]}];
set_property PACKAGE_PIN 	AJ24 	[get_ports {dataout2_p[2]}];
set_property PACKAGE_PIN 	AK25 	[get_ports {dataout2_n[2]}];
set_property PACKAGE_PIN 	AG25 	[get_ports {dataout2_p[3]}];
set_property PACKAGE_PIN 	AH25 	[get_ports {dataout2_n[3]}];
set_property PACKAGE_PIN 	AG22 	[get_ports {dataout2_p[4]}];
set_property PACKAGE_PIN 	AH22 	[get_ports {dataout2_n[4]}];

set_property IOSTANDARD 	LVDS_25 [get_ports freqgen_p];		# Example placements
set_property IOSTANDARD 	LVDS_25 [get_ports freqgen_n];		# Example placements
set_property IOSTANDARD 	LVDS_25 [get_ports clkout1_p];			
set_property IOSTANDARD 	LVDS_25 [get_ports clkout1_n];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout1_p[0]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout1_n[0]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout1_p[1]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout1_n[1]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout1_p[2]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout1_n[2]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout1_p[3]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout1_n[3]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout1_p[4]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout1_n[4]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports clkout2_p];			
set_property IOSTANDARD 	LVDS_25 [get_ports clkout2_n];		
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout2_p[0]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout2_n[0]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout2_p[1]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout2_n[1]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout2_p[2]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout2_n[2]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout2_p[3]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout2_n[3]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout2_p[4]}];	
set_property IOSTANDARD 	LVDS_25 [get_ports {dataout2_n[4]}];	

#set_property PACKAGE_PIN 	AE23 	[get_ports {refclkin}];                                                                         
#set_property PACKAGE_PIN 	Y20 	[get_ports {reset}];                                                                      
#set_property PACKAGE_PIN 	Y23 	[get_ports {dummy}];                                                                      

#set_property IOSTANDARD 	LVCMOS25 [get_ports refclkin];		# Example placement
#set_property IOSTANDARD 	LVCMOS25 [get_ports reset];		# Example placement    
#set_property IOSTANDARD 	LVCMOS25 [get_ports dummy];		# Example placement    