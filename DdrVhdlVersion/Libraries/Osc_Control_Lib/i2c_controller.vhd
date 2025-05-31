------------------------------------------------------------------------------
--
--  Xilinx, Inc. 2004 - 2007               www.xilinx.com
--
--  XAPP xyz
--
------------------------------------------------------------------------------
--
--  File name :       i2c_controller.vhd
--
--  Description :     I2C controller for Si570 using picoblaze
--
--  Date - revision : February 1st 2013 - v 1.0
--
--  Author :          NJS, Defossez
--
--  Disclaimer: LIMITED WARRANTY AND DISCLAMER. These designs are
--              provided to you "as is". Xilinx and its licensors makeand you
--              receive no warranties or conditions, express, implied,
--              statutory or otherwise, and Xilinx specificallydisclaims any
--              implied warranties of merchantability, non-infringement,or
--              fitness for a particular purpose. Xilinx does notwarrant that
--              the functions contained in these designs will meet your
--              requirements, or that the operation of these designswill be
--              uninterrupted or error free, or that defects in theDesigns
--              will be corrected. Furthermore, Xilinx does not warrantor
--              make any representations regarding use or the results ofthe
--              use of the designs in terms of correctness, accuracy,
--              reliability, or otherwise.
--
--              LIMITATION OF LIABILITY. In no event will Xilinx or its
--              licensors be liable for any loss of data, lost profits,cost
--              or procurement of substitute goods or services, or forany
--              special, incidental, consequential, or indirect damages
--              arising from the use or operation of the designs or
--              accompanying documentation, however caused and on anytheory
--              of liability. This limitation will apply even if Xilinx
--              has been advised of the possibility of such damage. This
--              limitation shall apply not-withstanding the failure ofthe
--              essential purpose of any limited remedies herein.
--
--  Copyright � 2004 - 2007 Xilinx, Inc.
--  All rights reserved
--
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all ;

library unisim ;
    use unisim.vcomponents.all ;
library Osc_Control_Lib;
    use Osc_Control_Lib.all;

entity i2c_controller is port (
	clk			:  in std_logic;			-- system clock
	rst			:  in std_logic;			-- reset
	req_freq		:  in std_logic_vector(23 downto 0);	-- Required frequency in KHz, eg 100 MHz would be X"0186A0"
	program			:  in std_logic ;			-- Pulse high (one cycle) to reprogram si570
	ready			: out std_logic ;			-- High when i570 has been programmed
	ack			: out std_logic ;			-- High when an ACK was received
	sda_out			: out std_logic ;			-- I2C data out
	scl_out			: out std_logic ;			-- I2C clock out
	sda_in			:  in std_logic ;			-- I2C data in
	scl_in			:  in std_logic) ;			-- I2C clock in
end i2c_controller ;

architecture arch_i2c_controller of i2c_controller is

-- declaration of KCPSM6
--component kcpsm6 generic(
--	 hwbuild 		: std_logic_vector(7 downto 0) := X"00";
--	 interrupt_vector 	: std_logic_vector(11 downto 0) := X"3FF";
--	scratch_pad_memory_size : integer := 64);
--port (
--	address 		: out std_logic_vector(11 downto 0);
--	instruction 		: in std_logic_vector(17 downto 0);
--	bram_enable 		: out std_logic;
--	in_port 		: in std_logic_vector(7 downto 0);
--	out_port 		: out std_logic_vector(7 downto 0);
--	port_id 		: out std_logic_vector(7 downto 0);
--	write_strobe 		: out std_logic;
--	k_write_strobe 		: out std_logic;
--	read_strobe 		: out std_logic;
--	interrupt 		: in std_logic;
--	interrupt_ack 		: out std_logic;
--	sleep 			: in std_logic;
--	reset 			: in std_logic;
--	clk 			: in std_logic);
--end component;
----
---- declaration of Program ROM
----
--component controller_top generic (
--   	C_JTAG_LOADER_ENABLE 	: integer := 0;
--	C_FAMILY 		: string := "S6";
--      	C_RAM_SIZE_KWORDS 	: integer := 1);
--port (
--	address 		:  in std_logic_vector(11 downto 0);		-- picoblaze address
--	enable 			:  in std_logic ;				-- RAM enable
--	instruction 		: out std_logic_vector(17 downto 0);		-- picoblaze instruction
-- 	rdl	 		: out std_logic;				-- reset for jtag loader
--	clk 			:  in std_logic);				-- clock
--end component;

