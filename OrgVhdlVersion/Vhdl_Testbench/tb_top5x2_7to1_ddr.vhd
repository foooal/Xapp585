------------------------------------------------------------------------------
-- Copyright (c) 2012-2015 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.2
--  \   \        Filename: tb_top5x2_7to1_ddr.vhd
--  /   /        Date Last Modified:  21JAN2015
-- /___/   /\    Date Created: 2SEP2011
-- \   \  /  \
--  \___\/\___\
-- 
--Device: 	7-Series
--Purpose:  	SDR test bench example - 2 channels of 5-bits each
--
--Reference:	XAPP585
--    
--Revision History:
--    Rev 1.0 - First created (nicks)
--    Rev 1.2 - Updated format (brandond)
------------------------------------------------------------------------------
--
--  Disclaimer: 
--
--		This disclaimer is not a license and does not grant any rights to the materials 
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
--		Xilinx products are not designed or intended to be fail-safe, or for use in any application 
--		requiring fail-safe performance, such as life-support or safety devices or systems, 
--		Class III medical devices, nuclear facilities, applications related to the deployment of airbags,
--		or any other applications that could lead to death, personal injury, or severe property or 
--		environmental damage (individually and collectively, "Critical Applications"). Customer assumes 
--		the sole risk and liability of any use of Xilinx products in Critical Applications, subject only 
--		to applicable laws and regulations governing limitations on product liability.
--
--  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all ;

library unisim ;
use unisim.vcomponents.all ;

entity tb_top5x2_7to1_ddr is end tb_top5x2_7to1_ddr ;

architecture rtl of tb_top5x2_7to1_ddr is

component top5x2_7to1_ddr_tx port (
	freqgen_p,  freqgen_n		:  in std_logic ;  				-- pixel rate frequency generator clock input
	reset				:  in std_logic ;                     		-- reset (active high)
	clkout1_p,  clkout1_n		: out std_logic ;             			-- lvds channel 1 clock output
	dataout1_p, dataout1_n		: out std_logic_vector(4 downto 0) ;  		-- lvds channel 1 data outputs
	clkout2_p,  clkout2_n		: out std_logic ;             			-- lvds channel 2 clock output
	dataout2_p, dataout2_n		: out std_logic_vector(4 downto 0)) ;  		-- lvds channel 2 data outputs
end component;

component top5x2_7to1_ddr_rx port (
	reset				:  in std_logic ;                     		-- reset (active high)
	refclkin			:  in std_logic ;                     		-- Reference clock for input delay control
	clkin1_p,  clkin1_n		:  in std_logic ;                     		-- lvds channel 1 clock input
	datain1_p, datain1_n		:  in std_logic_vector(4 downto 0) ;  		-- lvds channel 1 data inputs
	clkin2_p,  clkin2_n		:  in std_logic ;                     		-- lvds channel 2 clock input
	datain2_p, datain2_n		:  in std_logic_vector(4 downto 0) ;  		-- lvds channel 2 data inputs
	dummy	 			: out std_logic) ; 				-- Dummy output for test
end component;
	
signal clk200 		: std_logic := '0' ;
signal reset 		: std_logic := '1' ;
signal clkout1_p 	: std_logic ;
signal clkout1_n 	: std_logic ;
signal clkout2_p 	: std_logic ;
signal clkout2_n 	: std_logic ;
signal dataout1_p	: std_logic_vector(4 downto 0) ;
signal dataout1_n	: std_logic_vector(4 downto 0) ;
signal dataout2_p	: std_logic_vector(4 downto 0) ;
signal dataout2_n	: std_logic_vector(4 downto 0) ;
signal match 		: std_logic ;
signal pixelclock_p	: std_logic := '0' ;
signal pixelclock_n	: std_logic ;

begin

clk200 <= not clk200 after 2.5 nS ;			-- 200 Mhz clock
pixelclock_p <= not pixelclock_p after 3.3 nS ;		-- pixel clock
pixelclock_n <= not pixelclock_p ;
reset <= '0' after 150 nS;

tx : top5x2_7to1_ddr_tx port map(
	freqgen_p			=> pixelclock_p,  
	freqgen_n			=> pixelclock_n,
	reset				=> reset,
	clkout1_p			=> clkout1_p,  
	clkout1_n			=> clkout1_n,
	dataout1_p			=> dataout1_p, 
	dataout1_n			=> dataout1_n,
	clkout2_p			=> clkout2_p,  
	clkout2_n			=> clkout2_n,
	dataout2_p			=> dataout2_p, 
	dataout2_n			=> dataout2_n) ;

rx : top5x2_7to1_ddr_rx port map(
	reset				=> reset,
	refclkin			=> clk200,
	clkin1_p                        => clkout1_p,
	clkin1_n			=> clkout1_n,	
	datain1_p               	=> dataout1_p,	
	datain1_n			=> dataout1_n,	
	clkin2_p                	=> clkout2_p,	
	clkin2_n			=> clkout2_n,	
	datain2_p               	=> dataout2_p,	
	datain2_n			=> dataout2_n,	
	dummy	 			=> match) ;	
		
end rtl ;
