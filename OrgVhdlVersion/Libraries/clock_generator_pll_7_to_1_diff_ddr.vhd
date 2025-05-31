------------------------------------------------------------------------------
-- Copyright (c) 2012-2015 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.2
--  \   \        Filename: clock_generator_pll_7_to_1_diff_ddr.vhd
--  /   /        Date Last Modified:  21JAN201
-- /___/   /\    Date Created: 1AUG2009
-- \   \  /  \
--  \___\/\___\
-- 
--Device: 	7 Series
--Purpose:  	DDR MMCM or PLL based clock generator. Takes in a differential clock and multiplies it
--		by the amount specified. 
--
--Reference:	XAPP585
--    
--Revision History:
--    Rev 1.0 - First created (nicks)
--    Rev 1.1 - Some net names changed to make more sense in Vivado
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

entity clock_generator_pll_7_to_1_diff_ddr is generic (
	MMCM_MODE 		: integer := 1 ;   			-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1 multiplies input clock by 7, 2 multiplies clock by 14, etc
	MMCM_MODE_REAL 		: real := 1.000 ;   			-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1.000 multiplies input clock by 7, 2.000 multiplies clock by 14, etc
	TX_CLOCK 		: string := "BUFIO" ;   		-- Parameter to set transmission clock buffer type, BUFIO, BUF_H, BUF_G
	INTER_CLOCK 		: string := "BUF_R" ;      		-- Parameter to set intermediate clock buffer type, BUFR, BUF_H, BUF_G
	PIXEL_CLOCK 		: string := "BUF_G" ;       		-- Parameter to set final clock buffer type, BUF_R, BUF_H, BUF_G
	USE_PLL 		: boolean := FALSE ;          		-- Parameter to enable PLL use rather than MMCM use, note, PLL does not support BUFIO and BUFR
	CLKIN_PERIOD		: real := 6.000 ;			-- clock period (ns) of input clock on clkin_p
	DIFF_TERM		: boolean := TRUE) ;			-- Enable or disable internal differential termination
port 	(                                                       	
	reset			:  in std_logic ;               	-- reset (active high)
	clkin_p, clkin_n	:  in std_logic ;               	-- differential clock input
	txclk			: out std_logic ;             		-- CLK for serdes
	pixel_clk		: out std_logic ;             		-- Pixel clock output
	txclk_div		: out std_logic ;             		-- CLKDIV for serdes, and gearbox output = pixel clock / 2
	status			: out std_logic_vector(6 downto 0) ;	-- Status bus
	mmcm_lckd		: out std_logic) ; 			-- Locked output from MMCM
end clock_generator_pll_7_to_1_diff_ddr ;

architecture arch_clock_generator_pll_7_to_1_diff_ddr of clock_generator_pll_7_to_1_diff_ddr is

signal 	clkint			: std_logic ;			--
signal 	txpllmmcm_xn		: std_logic ;			--
signal 	txpllmmcm_x1		: std_logic ;			--
signal 	txpllmmcm_d2		: std_logic ;			--
signal 	pixel_clk_int		: std_logic ;			--

begin

pixel_clk <= pixel_clk_int ;

iob_freqgen_in : IBUFGDS generic map(
	DIFF_TERM		=> DIFF_TERM)
port map (
	I    			=> clkin_p,
	IB       		=> clkin_n,
	O         		=> clkint);

loop8 : if USE_PLL = FALSE generate				-- use an MMCM

status(6) <= '1' ; 
      	
tx_mmcm_adv_inst : MMCM_ADV generic map(
      	BANDWIDTH		=> "OPTIMIZED",  		
      	CLKFBOUT_MULT_F		=> 7.000*MMCM_MODE_REAL,       	
      	CLKFBOUT_PHASE		=> 0.0,     			
      	CLKIN1_PERIOD		=> CLKIN_PERIOD,  		
      	CLKIN2_PERIOD		=> CLKIN_PERIOD,  		
      	CLKOUT0_DIVIDE_F	=> 2.000*MMCM_MODE_REAL,       	
      	CLKOUT0_DUTY_CYCLE	=> 0.5, 			
      	CLKOUT0_PHASE		=> 0.0, 			
      	CLKOUT1_DIVIDE		=> 14*MMCM_MODE,   		
      	CLKOUT1_DUTY_CYCLE	=> 0.5, 			
      	CLKOUT1_PHASE		=> 0.0, 			
      	CLKOUT2_DIVIDE		=> 7*MMCM_MODE,   		
      	CLKOUT2_DUTY_CYCLE	=> 0.5, 			
      	CLKOUT2_PHASE		=> 0.0, 			
      	CLKOUT3_DIVIDE		=> 8,   			
      	CLKOUT3_DUTY_CYCLE	=> 0.5, 			
      	CLKOUT3_PHASE		=> 0.0, 			
      	CLKOUT4_DIVIDE		=> 8,   			
      	CLKOUT4_DUTY_CYCLE	=> 0.5, 			
      	CLKOUT4_PHASE		=> 0.0,      			
      	CLKOUT5_DIVIDE		=> 8,       			
      	CLKOUT5_DUTY_CYCLE	=> 0.5, 			
      	CLKOUT5_PHASE		=> 0.0,      			
      	COMPENSATION		=> "ZHOLD",		
      	DIVCLK_DIVIDE		=> 1)         			