signal debug_reset		: std_logic ;
signal address         		: std_logic_vector(11 downto 0);
signal instruction     		: std_logic_vector(17 downto 0);
signal port_id         		: std_logic_vector(7 downto 0);
signal out_port        		: std_logic_vector(7 downto 0);
signal in_port         		: std_logic_vector(7 downto 0);
signal write_strobe    		: std_logic ;
signal k_write_strobe    	: std_logic ;
signal read_strobe     		: std_logic ;
signal interrupt       		: std_logic := '0' ;
signal interrupt_ack   		: std_logic ;
signal uart_16x_enable		: std_logic := '0' ;
signal uart_counter		: std_logic_vector(8 downto 0) := "000000000" ;
signal uart_tx_write 		: std_logic ;
signal uart_rx_read   		: std_logic ;
signal uart_rx_data    		: std_logic_vector(7 downto 0);
signal uart_rx_dav   		: std_logic ;
signal uart_rx_full   		: std_logic ;
signal uart_rx_half_full	: std_logic ;
signal uart_tx_full   		: std_logic ;
signal uart_tx_half_full	: std_logic ;
signal oldeighthsecond		: std_logic ;
signal rx_reset_int		: std_logic := '0' ;
signal mux_out    		: std_logic_vector(7 downto 0);
signal sda_int   		: std_logic ;
signal scl_int   		: std_logic ;
signal ram_read_data   		: std_logic_vector(7 downto 0);
signal ram_write_addr   	: std_logic_vector(10 downto 0);
signal ce_int    		: std_logic := '0' ;
signal incdec_int    		: std_logic := '0' ;
signal state    		: std_logic := '0' ;
signal up    			: std_logic := '0' ;
signal bram_enable 		: std_logic ;
signal cpu_reset		: std_logic ;
signal sleep    		: std_logic ;
signal pico_switch_int   	: std_logic_vector(3 downto 0);
signal freeze		   	: std_logic_vector(2 downto 0);
signal xadc_dwe    		: std_logic ;
signal xadc_den    		: std_logic ;
signal xadc_drdy    		: std_logic ;
signal xadc_di		   	: std_logic_vector(15 downto 0);
signal xadc_do		   	: std_logic_vector(15 downto 0);
signal xadc_read_data	   	: std_logic_vector(15 downto 0);
signal xadc_tip    		: std_logic ;
signal xadc_jtagbusy    	: std_logic ;
signal xadc_jtaglocked    	: std_logic ;
signal xadc_jtagmodified    	: std_logic ;
signal xadc_addr	   	: std_logic_vector(6 downto 0);
signal vx		    	: std_logic ;
signal eight 			: std_logic_vector(2 downto 0) := "000" ;
signal sec_count		: std_logic_vector(23 downto 0) := "000000000000000000000000" ;
signal seconds_int	   	: std_logic_vector(2 downto 0);
signal fan_pwm 			: std_logic_vector(7 downto 0);
signal pwm_shift		: std_logic_vector(7 downto 0);
signal pwm_count1 		: std_logic_vector(8 downto 0);
signal pwm_count2 		: std_logic_vector(2 downto 0);

begin

sleep <= write_strobe and read_strobe ;

processor: entity Osc_Control_Lib.kcpsm6
 generic map (
	interrupt_vector 	=> X"7FF",
        scratch_pad_memory_size => 64,
        hwbuild			=> X"10")
port map(
	address 		=> address,
	instruction 		=> instruction,
	bram_enable 		=> bram_enable,
	port_id 		=> port_id,
	write_strobe 		=> write_strobe,
	k_write_strobe 		=> open,
	out_port 		=> out_port,
	read_strobe 		=> read_strobe,
	in_port 		=> in_port,
	interrupt 		=> interrupt,
	interrupt_ack 		=> interrupt_ack,
	reset 			=> debug_reset,
	sleep 			=> sleep,
	clk 			=> clk);

program_rom : entity Osc_Control_Lib.controller_top
generic map(
	C_RAM_SIZE_KWORDS 	=> 2,
	C_JTAG_LOADER_ENABLE 	=> 1,
	C_FAMILY 		=> "7S")
port map(
 	rdl		 	=> debug_reset,
 	enable		 	=> bram_enable,
	address 		=> address,
	instruction 		=> instruction,
	clk 			=> clk);

-- registered port outputs

process (clk)									-- processor write decodes
begin
if clk'event and clk = '1' then
	if write_strobe = '1' and port_id(0) = '1' then
		scl_out <= out_port(0) ;					-- I2C clock and data out at address 1
		sda_out <= out_port(1) ;
	elsif write_strobe = '1' and port_id(1) = '1' then
		ready <= out_port(0) ;						-- ready & ack out at address 2
		ack <= out_port(1) ;
	end if ;
end if ;
end process ;

process (clk)									-- data input stuff
begin
if clk'event and clk = '1' then
	case port_id(1 downto 0) is
		when "00"   => in_port <= "000000" & sda_int & scl_int ; 	-- I2C in at address 0
		when "01"   => in_port <= req_freq(7 downto 0) ;		-- low frequency at address 1
		when "10"   => in_port <= req_freq(15 downto 8) ;		-- low frequency at address 2
		when others => in_port <= req_freq(23 downto 16) ;		-- low frequency at address 3
	end case ;
end if ;
end process ;

process (clk)
begin
if clk'event and clk = '1' then
	sda_int <= sda_in ;
	scl_int <= scl_in ;
	if interrupt_ack = '1' or rst = '1' then
		interrupt <= '0' ;
	elsif program = '1' then
		interrupt <= '1' ;
	end if ;
end if ;
end process ;

end arch_i2c_controller;
