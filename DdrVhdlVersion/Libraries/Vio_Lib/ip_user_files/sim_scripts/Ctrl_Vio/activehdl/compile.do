vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../Ctrl_Vio/hdl/verilog" "+incdir+../../../../Ctrl_Vio/hdl" "+incdir+../../../../Ctrl_Vio/hdl/verilog" "+incdir+../../../../Ctrl_Vio/hdl" \
"C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/CaeTools/Xilinx/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../Ctrl_Vio/sim/Ctrl_Vio.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

