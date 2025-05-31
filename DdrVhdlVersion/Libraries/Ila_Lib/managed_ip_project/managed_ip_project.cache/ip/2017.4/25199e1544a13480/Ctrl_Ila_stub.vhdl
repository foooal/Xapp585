-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2139404 Wed Feb 21 18:47:47 MST 2018
-- Date        : Thu Mar 22 14:39:25 2018
-- Host        : XBEDEFOSSEZ31 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Ctrl_Ila_stub.vhdl
-- Design      : Ctrl_Ila
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe1 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe7 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe10 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe11 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe12 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe13 : in STD_LOGIC_VECTOR ( 19 downto 0 );
    probe14 : in STD_LOGIC_VECTOR ( 19 downto 0 )
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[0:0],probe1[6:0],probe2[6:0],probe3[6:0],probe4[6:0],probe5[6:0],probe6[6:0],probe7[6:0],probe8[6:0],probe9[6:0],probe10[6:0],probe11[6:0],probe12[6:0],probe13[19:0],probe14[19:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "ila,Vivado 2017.4";
begin
end;
