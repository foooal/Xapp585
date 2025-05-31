------------------------------------------------------------------------------
-- Copyright (c) 2012-2015 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.2
--  \   \        Filename: n_x_serdes_1_to_7_mmcm_idelay_sdr.vhd
--  /   /        Date Last Modified:  21JAN2015
-- /___/   /\    Date Created: 2SEP2011
-- \   \  /  \
--  \___\/\___\
-- 
--Device: 	7 Series
--Purpose:  	Wrapper for multiple 1 to 7 receiver clock and data receiver using one MMCM for clock multiplication
--
--Reference:	XAPP585
--    
--Revision History:
--    Rev 1.0 - First created (nicks)
--    Rev 1.1 - Generate loop changed to correct problem when only one channel
--    Rev 1.2 - Eye monitoring added, updated format
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

entity n_x_serdes_1_to_7_mmcm_idelay_sdr is generic (
	N 			: integer := 8 ;				-- Set the number of channels
	D 			: integer := 8 ;				-- Set the number of inputs
	SAMPL_CLOCK 		: string := "BUFIO" ;   			-- Parameter to set sampling clock buffer type, BUFIO, BUF_H, BUF_G
	PIXEL_CLOCK 		: string := "BUF_R" ;      			-- Parameter to set pixel clock buffer type, BUFR, BUF_H, BUF_G
	USE_PLL     		: boolean := FALSE ;          			-- Parameter to enable PLL use rather than MMCM use, note, PLL does not support BUFIO and BUFR
 	CLKIN_PERIOD		: real := 6.000 ;				-- clock period (ns) of input clock on clkin_p
 	HIGH_PERFORMANCE_MODE 	: string := "FALSE" ;				-- Parameter to set HIGH_PERFORMANCE_MODE of input delays to reduce jitter
      	MMCM_MODE		: integer := 1 ;				-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1 multiplies input clock by 7, 2 multiplies clock by 14, etc
      	MMCM_MODE_REAL		: real := 1.000 ;				-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1.000 multiplies input clock by 7, 2.000 multiplies clock by 14, etc
	DIFF_TERM		: boolean := FALSE ;				-- Enable or disable internal differential termination
	DATA_FORMAT 		: string := "PER_CLOCK") ;			-- Used to determine method for mapping input parallel word to output serial words
port 	(
	clkin_p			:  in std_logic_vector(N-1 downto 0) ;		-- Input from LVDS clock pin
	clkin_n			:  in std_logic_vector(N-1 downto 0) ;		-- Input from LVDS clock pin
	datain_p		:  in std_logic_vector(D*N-1 downto 0) ;	-- Input from LVDS receiver pin
	datain_n		:  in std_logic_vector(D*N-1 downto 0) ;	-- Input from LVDS receiver pin
	enable_phase_detector	:  in std_logic ;				-- Enables the phase detector logic when high
	enable_monitor		:  in std_logic ;				-- Enables the monitor logic when high, note time-shared with phase detector function
	reset			:  in std_logic ;				-- Reset line
	idelay_rdy		:  in std_logic ;				-- input delays are ready
	rxclk			: out std_logic ;				-- Global/BUFIO rx clock network
	rxclk_div		: out std_logic ;				-- Global/Regional clock output
	rx_mmcm_lckd		: out std_logic ;				-- MMCM locked, synchronous to rxclk_div
	rx_mmcm_lckdps		: out std_logic ;				-- MMCM locked and phase shifting finished, synchronous to rxclk_div
	rx_mmcm_lckdpsbs	: out std_logic_vector(N-1 downto 0) ;		-- MMCM locked and phase shifting finished and bitslipping finished, synchronous to rxclk_div
	clk_data		: out std_logic_vector(7*N-1 downto 0) ;  	-- received clock data
	rx_data			: out std_logic_vector((7*N*D)-1 downto 0) ;  	-- Output data
	bit_rate_value		:  in std_logic_vector(15 downto 0) ;	 	-- Bit rate in Mbps, eg 16'h0585
	bit_time_value		: out std_logic_vector(4 downto 0) ;		-- Calculated bit time value for slave devices
	status			: out std_logic_vector(6 downto 0) ;		-- Status bus
	eye_info		: out std_logic_vector(32*D*N-1 downto 0) ;  	-- Eye info
	m_delay_1hot		: out std_logic_vector(32*D*N-1 downto 0) ;  	-- Master delay control value as a one-hot vector
	debug			: out std_logic_vector((10*D+6)*N-1 downto 0)) ; -- Debug bus
end n_x_serdes_1_to_7_mmcm_idelay_sdr ;
		
architecture arch_n_x_serdes_1_to_7_mmcm_idelay_sdr of n_x_serdes_1_to_7_mmcm_idelay_sdr is
                                        	
