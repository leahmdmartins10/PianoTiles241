# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in Master_Control.v to working dir
vlog scoreRegister.v

# load simulation using Master_Control as the top-level simulation module
vsim score

# log all signals and add some signals to waveform window
log -r /*

# add wave /* would add all items in the top-level simulation module
add wave /*

# clock repetition
force {clk} 0 0ns, 1 {1ns} -r 2ns

# base values
force {resetn} 1
force {startn} 0
force {increment} 0
force {current_state} 0
force {HEX0} 0
force {HEX1} 0
force {HEX2} 0
force {HEX3} 0
force {HEX4} 0
force {HEX5} 0
force {Q} 0

run 5ns

force {resetn} 0
force start 0

run 5ns

force {resetn} 1

run 5ns

force {startn} 1
force {increment} 1
force current_state 1

run 4ns

force {startn} 0
force {increment} 1
force {increment digits} 1
force {current_state} 1

run 5ns

force {increment} 0

run 10ns
