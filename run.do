vlib work
vlog -f src_files.list -define SIM +cover
vsim -voptargs=+acc work.top -cover
add wave /top/fifo_interface_instance/*
coverage save top.ucdb -onexit 
run -all 