component serdes_1_to_7_mmcm_idelay_sdr is generic (
	D 			: integer := 8 ;				-- Set the number of inputs
	SAMPL_CLOCK 		: string := "BUFIO" ;   			-- Parameter to set sampling clock buffer type, BUFIO, BUF_H, BUF_G
	PIXEL_CLOCK 		: string := "BUF_R" ;      			-- Parameter to set intermediate clock buffer type, BUFR, BUF_H, BUF_G
	USE_PLL     		: boolean := FALSE ;          			-- Parameter to enable PLL use rather than MMCM use, note, PLL does not support BUFIO and BUFR
 	CLKIN_PERIOD		: real := 6.000 ;				-- clock period (ns) of input clock on clkin_p
 	HIGH_PERFORMANCE_MODE 	: string := "FALSE" ;				-- Parameter to set HIGH_PERFORMANCE_MODE of input delays to reduce jitter
      	MMCM_MODE		: integer := 1 ;				-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1 multiplies input clock by 7, 2 multiplies clock by 14, etc
      	MMCM_MODE_REAL		: real := 1.000 ;				-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1.000 multiplies input clock by 7, 2.000 multiplies clock by 14, etc
	DIFF_TERM		: boolean := FALSE ;				-- Enable or disable internal differential termination
	DATA_FORMAT 		: string := "PER_CLOCK") ;			-- Used to determine method for mapping input parallel word to output serial words
port 	(
	clkin_p			:  in std_logic ;				-- Input from LVDS clock pin
	clkin_n			:  in std_logic ;				-- Input from LVDS clock pin
	datain_p		:  in std_logic_vector(D-1 downto 0) ;		-- Input from LVDS receiver pin
	datain_n		:  in std_logic_vector(D-1 downto 0) ;		-- Input from LVDS receiver pin
	enable_phase_detector	:  in std_logic ;				-- Enables the phase detector logic when high
	enable_monitor		:  in std_logic ;				-- Enables the monitor logic when high, note time-shared with phase detector function
	reset			:  in std_logic ;				-- Reset line
	idelay_rdy		:  in std_logic ;				-- input delays are ready
	rxclk			: out std_logic ;				-- Global/BUFIO rx clock network
	rxclk_div		: out std_logic ;				-- Global/Regional clock output
	rx_mmcm_lckd		: out std_logic ;				-- MMCM locked, synchronous to rxclk_div
	rx_mmcm_lckdps		: out std_logic ;				-- MMCM locked and phase shifting finished, synchronous to rxclk_div
	rx_mmcm_lckdpsbs	: out std_logic ;				-- MMCM locked and phase shifting finished and bitslipping finished, synchronous to rxclk_div
	clk_data		: out std_logic_vector(6 downto 0) ;  		-- received clock data
	rx_data			: out std_logic_vector((7*D)-1 downto 0) ;  	-- Output data
	bit_rate_value		:  in std_logic_vector(15 downto 0) ;	 	-- Bit rate in Mbps, eg X"0585
	bit_time_value		: out std_logic_vector(4 downto 0) ;		-- Calculated bit time value for slave devices
	rst_iserdes		: out std_logic ;				-- reset serdes output
	status			: out std_logic_vector(6 downto 0) ;		-- Status bus
	eye_info		: out std_logic_vector(32*D-1 downto 0) ;  	-- Eye info
	m_delay_1hot		: out std_logic_vector(32*D-1 downto 0) ;  	-- Master delay control value as a one-hot vector
	debug			: out std_logic_vector(10*D+5 downto 0)) ;  	-- Debug bus
end component ;

component serdes_1_to_7_slave_idelay_sdr is generic (
	D 			: integer := 8 ;				-- Set the number of inputs and outputs
 	HIGH_PERFORMANCE_MODE 	: string := "FALSE" ;				-- Parameter to set HIGH_PERFORMANCE_MODE of input delays to reduce jitter
	DIFF_TERM		: boolean := FALSE ;				-- Enable or disable internal differential termination
	DATA_FORMAT 		: string := "PER_CLOCK") ;			-- Used to determine method for mapping input parallel word to output serial words
port 	(
	clkin_p			:  in std_logic ;				-- Input from LVDS clock pin
	clkin_n			:  in std_logic ;				-- Input from LVDS clock pin
	datain_p		:  in std_logic_vector(D-1 downto 0) ;		-- Input from LVDS receiver pin
	datain_n		:  in std_logic_vector(D-1 downto 0) ;		-- Input from LVDS receiver pin
	enable_phase_detector	:  in std_logic ;				-- Enables the phase detector logic when high
	enable_monitor		:  in std_logic ;				-- Enables the monitor logic when high, note time-shared with phase detector function
	reset			:  in std_logic ;				-- Reset line
	idelay_rdy		:  in std_logic ;				-- input delays are ready
	rxclk			:  in std_logic ;				-- Global/BUFIO rx clock network
	rxclk_div		:  in std_logic ;				-- Global/Regional clock output
	bitslip_finished	: out std_logic ;				-- bitslipping finished, synchronous to rxclk_div
	clk_data		: out std_logic_vector(6 downto 0) ;  		-- received clock data
	rx_data			: out std_logic_vector((7*D)-1 downto 0) ;  	-- Output data
	bit_time_value		:  in std_logic_vector(4 downto 0) ;		-- Calculated bit time value for slave devices
	rst_iserdes		:  in std_logic ;				-- reset serdes input
	eye_info		: out std_logic_vector(32*D-1 downto 0) ;  	-- Eye info
	m_delay_1hot		: out std_logic_vector(32*D-1 downto 0) ;  	-- Master delay control value as a one-hot vector
	debug			: out std_logic_vector(10*D+5 downto 0)) ;  	-- Debug bus
