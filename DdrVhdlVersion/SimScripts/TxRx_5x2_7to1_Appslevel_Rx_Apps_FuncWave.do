onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 25 {Simulation Constants in test bench file}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/Sim_C_ClockPeriod
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/Sim_C_RefClkPeriod
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/Sim_C_DebugChnl
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/Sim_C_DebugLane
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/Sim_C_Simulation
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/Sim_C_Shift_Pattern
add wave -noupdate -divider -height 25 {UUT Internal signals}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_tx_reset
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_rx_reset
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_refclk
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_tx_pixel_clk
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_rx_pixel_clk
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_rx_clk_d4
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_tx_mmcm_lckd
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_rx_mmcm_lckdpsbs
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_rx_clk
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_rxdall
add wave -noupdate -divider {VIO Signals}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in4
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in5
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in6
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in7
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in8
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in9
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in10
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in11
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in12
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in13
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in15
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_in16
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_out0
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_out1
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/Sim_probe_out3
add wave -noupdate -divider {I2C signals}
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_clki2c
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_i2c_reset
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_freq_value
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_prog_freq
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_freq_acq
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_freq_rdy
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_i2c_data_out
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_i2c_data_in
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_i2c_clock_out
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/int_i2c_clock_in
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9755083 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 360
configure wave -valuecolwidth 84
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
WaveRestoreZoom {0 ps} {94500 ns}
