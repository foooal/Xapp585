-makelib ies_lib/xil_defaultlib -sv \
  "C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../../../Libraries/Ila_Lib/Ctrl_Ila/sim/Ctrl_Ila.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

