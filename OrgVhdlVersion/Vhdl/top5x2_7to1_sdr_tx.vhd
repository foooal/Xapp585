------------------------------------------------------------------------------
-- Copyright (c) 2012-2015 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.2
--  \   \        Filename: top5x2_7to1_sdr_tx.vhd
--  /   /        Date Last Modified:  21JAN2015
-- /___/   /\    Date Created: 2SEP2011
-- \   \  /  \
--  \___\/\___\
-- 
--Device: 	7-Series
--Purpose:  	SDR top level transmitter example - 2 channels of 5-bits each
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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all ;

library unisim ;
use unisim.vcomponents.all ;

entity top5x2_7to1_sdr_tx is port (
	freqgen_p,  freqgen_n		:  in std_logic ;  				-- pixel rate frequency generator clock input
	reset				:  in std_logic ;                     		-- reset (active high)
	clkout1_p,  clkout1_n		: out std_logic ;             			-- lvds channel 1 clock output
	dataout1_p, dataout1_n		: out std_logic_vector(4 downto 0) ;  		-- lvds channel 1 data outputs
	clkout2_p,  clkout2_n		: out std_logic ;             			-- lvds channel 2 clock output
	dataout2_p, dataout2_n		: out std_logic_vector(4 downto 0)) ;  		-- lvds channel 2 data outputs
end top5x2_7to1_sdr_tx ;

architecture arch_top5x2_7to1_sdr_tx of top5x2_7to1_sdr_tx is

component n_x_serdes_7_to_1_diff_sdr generic (
	N 			: integer := 8 ;				-- Set the number of channels
	D 			: integer := 6	;				-- Set the number of outputs per channel
	DATA_FORMAT 		: string := "PER_CLOCK") ;			-- Used to determine method for mapping input parallel word to output serial words
port 	(
	txclk			:  in std_logic ;				-- IO Clock network
	reset			:  in std_logic ;				-- Reset line
	txclk_div		:  in std_logic ;				-- clock at pixel rate
	datain			:  in std_logic_vector(D*N*7-1 downto 0) ;	-- Data for output
	clk_pattern		:  in std_logic_vector(6 downto 0) ;		-- clock pattern for output
	dataout_p		: out std_logic_vector(D*N-1 downto 0) ;  	-- output data
	dataout_n		: out std_logic_vector(D*N-1 downto 0) ;  	-- output data
	clkout_p		: out std_logic_vector(N-1 downto 0) ;  	-- output clock
	clkout_n		: out std_logic_vector(N-1 downto 0)) ;  	-- output clock
end component ;

component clock_generator_pll_7_to_1_diff_sdr generic (
	MMCM_MODE 		: integer := 1 ;   				-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1 multiplies input clock by 7, 2 multiplies clock by 14, etc
	MMCM_MODE_REAL 		: real := 1.000 ;   				-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1.000 multiplies input clock by 7, 2.000 multiplies clock by 14, etc
	TX_CLOCK 		: string := "BUFIO" ;   			-- Parameter to set transmission clock buffer type, BUFIO, BUF_H, BUF_G
	PIXEL_CLOCK 		: string := "BUF_G" ;       			-- Parameter to set final clock buffer type, BUF_R, BUF_H, BUF_G
	USE_PLL 		: boolean := FALSE ;          			-- Parameter to enable PLL use rather than MMCM use, note, PLL does not support BUFIO and BUFR
	CLKIN_PERIOD		: real := 6.000 ;				-- clock period (ns) of input clock on clkin_p
	DIFF_TERM		: boolean := TRUE) ;				-- Enable or disable internal differential termination
port 	(
	reset			:  in std_logic ;               		-- reset (active high)
	clkin_p, clkin_n	:  in std_logic ;               		-- differential clock input
	txclk			: out std_logic ;             			-- CLK for serdes
	pixel_clk		: out std_logic ;             			-- CLKDIV for serdes, and gearbox output = pixel clock / 2
	status			: out std_logic_vector(6 downto 0) ;		-- Status bus
	mmcm_lckd		: out std_logic) ; 				-- Locked output from MMCM
end component ;

-- Parameters 

