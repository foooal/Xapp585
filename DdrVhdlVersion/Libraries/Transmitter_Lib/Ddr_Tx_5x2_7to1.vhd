------------------------------------------------------------------------------
-- Copyright (c) 2012-2018 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor: Xilinx
-- \   \   \/    Version: 1.3
--  \   \        Filename:Ddr_Tx_5x2_7to1.vhd
--  /   /        Date Last Modified:    05 Mar 2018
-- /___/   /\    Date Created:          2SEP2011
-- \   \  /  \
--  \___\/\___\
--
--Device:     7-Series
--Purpose:      DDR transmitter example - 2 channels of 5-bits each
--
--Reference:    XAPP585
--
--Revision History:
--    Rev 1.0 - First created (nicks)
--    Rev 1.2 - Updated format (brandond)
--    Rev 1.3 - Brought to new (defossez)
------------------------------------------------------------------------------
-- Disclaimer:
--        This disclaimer is not a license and does not grant any rights to the materials
--        distributed herewith. Except as otherwise provided in a valid license issued to you
--        by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
--        ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
--        WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
--        TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
--        PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
--        negligence, or under any other theory of liability) for any loss or damage of any
--        kind or nature related to, arising under or in connection with these materials,
--        including for any direct, or any indirect, special, incidental, or consequential
--        loss or damage (including loss of data, profits, goodwill, or any type of loss or
--        damage suffered as a result of any action brought by a third party) even if such
--        damage or loss was reasonably foreseeable or Xilinx had been advised of the
--        possibility of the same.
--
-- CRITICAL APPLICATIONS
--        Xilinx products are not designed or intended to be fail-safe, or for use in any
--        application requiring fail-safe performance, such as life-support or safety devices
--        or systems, Class III medical devices, nuclear facilities, applications related to
--        the deployment of airbags, or any other applications that could lead to death,
--        personal injury, or severe property or environmental damage (individually and
--        collectively, "Critical Applications"). Customer assumes the sole risk and
--        liability of any use of Xilinx products in Critical Applications, subject only to
--        applicable laws and regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
-- Contact:    e-mail  hotline@xilinx.com        phone   + 1 800 255 7778
------------------------------------------------------------------------------

library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
library unisim;
    use unisim.vcomponents.all;
library Transmitter_Lib;
    use Transmitter_Lib.all;
---------------------------------------------------------------------------------------------
-- Entity generic description
---------------------------------------------------------------------------------------------
-- N              : Set the number of channels
-- D              : Set the number of outputs per channel
-- DATA_FORMAT    : Determine method for mapping input parallel word to output serial words.
--                : "PER_CLOCK" or "PER_CHANL" data formatting
-- MMCM_MODE      : Parameter to set divider for MMCM to get VCO in correct operating
--                : range. 1 multiplies input clock by 7, 2 multiplies clock by 14, etc
-- MMCM_MODE_REAL : Parameter to set multiplier for MMCM to get VCO in correct operating
--                : range. 1.000 multiplies input clock by 7, 2.000 multiplies clock by 14, etc
-- CLOCK          : Parameter to set transmission clock buffer type, BUFIO, BUF_H, BUF_G
-- INTER_CLOCK    : Parameter to set intermediate clock buffer type, BUFR, BUF_H, BUF_G
-- PIXEL_CLOCK    : Parameter to set final clock buffer type, BUF_R, BUF_H, BUF_G
-- USE_PLL        : Parameter to enable PLL use rather than MMCM use, note, PLL does not
--                : support BUFIO and BUFR
-- CLKIN_PERIOD   :  clock period (ns) of input clock on clkin_p
-- DIFF_TERM      :  Enable or disable internal differential termination
-- CLK_FORM       :  Format of the ouput clock 3/4 or 4/3 format (format = High/Low)
---------------------------------------------------------------------------------------------
-- Entity pin description
---------------------------------------------------------------------------------------------
-- freqgen_p/n      :  Input clock for pixel rate frequency generator.
-- reset            :  reset (active high)
-- clkout_p/n      :  lvds channel clock output
-- dataout_p/n     :  lvds channel data outputs
---------------------------------------------------------------------------------------------
entity Ddr_Tx_5x2_7to1 is
    generic (
       N                : integer := 2;
       D                : integer := 5;
       DATA_FORMAT      : string  := "PER_CLOCK";
       MMCM_MODE        : integer   := 1;
       MMCM_MODE_REAL   : real      := 1.000;
       TX_CLOCK         : string    := "BUFIO";
       INTER_CLOCK      : string    := "BUF_R";
       PIXEL_CLOCK      : string    := "BUF_G";
       USE_PLL          : boolean   := FALSE;
       CLKIN_PERIOD     : real      := 6.000;
       DIFF_TERM        : boolean   := TRUE;
       CLK_FORM         : string    := "3/4"
    );
    port (
        freqgen_p       : in  std_logic;
        freqgen_n       : in  std_logic;
        Reset           : in  std_logic;
        datain          : in  std_logic_vector(((D*N)*7)-1 downto 0);
        mmcm_lckd       : out std_logic;
        pixel_clk       : out std_logic;
        clkout_p        : out std_logic_vector(N-1 downto 0);
        clkout_n        : out std_logic_vector(N-1 downto 0);
        dataout_p       : out std_logic_vector((N*D)-1 downto 0);
        dataout_n       : out std_logic_vector((N*D)-1 downto 0);
        clkgen_state    : out std_logic_vector(6 downto 0)
    );
