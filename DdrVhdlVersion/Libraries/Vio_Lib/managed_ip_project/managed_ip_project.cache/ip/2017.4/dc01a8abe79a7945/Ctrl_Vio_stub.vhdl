-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2139404 Wed Feb 21 18:47:47 MST 2018
-- Date        : Fri Mar  9 09:21:53 2018
-- Host        : XBEDEFOSSEZ31 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Ctrl_Vio_stub.vhdl
-- Design      : Ctrl_Vio
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in4 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe_in5 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe_in6 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_in7 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_in8 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in9 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_in10 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe_in11 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe_in12 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_in13 : in STD_LOGIC_VECTOR ( 6 downto 0 );
    probe_in14 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out2 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out3 : out STD_LOGIC_VECTOR ( 34 downto 0 );
    probe_out4 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    probe_out5 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out6 : out STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out7 : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[0:0],probe_in1[0:0],probe_in2[0:0],probe_in3[0:0],probe_in4[31:0],probe_in5[31:0],probe_in6[4:0],probe_in7[4:0],probe_in8[0:0],probe_in9[4:0],probe_in10[1:0],probe_in11[6:0],probe_in12[4:0],probe_in13[6:0],probe_in14[0:0],probe_out0[0:0],probe_out1[0:0],probe_out2[0:0],probe_out3[34:0],probe_out4[23:0],probe_out5[0:0],probe_out6[0:0],probe_out7[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2017.4";
begin
end;