constant D 	: integer := 5 ;						-- Set the number of outputs per channel to be 5 in this example
constant N 	: integer := 2 ;						-- Set the number of channels to be 2 in this example

-- Parameter for clock generation

constant TX_CLK_GEN : std_logic_vector(6 downto 0) := "1100001" ;		-- Transmit a constant to make a 3:4 clock, two ticks in advance of bit0 of the data word
--constant TX_CLK_GEN : std_logic_vector(6 downto 0) := "1100011" ;		-- OR Transmit a constant to make a 4:3 clock, two ticks in advance of bit0 of the data word
				
signal 	txd1			: std_logic_vector(34 downto 0)  ;	
signal 	txd2			: std_logic_vector(34 downto 0)  ;	
signal 	txdata			: std_logic_vector(69 downto 0)  ;	
signal 	pixel_clk		: std_logic  ;
signal	tx_bufpll_lckd 		: std_logic  ;
signal 	tx_bufg_pll_x1 		: std_logic  ;
signal	txclk			: std_logic  ;
signal	not_tx_mmcm_lckd	: std_logic  ;
signal 	clkout_p		: std_logic_vector(1 downto 0)  ;
signal 	clkout_n		: std_logic_vector(1 downto 0)  ;
signal 	dataout_p		: std_logic_vector(9 downto 0)  ;
signal 	dataout_n		: std_logic_vector(9 downto 0)  ;
signal	tx_mmcm_lckd		: std_logic  ;

begin
	
-- Clock Input

clkgen : clock_generator_pll_7_to_1_diff_sdr generic map(
	DIFF_TERM		=> TRUE,
	PIXEL_CLOCK		=> "BUF_G",
	TX_CLOCK		=> "BUF_G",
	USE_PLL			=> TRUE,
	MMCM_MODE		=> 2,				-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1 multiplies input clock by 7, 2 multiplies clock by 14, etc
	MMCM_MODE_REAL		=> 2.000,			-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1.000 multiplies input clock by 7, 2.000 multiplies clock by 14, etc
	CLKIN_PERIOD 		=> 10.000)
port map (                        
	reset			=> reset,
	clkin_p			=> freqgen_p,
	clkin_n			=> freqgen_n,
	txclk			=> txclk,
	pixel_clk		=> pixel_clk,
	status			=> open,
	mmcm_lckd		=> tx_mmcm_lckd) ;

not_tx_mmcm_lckd <= not tx_mmcm_lckd ;

-- Transmitter Logic for N D-bit channels

-- combine channel transmitter data

txdata <= txd2 & txd1 ;

dataout : n_x_serdes_7_to_1_diff_sdr generic map(
      	D			=> D,
      	N			=> N,				-- 2 channels
	DATA_FORMAT 		=> "PER_CLOCK") 		-- PER_CLOCK or PER_CHANL data formatting
port map (
	dataout_p  		=> dataout_p,
	dataout_n  		=> dataout_n,
	clkout_p  		=> clkout_p,
	clkout_n  		=> clkout_n,
	txclk    		=> txclk,
	txclk_div    		=> pixel_clk,
	reset   		=> not_tx_mmcm_lckd,
	clk_pattern  		=> TX_CLK_GEN,			-- Transmit a constant to make the clock
	datain  		=> txdata);

-- assign data to appropriate outputs

dataout1_p <= dataout_p(4 downto 0) ;	dataout1_n <= dataout_n(4 downto 0) ;
clkout1_p <= clkout_p(0) ;		clkout1_n <= clkout_n(0) ;
	
dataout2_p <= dataout_p(9 downto 5) ;	dataout2_n <= dataout_n(9 downto 5) ;
clkout2_p <= clkout_p(1) ;		clkout2_n <= clkout_n(1) ;

-- 'walking one' Data generation for testing, user logic will go here

process (pixel_clk) begin
if pixel_clk'event and pixel_clk = '1' then
	if tx_mmcm_lckd = '0' then
		txd1 <= "00000000000000000000000000000000001" ;
	else
		txd1 <= txd1(33 downto 0) & txd1(34) ;
	end if ; 
end if ;
end process ;
      	
txd2 <= txd1 ;
      
end arch_top5x2_7to1_sdr_tx ;