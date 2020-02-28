
# Init
restart
add_force {/fsm/RST} -radix bin {1 0ns} {0 20ns}
add_force {/fsm/CLK} -radix bin {0 0ns} {1 5ns} -repeat_every 10ns
add_force {/fsm/BTN} -radix hex {0 0ns}
run 100ns

# Change 1
add_force {/fsm/BTN} -radix hex {1 0ns}
run 20ns

# Change 2
add_force {/fsm/BTN} -radix hex {3 0ns}
run 20ns
