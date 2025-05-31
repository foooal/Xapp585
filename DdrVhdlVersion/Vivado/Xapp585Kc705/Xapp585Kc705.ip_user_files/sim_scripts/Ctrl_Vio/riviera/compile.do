vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../../../Libraries/Vio_Lib/Ctrl_Vio/hdl/verilog" "+incdir+../../../../../../Libraries/Vio_Lib/Ctrl_Vio/hdl" "+incdir+../../../../../../Libraries/Vio_Lib/Ctrl_Vio/hdl/verilog" "+incdir+../../../../../../Libraries/Vio_Lib/Ctrl_Vio/hdl" \
"C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../../../Libraries/Vio_Lib/Ctrl_Vio/sim/Ctrl_Vio.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

