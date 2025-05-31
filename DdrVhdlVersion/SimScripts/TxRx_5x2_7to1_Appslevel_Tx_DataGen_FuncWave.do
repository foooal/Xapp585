onerror {resume}
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout/dataint(69 downto 35)} dataint_69_35
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout/dataint(34 downto 0)} dataint_34_0
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 25 {UUT Generics}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/C_DebugChnl
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/C_DebugLane
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/C_Simulation
add wave -noupdate -divider -height 25 {UUT Transmitter Ports}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/tx_freqgen_p
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/tx_freqgen_n
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/clkout1_p
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/clkout1_n
add wave -noupdate -expand /txrx_5x2_7to1_appslevel_testbench/UUT/dataout1_p
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/dataout1_n
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/clkout2_p
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/clkout2_n
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/dataout2_p
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/dataout2_n
add wave -noupdate -divider -height 25 {UUT Stuff}
add wave -noupdate -divider {UUT Transmitter Application}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_out0
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_out3
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_tx_mmcm_lckd
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_tx_pixel_clk
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_txd1
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_txd2
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_txdata
add wave -noupdate -divider {TX Data Dataout (n_x_serdes_7_to_1_diff_ddr)}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/N
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/D
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/DATA_FORMAT
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/reset
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/pixel_clk
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/txclk
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/txclk_div
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/clk_pattern
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/datain
add wave -noupdate -divider {dataout loop0(0) (serdes_7_to_1_diff_ddr)}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout/int_count
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout/clockb2
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout/clockb2d_a
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout/clockb2d_b
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout/sync
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout/datain
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout/holdreg
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout/dataint
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/dataout/loop0(0)/dataout/mdataina
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {1717836 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 523
configure wave -valuecolwidth 141
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1672751 ps} {1826613 ps}
