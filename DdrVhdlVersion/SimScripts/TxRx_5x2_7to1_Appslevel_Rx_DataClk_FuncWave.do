onerror {resume}
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(31 downto 0)} Eye_Info_Chnl_0
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(63 downto 32)} Eye_Info_Cnl_1
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(95 downto 64)} Eye_Info_Chnl_2
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(127 downto 96)} Eye_Info_Chnl_3
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(159 downto 128)} Eye_Info_Chnl_4
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(31 downto 0)} Eye_Info_rx0_mmcm_Chnl_0
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(63 downto 32)} Eye_Info_rx0_mmcm_Chnl_1
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(95 downto 64)} Eye_Info_rx0_mmcm_Chnl_2
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(127 downto 96)} Eye_Info_rx0_mmcm_Chnl_3
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(159 downto 128)} Eye_Info_rx0_mmcm_Chnl_4
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(191 downto 160)} Eye_Info_rxn_slave_Chnl_0
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(223 downto 192)} Eye_Info_rxn_slave_Chnl_1
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(255 downto 224)} Eye_Info_rxn_slave_Chnl_2
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(287 downto 256)} Eye_Info_rxn_slave_Chnl_3
quietly virtual signal -install /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd { /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info(319 downto 288)} Eye_Info_rxn_slave_Chnl_4
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 25 {RxD (n_x_serdes_1_to_7_mmcm_idelay_ddr)}
add wave -noupdate -divider Generics
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/N
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/D
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/SAMPL_CLOCK
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/INTER_CLOCK
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/PIXEL_CLOCK
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/USE_PLL
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/CLKIN_PERIOD
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/REF_FREQ
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/HIGH_PERFORMANCE_MODE
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/MMCM_MODE
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/MMCM_MODE_REAL
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/DIFF_TERM
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/DATA_FORMAT
add wave -noupdate -divider Ports
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/clkin_p
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/clkin_n
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/datain_p
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/datain_n
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/enable_phase_detector
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/enable_monitor
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/reset
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/idelay_rdy
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/rxclk
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/rxclk_d4
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/pixel_clk
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/rx_mmcm_lckd
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/rx_mmcm_lckdps
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/rx_mmcm_lckdpsbs
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/clk_data
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/rx_data
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/dcd_correct
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/bit_rate_value
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/bit_time_value
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/status
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/Eye_Info_rxn_slave_Chnl_4
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/Eye_Info_rxn_slave_Chnl_3
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/Eye_Info_rxn_slave_Chnl_2
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/Eye_Info_rxn_slave_Chnl_1
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/Eye_Info_rxn_slave_Chnl_0
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/Eye_Info_rx0_mmcm_Chnl_4
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/Eye_Info_rx0_mmcm_Chnl_3
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/Eye_Info_rx0_mmcm_Chnl_2
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/Eye_Info_rx0_mmcm_Chnl_1
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/Eye_Info_rx0_mmcm_Chnl_0
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/eye_info
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/m_delay_1hot
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/debug
add wave -noupdate -divider Signals
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/rxclk_int
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/rxclk_d4_int
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/not_rx_mmcm_lckdps
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/pixel_clk_int
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/rx_mmcm_lckdps_int
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/bit_time_value_int
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/rst_iserdes
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/gb_rst_out
add wave -noupdate /txrx_5x2_7to1_appslevel_testbench/UUT/TxdRxd/Rxd/del_mech
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15926118 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 464
configure wave -valuecolwidth 226
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
WaveRestoreZoom {0 ps} {87555911 ps}
