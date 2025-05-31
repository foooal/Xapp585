vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../../../Libraries/Vio_Lib/Ctrl_Vio/hdl/verilog" "+incdir+../../../../../../Libraries/Vio_Lib/Ctrl_Vio/hdl" "+incdir+../../../../../../Libraries/Vio_Lib/Ctrl_Vio/hdl/verilog" "+incdir+../../../../../../Libraries/Vio_Lib/Ctrl_Vio/hdl" \
"C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../../../Libraries/Vio_Lib/Ctrl_Vio/sim/Ctrl_Vio.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

