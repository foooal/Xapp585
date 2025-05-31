------------------------------------------------------------------------------
-- Copyright (c) 2012-2015 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.2
--  \   \        Filename: top5x2_7to1_sdr_rx.vhd
--  /   /        Date Last Modified: 21JAN2015
-- /___/   /\    Date Created: 2SEP2011
-- \   \  /  \
--  \___\/\___\
-- 
--Device: 	7-Series
--Purpose:  	SDR top level receiver example - 2 channels of 5-bits each
--
--Reference:	XAPP585
--    
--Revision History:
--    Rev 1.0 - First created (nicks)
--    Rev 1.1 - BUFG added to IDELAY reference clock
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

entity top5x2_7to1_sdr_rx is port (
	reset				:  in std_logic ;                     		-- reset (active high)
	refclkin			:  in std_logic ;                     		-- Reference clock for input delay control
	clkin1_p,  clkin1_n		:  in std_logic ;                     		-- lvds channel 1 clock input
	datain1_p, datain1_n		:  in std_logic_vector(4 downto 0) ;  		-- lvds channel 1 data inputs
	clkin2_p,  clkin2_n		:  in std_logic ;                     		-- lvds channel 2 clock input
	datain2_p, datain2_n		:  in std_logic_vector(4 downto 0) ;  		-- lvds channel 2 data inputs
	dummy	 			: out std_logic) ; 				-- Dummy output for test
end top5x2_7to1_sdr_rx ;

architecture arch_top5x2_7to1_sdr_rx of top5x2_7to1_sdr_rx is

component n_x_serdes_1_to_7_mmcm_idelay_sdr generic (
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
end component ;

-- Parameters

constant D 	: integer := 5 ;						-- Set the number of inputs per channel to be 5 in this example
constant N 	: integer := 2 ;						-- Set the number of channels to be 2 in this example

signal 	rxd1			: std_logic_vector(34 downto 0)  ; 
signal 	rxd2			: std_logic_vector(34 downto 0)  ; 
signal 	old_rx1			: std_logic_vector(34 downto 0)  ; 
signal 	old_rx2			: std_logic_vector(34 downto 0)  ;
signal	refclkint 		: std_logic ;
signal	refclkintbufg 		: std_logic ;
signal	rx_mmcm_lckdps		: std_logic ;
signal	rx_mmcm_lckdpsbs	: std_logic_vector(1 downto 0) ;
signal	rxclk_div		: std_logic  ;
signal 	clkin_p			: std_logic_vector(1 downto 0)  ;
signal 	clkin_n			: std_logic_vector(1 downto 0)  ;
signal 	datain_p		: std_logic_vector(9 downto 0)  ;
signal 	datain_n		: std_logic_vector(9 downto 0)  ;
signal 	rxdall			: std_logic_vector(69 downto 0)  ;
signal	delay_ready		: std_logic  ;
signal 	channel_1_errors	: std_logic_vector(34 downto 0)  ;
signal 	channel_2_errors	: std_logic_vector(34 downto 0)  ;
signal	rx_mmcm_lckd		: std_logic  ;

begin

-- 200 or 300 Mhz Generator Clock Input

iob_200m_in : IBUF port map (
	I    			=> refclkin,
	O         		=> refclkint);

bufg_200_ref : BUFG port map(
	I 			=> refclkint, 
	O 			=> refclkintbufg) ;
	
icontrol : IDELAYCTRL port map(               			-- Instantiate input delay control block
	REFCLK			=> refclkintbufg,
	RST			=> reset,
	RDY			=> delay_ready);

-- Input clock and data for 2 channels
	
clkin_p  <= clkin2_p & clkin1_p ;
clkin_n  <= clkin2_n & clkin1_n ;
datain_p <= datain2_p & datain1_p ;
datain_n <= datain2_n & datain1_n ;
	
rx0 : n_x_serdes_1_to_7_mmcm_idelay_sdr generic map(
	N			=> 2,				-- Number of channels
	SAMPL_CLOCK		=> "BUF_G",
	PIXEL_CLOCK		=> "BUF_G",
	USE_PLL			=> FALSE,
 	HIGH_PERFORMANCE_MODE 	=> "FALSE",
      	D			=> D,				-- Number of data lines
      	CLKIN_PERIOD		=> 10.000,			-- Set input clock period
      	MMCM_MODE		=> 2,				-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1 multiplies input clock by 7, 2 multiplies clock by 14, etc
      	MMCM_MODE_REAL		=> 2.000,			-- Parameter to set multiplier for MMCM to get VCO in correct operating range. 1.000 multiplies input clock by 7, 2.000 multiplies clock by 14, etc
	DIFF_TERM		=> TRUE,
	DATA_FORMAT 		=> "PER_CLOCK") 		-- PER_CLOCK or PER_CHANL data formatting
port map (                           
	clkin_p   		=> clkin_p,
	clkin_n   		=> clkin_n,
	datain_p     		=> datain_p,
	datain_n     		=> datain_n,
	enable_phase_detector	=> '1',				-- enable phase detector operation
	enable_monitor		=> '0',				-- enables data eye monitoring
	rxclk    		=> open,
	idelay_rdy		=> delay_ready,
	rxclk_div		=> rxclk_div,
	reset     		=> reset,
	rx_mmcm_lckd		=> rx_mmcm_lckd,
	rx_mmcm_lckdps		=> rx_mmcm_lckdps,
	rx_mmcm_lckdpsbs	=> rx_mmcm_lckdpsbs,
	clk_data  		=> open,
	rx_data			=> rxdall,
	bit_rate_value		=> X"0700",			-- required bit rate value in BCD
	bit_time_value		=> open,
	status			=> open,
	eye_info		=> open,			-- data eye monitor per line
	m_delay_1hot		=> open,			-- sample point monitor per line
	debug			=> open) ;			-- debug bus

rxd1 <= rxdall(34 downto 0) ;
rxd2 <= rxdall(69 downto 35) ;

-- Data checking for testing, user logic will go here

process (rxclk_div)	begin
if rxclk_div'event and rxclk_div = '1' then
	old_rx1 <= rxd1 ;
	old_rx2 <= rxd2 ;
	if rx_mmcm_lckdpsbs(1) = '0' then
		dummy <= '0' ;
	elsif rxd1 = old_rx1(33 downto 0) & old_rx1(34) and rxd2 = old_rx2(33 downto 0) & old_rx2(34) then
		dummy <= '1' ;
	else
		dummy <= '0' ;
	end if ; 
end if ;
end process ;
      	
end arch_top5x2_7to1_sdr_rx ;