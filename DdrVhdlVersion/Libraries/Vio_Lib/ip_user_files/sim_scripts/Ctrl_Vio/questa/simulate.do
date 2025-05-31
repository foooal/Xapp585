onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Ctrl_Vio_opt

do {wave.do}

view wave
view structure
view signals

do {Ctrl_Vio.udo}

run -all

quit -force