port map (
      	CLKFBOUT		=> txpllmmcm_x1,              	
      	CLKFBOUTB		=> open,  
      	CLKFBSTOPPED		=> open,  
      	CLKINSTOPPED		=> open,  
      	CLKOUT0			=> txpllmmcm_xn,      		
      	CLKOUT0B		=> open,  
      	CLKOUT1			=> txpllmmcm_d2,      		
      	CLKOUT1B		=> open,  
      	CLKOUT2			=> open,              		
      	CLKOUT2B		=> open,  
      	CLKOUT3			=> open,	              	
       	CLKOUT3B		=> open,  
     	CLKOUT4			=> open,              		
      	CLKOUT5			=> open,              		
      	DO			=> open,                	
      	DRDY			=> open,                	
      	PSDONE			=> open,
      	PSCLK			=> '0',
      	PSEN			=> '0',
      	PSINCDEC		=> '0',
      	PWRDWN			=> '0',
      	LOCKED			=> mmcm_lckd,        		
      	CLKFBIN			=> pixel_clk_int,		
      	CLKIN1			=> clkint,	     		
      	CLKIN2			=> '0', 	    		
      	CLKINSEL		=> '1',             		
      	DADDR			=> "0000000",            	
      	DCLK			=> '0',               		
      	DEN			=> '0',                		
      	DI			=> "0000000000000000", 		
      	DWE			=> '0',                		
      	RST			=> reset) ;               	

  loop6 : if PIXEL_CLOCK = "BUF_G" generate
     bufg_mmcm_x1 : BUFG	port map (I => txpllmmcm_x1, O => pixel_clk_int) ;
     status(1 downto 0) <= "00" ;
  end generate ;
  loop6a : if PIXEL_CLOCK = "BUF_R" generate
     bufr_mmcm_x1 : BUFR generic map(BUFR_DIVIDE => "1", SIM_DEVICE => "7SERIES") port map (I => txpllmmcm_x1,CE => '1',O => pixel_clk_int,CLR => '0') ;
     status(1 downto 0) <= "01" ;
  end generate ;
  loop6b : if PIXEL_CLOCK = "BUF_H" generate
     bufh_mmcm_x1 : BUFH	port map (I => txpllmmcm_x1, O => pixel_clk_int) ;
     status(1 downto 0) <= "10" ;
  end generate ;
  
  loop7 : if INTER_CLOCK = "BUF_G" generate
     bufg_mmcm_d4 : BUFG port map(I => txpllmmcm_d2, O => txclk_div) ;
     status(3 downto 2) <= "00" ;
  end generate ;
  loop7a : if INTER_CLOCK = "BUF_R" generate
     bufr_mmcm_d4 :  BUFR generic map(BUFR_DIVIDE => "1", SIM_DEVICE => "7SERIES") port map (I => txpllmmcm_d2,CE => '1',O => txclk_div,CLR => '0') ;
     status(3 downto 2) <= "01" ;
  end generate ;
  loop7b : if INTER_CLOCK = "BUF_H" generate
     bufh_mmcm_x1 : BUFH	port map (I => txpllmmcm_d2, O => txclk_div) ;
     status(3 downto 2) <= "10" ;
  end generate ;
  
  loop9 : if TX_CLOCK = "BUF_G" generate
     bufg_mmcm_xn : BUFG port map(I => txpllmmcm_xn, O => txclk) ;
     status(5 downto 4) <= "00" ;
  end generate ;
  loop9a : if TX_CLOCK = "BUFIO" generate
     bufio_mmcm_xn : BUFIO port map (I => txpllmmcm_xn, O => txclk) ;
     status(5 downto 4) <= "11" ;
  end generate ;
  loop9b : if TX_CLOCK = "BUF_H" generate
     bufh_mmcm_xn : BUFH port map(I => txpllmmcm_xn, O => txclk) ;
     status(5 downto 4) <= "10" ;
  end generate ;
end generate ;

loop2 : if USE_PLL = TRUE generate				-- use a PLL
	
status(6) <= '0' ; 

