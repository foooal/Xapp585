------------------------------------------------------------------------------
-- Copyright (c) 2012-2015 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.2
--  \   \        Filename: n_x_serdes_7_to_1_diff_sdr.vhd
--  /   /        Date Last Modified:  21JAN2015
-- /___/   /\    Date Created: 2SEP2011
-- \   \  /  \
--  \___\/\___\
-- 
--Device: 	7-Series
--Purpose:  	SDR N channel wrapper for multiple 7:1 serdes channels
--
--Reference:	XAPP585
--    
--Revision History:
--    Rev 1.0 - First created (nicks)
--    Rev 1.2 - Updated format (brandond)
--
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

entity n_x_serdes_7_to_1_diff_sdr is generic (
	N 			: integer := 8 ;				-- Set the number of channels
	D 			: integer := 6	;				-- Set the number of outputs per channel
	DATA_FORMAT 		: string := "PER_CLOCK") ;			-- Used to determine method for mapping input parallel word to output serial words
port (                                        	
	txclk			:  in std_logic ;				-- IO Clock network
	reset			:  in std_logic ;				-- Reset line
	txclk_div		:  in std_logic ;				-- clock at pixel rate
	datain			:  in std_logic_vector(D*N*7-1 downto 0) ;	-- Data for output
	clk_pattern		:  in std_logic_vector(6 downto 0) ;		-- clock pattern for output
	dataout_p		: out std_logic_vector(D*N-1 downto 0) ;  	-- output data
	dataout_n		: out std_logic_vector(D*N-1 downto 0) ;  	-- output data
	clkout_p		: out std_logic_vector(N-1 downto 0) ;  	-- output clock
	clkout_n		: out std_logic_vector(N-1 downto 0)) ;  	-- output clock
end n_x_serdes_7_to_1_diff_sdr ;

architecture arch_n_x_serdes_7_to_1_diff_sdr of n_x_serdes_7_to_1_diff_sdr is

component serdes_7_to_1_diff_sdr is generic (
	D 			: integer := 8	;				-- Set the number of outputs
	DATA_FORMAT 		: string := "PER_CLOCK") ;			-- Used to determine method for mapping input parallel word to output serial words
port (                                     	
	txclk			:  in std_logic ;				-- IO Clock network
	reset			:  in std_logic ;				-- Reset line
	txclk_div		:  in std_logic ;				-- Global clock at pixel rate
	datain			:  in std_logic_vector(D*7-1 downto 0) ;	-- Data for output
	clk_pattern		:  in std_logic_vector(6 downto 0) ;		-- clock pattern for output
	clkout_p		: out std_logic ;				-- output clock
	clkout_n		: out std_logic ;				-- output clock
	dataout_p		: out std_logic_vector(D-1 downto 0) ;  	-- output data
	dataout_n		: out std_logic_vector(D-1 downto 0)) ;  	-- output data
end component ;

begin

loop0 : for i in 0 to N-1 generate

dataout : serdes_7_to_1_diff_sdr generic map(
      	D			=> D,
      	DATA_FORMAT		=> DATA_FORMAT)
port map (                      
	dataout_p  		=> dataout_p(D*(i+1)-1 downto D*i),
	dataout_n  		=> dataout_n(D*(i+1)-1 downto D*i),
	clkout_p  		=> clkout_p(i),
	clkout_n  		=> clkout_n(i),
	txclk    		=> txclk,
	txclk_div    		=> txclk_div,
	reset   		=> reset,
	clk_pattern  		=> clk_pattern,
	datain  		=> datain((D*(i+1)*7)-1 downto D*i*7));		

end generate ;	
end arch_n_x_serdes_7_to_1_diff_sdr ;
