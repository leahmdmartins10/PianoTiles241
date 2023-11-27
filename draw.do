# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog all_draw.v
vlog drawing.v

#load simulation using all_draw as the top level simulation module
vsim all_draw

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force {clock} 0 0ns, 1 {1ns} -r 2ns

force {resetn} 0
force {draw_go} 0
force {offset} 00100
force {line_0} 001
force {line_1} 011
force {line_2} 010
force {line_3} 000
force {line_4} 000
force {line_5} 000
force {line_6} 000
run 10 ns

force {resetn} 1
run 10ns

force {draw_go} 1
run 10000ns
