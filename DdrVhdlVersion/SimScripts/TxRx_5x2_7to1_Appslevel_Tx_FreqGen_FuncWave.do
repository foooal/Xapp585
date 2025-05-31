onerror {resume}
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
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/clkout2_p
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/clkout2_n
add wave -noupdate -divider -height 25 {UUT Stuff}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/refclkin_p
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/refclkin_n
add wave -noupdate -divider {UUT Transmitter Application}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_out0
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_out3
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_tx_mmcm_lckd
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_tx_pixel_clk
add wave -noupdate -divider {TX Clock Gen}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/MMCM_MODE
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/MMCM_MODE_REAL
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/TX_CLOCK
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/INTER_CLOCK
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/PIXEL_CLOCK
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/USE_PLL
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/CLKIN_PERIOD
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/DIFF_TERM
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/clkin_p
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/clkin_n
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/reset
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/pixel_clk
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/txclk
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/txclk_div
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/status
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Txd/clkgen/mmcm_lckd
add wave -noupdate -divider {TX Data Gen}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {988646 ps} 0} {{Cursor 2} {85673677 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 451
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ps} {2068636 ps}