end component ;

signal	rxclk_int	 	: std_logic ;
signal	not_rx_mmcm_lckdps 	: std_logic ;
signal	rxclk_div_int	 	: std_logic ;
signal	rx_mmcm_lckdps_int 	: std_logic ;
signal	bit_time_value_int	: std_logic_vector(4 downto 0) ;
signal	rst_iserdes	 	: std_logic ;

begin

rxclk <= rxclk_int ;
rxclk_div <= rxclk_div_int ;
rx_mmcm_lckdps <= rx_mmcm_lckdps_int ;
bit_time_value <= bit_time_value_int ;

rx0 : serdes_1_to_7_mmcm_idelay_sdr generic map(
	SAMPL_CLOCK		=> SAMPL_CLOCK,
	PIXEL_CLOCK		=> PIXEL_CLOCK,
	USE_PLL			=> USE_PLL,
 	HIGH_PERFORMANCE_MODE 	=> HIGH_PERFORMANCE_MODE,
      	D			=> D,				
      	CLKIN_PERIOD		=> CLKIN_PERIOD,		
      	MMCM_MODE		=> MMCM_MODE,				
      	MMCM_MODE_REAL		=> MMCM_MODE_REAL,			
	DIFF_TERM		=> DIFF_TERM,
	DATA_FORMAT 		=> DATA_FORMAT)
port map (                      
	clkin_p   		=> clkin_p(0),
	clkin_n   		=> clkin_n(0),
	datain_p     		=> datain_p(D-1 downto 0),
	datain_n     		=> datain_n(D-1 downto 0),
	enable_phase_detector	=> enable_phase_detector,
	enable_monitor		=> enable_monitor,
	rxclk    		=> rxclk_int,
	idelay_rdy		=> idelay_rdy,
	rxclk_div		=> rxclk_div_int,
	reset     		=> reset,
	rx_mmcm_lckd		=> rx_mmcm_lckd,
	rx_mmcm_lckdps		=> rx_mmcm_lckdps_int,
	rx_mmcm_lckdpsbs	=> rx_mmcm_lckdpsbs(0),
	clk_data  		=> clk_data(6 downto 0),
	rx_data			=> rx_data(7*D-1 downto 0),
	bit_rate_value		=> bit_rate_value,
	bit_time_value		=> bit_time_value_int,
	rst_iserdes		=> rst_iserdes,
	status			=> status,
	eye_info		=> eye_info(32*D-1 downto 0),
	m_delay_1hot		=> m_delay_1hot(32*D-1 downto 0),
	debug			=> debug(10*D+5 downto 0));

not_rx_mmcm_lckdps <= not rx_mmcm_lckdps_int ;

loop1 : if (N > 1) generate begin
  loop0 : for i in 1 to N-1 generate begin
  
  rxn : serdes_1_to_7_slave_idelay_sdr generic map(
        D			=> D,				-- Number of data lines
   	HIGH_PERFORMANCE_MODE 	=> HIGH_PERFORMANCE_MODE,
  	DIFF_TERM		=> DIFF_TERM,
  	DATA_FORMAT 		=> DATA_FORMAT)
  port map (                      
  	clkin_p   		=> clkin_p(i),
  	clkin_n   		=> clkin_n(i),
  	datain_p     		=> datain_p(D*(i+1)-1 downto D*i),
  	datain_n     		=> datain_n(D*(i+1)-1 downto D*i),
  	enable_phase_detector	=> enable_phase_detector,
	enable_monitor		=> enable_monitor,
  	rxclk    		=> rxclk_int,
  	idelay_rdy		=> idelay_rdy,
  	rxclk_div		=> rxclk_div_int,
  	reset     		=> not_rx_mmcm_lckdps,
  	bitslip_finished	=> rx_mmcm_lckdpsbs(i),
  	clk_data  		=> clk_data(7*i+6 downto 7*i),
  	rx_data			=> rx_data((D*(i+1)*7)-1 downto D*i*7),
  	bit_time_value		=> bit_time_value_int,
  	rst_iserdes		=> rst_iserdes,
	eye_info		=> eye_info(32*D*(i+1)-1 downto 32*D*i),
	m_delay_1hot		=> m_delay_1hot((32*D)*(i+1)-1 downto (32*D)*i),
  	debug			=> debug((10*D+6)*(i+1)-1 downto (10*D+6)*i));
  
  end generate ;
end generate ;
end arch_n_x_serdes_1_to_7_mmcm_idelay_sdr ;

