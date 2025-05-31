onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+Ctrl_Ila -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Ctrl_Ila xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {Ctrl_Ila.udo}

run -all

endsim

quit -force