rx_mmcm_adv_inst : PLLE2_ADV generic map(
      	BANDWIDTH		=> "OPTIMIZED",  		
      	CLKFBOUT_MULT		=> 7*MMCM_MODE,       			
      	CLKFBOUT_PHASE		=> 0.0,     			
      	CLKIN1_PERIOD		=> CLKIN_PERIOD,  		
      	CLKIN2_PERIOD		=> CLKIN_PERIOD,  		
      	CLKOUT0_DIVIDE		=> 2*MMCM_MODE,       			
      	CLKOUT0_DUTY_CYCLE	=> 0.5, 				
      	CLKOUT0_PHASE		=> 0.0, 				
      	CLKOUT1_DIVIDE		=> 14*MMCM_MODE,   				
      	CLKOUT1_DUTY_CYCLE	=> 0.5, 				
      	CLKOUT1_PHASE		=> 0.0, 				
      	CLKOUT2_DIVIDE		=> 7*MMCM_MODE,   				
      	CLKOUT2_DUTY_CYCLE	=> 0.5, 				
      	CLKOUT2_PHASE		=> 0.0, 				
      	CLKOUT3_DIVIDE		=> 7,   				
      	CLKOUT3_DUTY_CYCLE	=> 0.5, 				
      	CLKOUT3_PHASE		=> 0.0, 				
      	CLKOUT4_DIVIDE		=> 7,   				
      	CLKOUT4_DUTY_CYCLE	=> 0.5, 				
      	CLKOUT4_PHASE		=> 0.0,      			
      	CLKOUT5_DIVIDE		=> 7,       			
      	CLKOUT5_DUTY_CYCLE	=> 0.5, 				
      	CLKOUT5_PHASE		=> 0.0,      			
      	COMPENSATION		=> "ZHOLD",		
      	DIVCLK_DIVIDE		=> 1,        		
      	REF_JITTER1		=> 0.100)        		
port map (                      
      	CLKFBOUT		=> txpllmmcm_x1,              		
      	CLKOUT0			=> txpllmmcm_xn,      		
      	CLKOUT1			=> txpllmmcm_d2,      		
      	CLKOUT2			=> open, 		
      	CLKOUT3			=> open,              		
      	CLKOUT4			=> open,              		
      	CLKOUT5			=> open,              		
      	DO			=> open,                    		
      	DRDY			=> open,                  		
      	PWRDWN			=> '0', 
      	LOCKED			=> mmcm_lckd,        		
      	CLKFBIN			=> pixel_clk_int,			
      	CLKIN1			=> clkint,     	
      	CLKIN2			=> '0',		     		
      	CLKINSEL		=> '1',             		
      	DADDR			=> "0000000",            		
      	DCLK			=> '0',               		
      	DEN			=> '0',                		
      	DI			=> X"0000",        		
      	DWE			=> '0',                		
      	RST			=> reset) ;               	

  loop4 : if PIXEL_CLOCK = "BUF_G" generate
     bufg_pll_x1 : BUFG	port map (I => txpllmmcm_x1, O => pixel_clk_int) ;
     status(1 downto 0) <= "00" ;
  end generate ;
  loop4a : if PIXEL_CLOCK = "BUF_R" generate
     bufr_pll_x1 : BUFR generic map(BUFR_DIVIDE => "1", SIM_DEVICE => "7SERIES") port map (I => txpllmmcm_x1,CE => '1',O => pixel_clk_int,CLR => '0') ;
     status(1 downto 0) <= "01" ;
  end generate ;
  loop4b : if PIXEL_CLOCK = "BUF_H" generate
     bufh_pll_x1 : BUFH	port map (I => txpllmmcm_x1, O => pixel_clk_int) ;
     status(1 downto 0) <= "10" ;
  end generate ;
  
  loop5 : if INTER_CLOCK = "BUF_G" generate
     bufg_pll_d4 : BUFG port map(I => txpllmmcm_d2, O => txclk_div) ;
     status(3 downto 2) <= "00" ;
  end generate ;
  loop5a : if INTER_CLOCK = "BUF_R" generate
     bufr_pll_d4 :  BUFR generic map(BUFR_DIVIDE => "1", SIM_DEVICE => "7SERIES") port map (I => txpllmmcm_d2,CE => '1',O => txclk_div,CLR => '0') ;
     status(3 downto 2) <= "01" ;
  end generate ;
  loop5b : if INTER_CLOCK = "BUF_H" generate
     bufh_pll_x1 : BUFH	port map (I => txpllmmcm_d2, O => txclk_div) ;
     status(3 downto 2) <= "10" ;
  end generate ;
  
  loop10 : if TX_CLOCK = "BUF_G" generate
     bufg_pll_xn : BUFG port map(I => txpllmmcm_xn, O => txclk) ;
     status(5 downto 4) <= "00" ;
  end generate ;
  loop10a : if TX_CLOCK = "BUFIO" generate
     bufio_pll_xn : BUFIO port map (I => txpllmmcm_xn, O => txclk) ;
     status(5 downto 4) <= "11" ;
  end generate ;
  loop10b : if TX_CLOCK = "BUF_H" generate
     bufh_pll_xn : BUFH port map(I => txpllmmcm_xn, O => txclk) ;
     status(5 downto 4) <= "10" ;
  end generate ;
end generate ;

end arch_clock_generator_pll_7_to_1_diff_ddr ;