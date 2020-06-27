
# Init
restart
add_force {/top/RST} -radix bin {1 0ns} {0 100ns}
add_force {/top/CLK} -radix bin {0 0ns} {1 4ns} -repeat_every 8ns
add_force {/top/BTN} -radix hex {0 0ns}
run 10ms

# Change 1
add_force {/top/BTN} -radix hex {1 0ns}
run 50ms
# Change 2
add_force {/top/BTN} -radix hex {0 0ns}
run 50ms

# Change 3
add_force {/top/BTN} -radix hex {1 0ns}
run 50ms
# Change 4
add_force {/top/BTN} -radix hex {0 0ns}
run 50ms
