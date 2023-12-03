# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in mux.v to working dir
# could also have multiple verilog files
vlog controlModule.v

#load simulation using all_draw as the top level simulation module
vsim controlModule

#log all signals and add some signals to waveform window
log {/*}
# add wave {/*} would add all items in top level simulation module
add wave {/*}

force {clk} 0 0ns, 1 {1ns} -r 2ns							

#set base values
force {resetn} 1
force startn 1
force {reset_screen_done} 0
force {drawdone} 0
force {wait_done} 0
force {offset} 100111
run 10ns

force {resetn} 0
run 10ns
force {resetn} 1
run 10ns
force {reset_screen_done} 1
run 10ns
force drawdone 0
run 10ns

force wait_done 1 
run 4ns

force wait_done 0
run 4ns