end Ddr_Tx_5x2_7to1;
---------------------------------------------------------------------------------------------
architecture Ddr_Tx_5x2_7to1_arch of Ddr_Tx_5x2_7to1 is
---------------------------------------------------------------------------------------------
-- Constants, Signals and Attributes Declarations
---------------------------------------------------------------------------------------------
-- Constants
-- Signals
signal int_tx_clk_gen          : std_logic_vector(6 downto 0);
signal int_txclk_div           : std_logic;
signal int_pixel_clk           : std_logic;
signal int_txclk               : std_logic;
signal int_not_mmcm_lckd    : std_logic;
signal int_mmcm_lckd        : std_logic;
-- Attributes
attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of Ddr_Tx_5x2_7to1_arch : architecture is "TRUE";
--attribute LOC : string;
--        attribute LOC of  : label is ;
---------------------------------------------------------------------------------------------
begin
---------------------------------------------------------------------------------------------
-- Clock Input
---------------------------------------------------------------------------------------------
clkgen : entity Transmitter_Lib.clock_generator_pll_7_to_1_diff_ddr
    generic map(
        DIFF_TERM        => DIFF_TERM,
        PIXEL_CLOCK      => PIXEL_CLOCK,
        INTER_CLOCK      => INTER_CLOCK,
        TX_CLOCK         => TX_CLOCK,
        USE_PLL          => USE_PLL,
        MMCM_MODE        => MMCM_MODE,
        MMCM_MODE_REAL   => MMCM_MODE_REAL,
        CLKIN_PERIOD     => CLKIN_PERIOD
    )
    port map (
        reset            => reset,
        clkin_p          => freqgen_p,
        clkin_n          => freqgen_n,
        txclk            => int_txclk,
        txclk_div        => int_txclk_div,
        pixel_clk        => int_pixel_clk,
        status           => clkgen_state,
        mmcm_lckd        => int_mmcm_lckd
    );
--
int_not_mmcm_lckd <= not int_mmcm_lckd;
mmcm_lckd <= int_mmcm_lckd;
---------------------------------------------------------------------------------------------
-- Transmitter Logic for N D-bit channels
---------------------------------------------------------------------------------------------
-- Transmit a constant to make a 3:4 clock, two ticks in advance of bit0 of the data word
gen_0 : if CLK_FORM = "3/4" generate
    int_tx_clk_gen <= "1100001";
end generate gen_0;
-- OR Transmit a constant to make a 4:3 clock, two ticks in advance of bit0 of the data word
gen_1 : if CLK_FORM = "4/3" generate
    int_tx_clk_gen <=  "1100011";
end generate gen_1;
--
dataout : entity Transmitter_Lib.n_x_serdes_7_to_1_diff_ddr
    generic map(
        D           => D,
        N           => N,
        DATA_FORMAT => DATA_FORMAT
    )         --
    port map (
        dataout_p   => dataout_p,
        dataout_n   => dataout_n,
        clkout_p    => clkout_p,
        clkout_n    => clkout_n,
        txclk       => int_txclk,
        txclk_div   => int_txclk_div,
        pixel_clk   => int_pixel_clk,
        reset       => int_not_mmcm_lckd,
        clk_pattern => int_tx_clk_gen,
        datain      => datain
    );
--
pixel_clk <= int_pixel_clk;
---------------------------------------------------------------------------------------------
--
end Ddr_Tx_5x2_7to1_arch;
