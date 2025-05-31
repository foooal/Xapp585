onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Ctrl_Ila_opt

do {wave.do}

view wave
view structure
view signals

do {Ctrl_Ila.udo}

run -all

quit -force
