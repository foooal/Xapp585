------------------------------------------------------------------------------
-- Copyright (c) 2012-2015 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.2
--  \   \        Filename: serdes_1_to_7_slave_idelay_sdr.vhd
--  /   /        Date Last Modified:  21JAN2015
-- /___/   /\    Date Created: 2SEP2011
-- \   \  /  \
--  \___\/\___\
-- 
--Device: 	7 Series
--Purpose:  	1 to 7 SDR receiver slave data receiver
--		Data formatting is set by the DATA_FORMAT parameter. 
--		PER_CLOCK (default) format receives bits for 0, 1, 2 .. on the same sample edge
--		PER_CHANL format receives bits for 0, 7, 14 ..  on the same sample edge
--
--Reference:	XAPP585
--    
--Revision History:
--    Rev 1.0 - First created (nicks)
--    Rev 1.1 - PER_CLOCK and PER_CHANL descriptions swapped
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

entity serdes_1_to_7_slave_idelay_sdr is generic (
	D 			: integer := 8 ;				-- Set the number of inputs
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
		
end serdes_1_to_7_slave_idelay_sdr ;

architecture arch_serdes_1_to_7_slave_idelay_sdr of serdes_1_to_7_slave_idelay_sdr is

component delay_controller_wrap is generic (
	S 			: integer := 4) ;				-- Set the number of bits
port 	(
	m_datain		:  in std_logic_vector(S-1 downto 0) ;		-- Inputs from master serdes
	s_datain		:  in std_logic_vector(S-1 downto 0) ;		-- Inputs from slave serdes
	enable_phase_detector	:  in std_logic ;				-- Enables the phase detector logic when high
	enable_monitor		:  in std_logic ;				-- Enables the monitor logic when high, note time-shared with phase detector function
	reset			:  in std_logic ;				-- Reset line synchronous to clk
	clk			:  in std_logic ;				-- Global/Regional clock 
	c_delay_in		:  in std_logic_vector(4 downto 0) ;  		-- delay value found on clock line
	m_delay_out		: out std_logic_vector(4 downto 0) ;  		-- Master delay control value
	s_delay_out		: out std_logic_vector(4 downto 0) ;  		-- Master delay control value
	data_out		: out std_logic_vector(S-1 downto 0) ;  	-- Output data
	results			: out std_logic_vector(31 downto 0) ;  		-- Eye info
	m_delay_1hot		: out std_logic_vector(31 downto 0) ;  		-- Master delay control value as a one-hot vector
	debug 			: out std_logic_vector(1 downto 0) ;		-- debug data
	del_mech		:  in std_logic ;				-- changes delay mechanism slightly at higher bit rates
	bt_val			:  in std_logic_vector(4 downto 0)) ;		-- Calculated bit time value for slave devices
end component ;

signal	m_delay_val_in		: std_logic_vector(5*D-1 downto 0) ;
signal	s_delay_val_in		: std_logic_vector(5*D-1 downto 0) ;			
signal	rx_clk_in		: std_logic ;			
signal	bsstate			: integer range 0 to 3 ;                 	
signal	bslip			: std_logic ;                 	
signal	bcount			: std_logic_vector(3 downto 0) ;                 	
signal	pdcount			: std_logic_vector(6*D-1 downto 0) ;                 	
signal	clk_iserdes_data	: std_logic_vector(6 downto 0) ;      	
signal	clk_iserdes_data_d	: std_logic_vector(6 downto 0) ;    	
signal	enable			: std_logic ;                	
signal	flag1			: std_logic ;                 	
signal	flag2			: std_logic ;                 	
signal	state2			: integer range 0 to 3 ;			
signal	state2_count		: std_logic_vector(3 downto 0) ;			
signal	scount			: std_logic_vector(5 downto 0) ;			
signal	locked_out		: std_logic ;	
signal	chfound			: std_logic ;	
signal	chfoundc		: std_logic ;
signal	c_delay_in		: std_logic_vector(4 downto 0) ;
signal	rx_data_in_p		: std_logic_vector(D-1 downto 0) ;			
signal	rx_data_in_n		: std_logic_vector(D-1 downto 0) ;			
signal	rx_data_in_m		: std_logic_vector(D-1 downto 0) ;			
signal	rx_data_in_s		: std_logic_vector(D-1 downto 0) ;		
signal	rx_data_in_md		: std_logic_vector(D-1 downto 0) ;			
signal	rx_data_in_sd		: std_logic_vector(D-1 downto 0) ;	
signal	mdataout		: std_logic_vector(7*D-1 downto 0) ;			
signal	mdataoutd		: std_logic_vector(7*D-1 downto 0) ;			
signal	sdataout		: std_logic_vector(7*D-1 downto 0) ;			
signal	dataout			: std_logic_vector(7*D-1 downto 0) ;					
signal	slip_count 		: std_logic_vector(2 downto 0) ;                	
signal	bstate 			: integer range 0 to 3 ;
signal	data_different		: std_logic ;
signal	bs_finished		: std_logic ;
signal	not_bs_finished		: std_logic ;
signal 	not_rxclk		: std_logic ;
signal 	dummy			: std_logic ;
signal 	mmcm_locked		: std_logic ;
signal 	rx_clk_in_d		: std_logic ;
signal 	local_reset		: std_logic ;
signal	bt_val	 		: std_logic_vector(4 downto 0) ;                					
signal 	no_clock		: std_logic ;
signal	clk_s_count		: std_logic_vector(7 downto 0) ;					
signal	c_loop_cnt		: std_logic_vector(1 downto 0) ;

constant RX_SWAP_MASK 	: std_logic_vector(D-1 downto 0) := (others => '0') ;	-- pinswap mask for input data bits (0 = no swap (default), 1 = swap). Allows inputs to be connected the wrong way round to ease PCB routing.

begin

clk_data <= clk_iserdes_data ;
debug <= s_delay_val_in & m_delay_val_in & bslip & c_delay_in ;
bitslip_finished <= bs_finished and not reset ;
bt_val <= bit_time_value ;
not_bs_finished <= not bs_finished ;

process (rxclk_div, reset) begin				-- generate local reset
if reset = '1' then
	local_reset <= '1' ;
elsif rxclk_div'event and rxclk_div = '1' then
	if idelay_rdy = '0' then
		local_reset <= '1' ;
	else 
		local_reset <= '0' ;
	end if ;
end if ;
end process ;

-- Bitslip state machine, split over two clock domains

process (rxclk_div)
begin
if rxclk_div'event and rxclk_div = '1' then
	if locked_out = '0' then
		bslip <= '0' ;
		bsstate <= 1 ;
		enable <= '0' ;
		bcount <= X"0" ;
		bs_finished <= '0' ;
	else 
		enable <= '1' ;
	   	if enable = '1' then
	   		if clk_iserdes_data /= "1100001" then flag1 <= '1' ; else flag1 <= '0' ; end if ;
	   		if clk_iserdes_data /= "1100011" then flag2 <= '1' ; else flag2 <= '0' ; end if ;
	     		if bsstate = 0 then
	   			if flag1 = '1' and flag2 = '1' then
	     		   		bslip <= '1' ;						-- bitslip needed
	     		   		bsstate <= 1 ;
	     		   	else 
	     		   		bs_finished <= '1' ;					-- bitslip done
	     		   	end if ;
	   		elsif bsstate = 1 then							-- wait for bitslip ack from other clock domain
	     		   	bslip <= '0' ;
	     		   	bcount <= bcount + 1 ;
	     		   	if bcount = "1111" then
	     		   		bsstate <= 0 ;
	     		   	end if ;
	     		   end if ;
	   	end if ;
	end if ;
end if ;
end process ;

-- Clock input 

iob_clk_in : IBUFGDS generic map(
	DIFF_TERM 		=> DIFF_TERM) 
port map (                     
	I    			=> clkin_p,
	IB       		=> clkin_n,
	O         		=> rx_clk_in);

idelay_cm : IDELAYE2 generic map(
 	HIGH_PERFORMANCE_MODE 	=> HIGH_PERFORMANCE_MODE,
      	IDELAY_VALUE		=> 1,
      	DELAY_SRC		=> "IDATAIN",
      	IDELAY_TYPE		=> "VAR_LOAD")
port map(               	
	DATAOUT			=> rx_clk_in_d,
	C			=> rxclk_div,
	CE			=> '0',
	INC			=> '0',
	DATAIN			=> '0',
	IDATAIN			=> rx_clk_in,
	LD			=> '1',
	LDPIPEEN		=> '0',
	REGRST			=> '0',
	CINVCTRL		=> '0',
	CNTVALUEIN		=> c_delay_in,
	CNTVALUEOUT		=> open);

not_rxclk <= not rxclk ;

iserdes_cm : ISERDESE2 generic map(
	DATA_WIDTH     		=> 7, 				
	DATA_RATE      		=> "SDR", 			
	SERDES_MODE    		=> "MASTER", 			
	IOBDELAY	    	=> "IFD", 			
	INTERFACE_TYPE 		=> "NETWORKING") 		
port map (                    
	D       		=> rx_clk_in,
	DDLY     		=> rx_clk_in_d,
	CE1     		=> '1',
	CE2     		=> '1',
	CLK    			=> rxclk,
	CLKB    		=> not_rxclk,
	RST     		=> local_reset,
	CLKDIV  		=> rxclk_div,
	CLKDIVP  		=> '0',
	OCLK    		=> '0',
	OCLKB    		=> '0',
	DYNCLKSEL    		=> '0',
	DYNCLKDIVSEL  		=> '0',
	SHIFTIN1 		=> '0',
	SHIFTIN2 		=> '0',
	BITSLIP 		=> bslip,
	O	 		=> open,
	Q8 			=> open,
	Q7 			=> clk_iserdes_data(0),
	Q6 			=> clk_iserdes_data(1),
	Q5 			=> clk_iserdes_data(2),
	Q4 			=> clk_iserdes_data(3),
	Q3 			=> clk_iserdes_data(4),
	Q2 			=> clk_iserdes_data(5),
	Q1 			=> clk_iserdes_data(6),
	OFB 			=> '0',
	SHIFTOUT1 		=> open,
	SHIFTOUT2 		=> open);

process (rxclk_div)
begin
if rxclk_div'event and rxclk_div = '1' then					-- retiming
	clk_iserdes_data_d <= clk_iserdes_data ;
	if (clk_iserdes_data /= clk_iserdes_data_d) and (clk_iserdes_data /= "0000000") and (clk_iserdes_data /= "1111111") then
		data_different <= '1' ;
	else 
		data_different <= '0' ;
	end if ;
	if (clk_iserdes_data = "0000000") or (clk_iserdes_data = "1111111") then
		no_clock <= '1' ;
	else 
		no_clock <= '0' ;
	end if ;
end if ;
end process ;
	
process (rxclk_div)
begin
if rxclk_div'event and rxclk_div = '1' then					-- clock delay shift state machine
	if local_reset = '1' then
		scount <= "000000" ;
		state2 <= 0 ;
		state2_count <= X"0" ;
		locked_out <= '0' ;
		chfoundc <= '1' ;
		c_delay_in <= bt_val ;							-- Start the delay line at the current bit period
		c_loop_cnt <= "00" ;	
	else 
		if scount(5) = '0' then
			if no_clock = '0' then
				scount <= scount + 1 ;
			else 
				scount <= "000000" ;
			end if ;
		end if ;
		state2_count <= state2_count + 1 ;
		if chfoundc = '1' then
			chfound <= '0' ;
		elsif chfound = '0' and data_different = '1' then
			chfound <= '1' ;
		end if ;
		if (state2_count = "1111" and scount(5) = '1') then
			case (state2) is					
			when 0	=>							-- decrement delay and look for a change
				  if chfound = '1' or (c_loop_cnt = "11" and c_delay_in = "00000") then  -- quit loop if we've been around a few times
					chfoundc <= '1' ;
					state2 <= 1 ;
				  else 
					chfoundc <= '0' ;
					c_delay_in <= c_delay_in - 1 ;
					if c_delay_in /= "00000" then			-- check for underflow
						c_delay_in <= c_delay_in - 1 ;
					else 
						c_delay_in <= bt_val ;
						c_loop_cnt <= c_loop_cnt + 1 ;
					end if ;
				  end if ;
			when 1	=>							-- add half a bit period using input information
				  state2 <= 2 ;						-- choose the lowest delay value to minimise jitter
				  if c_delay_in < '0' & bt_val(4 downto 1) then
				   	c_delay_in <= c_delay_in + ('0' & bt_val(4 downto 1)) ;
				  else 
				   	c_delay_in <= c_delay_in - ('0' & bt_val(4 downto 1)) ;
				  end if ;
			when others =>							-- issue locked out signal and wait for a manual command (if required)
				  locked_out <= '1' ;
			end case ;
		end   if ;
	end if ;
end if ;
end process ;

loop3 : for i in 0 to D-1 generate

dc_inst : delay_controller_wrap generic map (
	S 			=> 7)
port map (                       
	m_datain		=> mdataout(7*i+6 downto 7*i),
	s_datain		=> sdataout(7*i+6 downto 7*i),
	enable_phase_detector	=> enable_phase_detector,
	enable_monitor		=> enable_monitor,
	reset			=> not_bs_finished,
	clk			=> rxclk_div,
	c_delay_in		=> c_delay_in,
	m_delay_out		=> m_delay_val_in(5*i+4 downto 5*i),
	s_delay_out		=> s_delay_val_in(5*i+4 downto 5*i),
	data_out		=> mdataoutd(7*i+6 downto 7*i),
	bt_val			=> bt_val,
	del_mech		=> '0',
	m_delay_1hot		=> m_delay_1hot(32*i+31 downto 32*i),
	results			=> eye_info(32*i+31 downto 32*i)) ;

end generate ;
	
-- Data bit Receivers 

loop0 : for i in 0 to D-1 generate
loop1 : for j in 0 to 6 generate			-- Assign data bits to correct serdes according to required format
	loop1a : if DATA_FORMAT = "PER_CLOCK" generate
		rx_data(D*j+i) <= mdataoutd(7*i+j) ;
	end generate ;
	loop1b : if DATA_FORMAT = "PER_CHANL" generate
		rx_data(7*i+j) <= mdataoutd(7*i+j) ;
	end generate ;
end generate ;

data_in : IBUFDS_DIFF_OUT generic map(
	DIFF_TERM 		=> DIFF_TERM) 
port map (                      
	I    			=> datain_p(i),
	IB       		=> datain_n(i),
	O         		=> rx_data_in_p(i),
	OB         		=> rx_data_in_n(i));

rx_data_in_m(i) <= rx_data_in_p(i)  xor RX_SWAP_MASK(i) ;
rx_data_in_s(i) <= not rx_data_in_n(i) xor RX_SWAP_MASK(i) ;

idelay_m : IDELAYE2 generic map(
 	HIGH_PERFORMANCE_MODE 	=> HIGH_PERFORMANCE_MODE,
      	IDELAY_VALUE		=> 0,
      	DELAY_SRC		=> "IDATAIN",
      	IDELAY_TYPE		=> "VAR_LOAD")
port map(                
	DATAOUT			=> rx_data_in_md(i),
	C			=> rxclk_div,
	CE			=> '0',
	INC			=> '0',
	DATAIN			=> '0',
	IDATAIN			=> rx_data_in_m(i),
	LD			=> '1',
	LDPIPEEN		=> '0',
	REGRST			=> '0',
	CINVCTRL		=> '0',
	CNTVALUEIN		=> m_delay_val_in(5*i+4 downto 5*i),
	CNTVALUEOUT		=> open);
		
iserdes_m : ISERDESE2 generic map(
	DATA_WIDTH     		=> 7, 			
	DATA_RATE      		=> "SDR", 		
	SERDES_MODE    		=> "MASTER", 		
	IOBDELAY	    	=> "IFD", 		
	INTERFACE_TYPE 		=> "NETWORKING") 	
port map (                      
	D       		=> '0',
	DDLY     		=> rx_data_in_md(i),
	CE1     		=> '1',
	CE2     		=> '1',
	CLK	   		=> rxclk,
	CLKB    		=> not_rxclk,
	RST     		=> rst_iserdes,
	CLKDIV  		=> rxclk_div,
	CLKDIVP  		=> '0',
	OCLK    		=> '0',
	OCLKB    		=> '0',
	DYNCLKSEL    		=> '0',
	DYNCLKDIVSEL  		=> '0',
	SHIFTIN1 		=> '0',
	SHIFTIN2 		=> '0',
	BITSLIP 		=> bslip,
	O	 		=> open,
	Q8  			=> open,
	Q7  			=> mdataout(7*i+0),
	Q6  			=> mdataout(7*i+1),
	Q5  			=> mdataout(7*i+2),
	Q4  			=> mdataout(7*i+3),
	Q3  			=> mdataout(7*i+4),
	Q2  			=> mdataout(7*i+5),
	Q1  			=> mdataout(7*i+6),
	OFB 			=> '0',
	SHIFTOUT1		=> open,
	SHIFTOUT2 		=> open);

idelay_s : IDELAYE2 generic map(
 	HIGH_PERFORMANCE_MODE 	=> HIGH_PERFORMANCE_MODE,
      	IDELAY_VALUE		=> 0,
      	DELAY_SRC		=> "IDATAIN",
      	IDELAY_TYPE		=> "VAR_LOAD")
port map(                
	DATAOUT			=> rx_data_in_sd(i),
	C			=> rxclk_div,
	CE			=> '0',
	INC			=> '0',
	DATAIN			=> '0',
	IDATAIN			=> rx_data_in_s(i),
	LD			=> '1',
	LDPIPEEN		=> '0',
	REGRST			=> '0',
	CINVCTRL		=> '0',
	CNTVALUEIN		=> s_delay_val_in(5*i+4 downto 5*i),
	CNTVALUEOUT		=> open);

iserdes_s : ISERDESE2 generic map(
	DATA_WIDTH     		=> 7, 			
	DATA_RATE      		=> "SDR", 		
--	SERDES_MODE    		=> "MASTER", 		
	IOBDELAY	    	=> "IFD", 		
	INTERFACE_TYPE 		=> "NETWORKING") 	
port map (                      
	D       		=> '0',
	DDLY     		=> rx_data_in_sd(i),
	CE1     		=> '1',
	CE2     		=> '1',
	CLK	   		=> rxclk,
	CLKB    		=> not_rxclk,
	RST     		=> rst_iserdes,
	CLKDIV  		=> rxclk_div,
	CLKDIVP  		=> '0',
	OCLK    		=> '0',
	OCLKB    		=> '0',
	DYNCLKSEL    		=> '0',
	DYNCLKDIVSEL  		=> '0',
	SHIFTIN1 		=> '0',
	SHIFTIN2 		=> '0',
	BITSLIP 		=> bslip,
	O	 		=> open,
	Q8  			=> open,
	Q7  			=> sdataout(7*i+0),
	Q6  			=> sdataout(7*i+1),
	Q5  			=> sdataout(7*i+2),
	Q4  			=> sdataout(7*i+3),
	Q3  			=> sdataout(7*i+4),
	Q2  			=> sdataout(7*i+5),
	Q1  			=> sdataout(7*i+6),
	OFB 			=> '0',
	SHIFTOUT1		=> open,
	SHIFTOUT2 		=> open);
		
end generate ;

end arch_serdes_1_to_7_slave_idelay_sdr ;
