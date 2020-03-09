
# Restart
restart
# Init
run 10ns
add_force {/fifo/RST}       -radix bin {1 0ns} {0 100ns}
add_force {/fifo/CLK}       -radix bin {0 0ns} {1 4ns} -repeat_every 8ns
add_force {/fifo/PUSH}      -radix bin {0 0ns}
add_force {/fifo/POP}       -radix bin {0 0ns}
add_force {/fifo/DIN}       -radix hex {0 0ns}
run 200ns

############################ PUSH
# PUSH 5
add_force {/fifo/DIN}       -radix hex {5 0ns}
add_force {/fifo/PUSH}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/PUSH}      -radix bin {0 0ns}
run 30ns
# PUSH 8
add_force {/fifo/DIN}       -radix hex {8 0ns}
add_force {/fifo/PUSH}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/PUSH}      -radix bin {0 0ns}
run 30ns
# PUSH B
add_force {/fifo/DIN}       -radix hex {B 0ns}
add_force {/fifo/PUSH}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/PUSH}      -radix bin {0 0ns}
run 30ns
# PUSH F
add_force {/fifo/DIN}       -radix hex {F 0ns}
add_force {/fifo/PUSH}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/PUSH}      -radix bin {0 0ns}
run 30ns

############################ WAIT
run 20ns

############################ POP
# POP
add_force {/fifo/POP}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/POP}      -radix bin {0 0ns}
run 30ns
# POP
add_force {/fifo/POP}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/POP}      -radix bin {0 0ns}
run 30ns
# POP
add_force {/fifo/POP}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/POP}      -radix bin {0 0ns}
run 30ns
# POP
add_force {/fifo/POP}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/POP}      -radix bin {0 0ns}
run 30ns

############################ PUSH
# PUSH 5
add_force {/fifo/DIN}       -radix hex {5 0ns}
add_force {/fifo/PUSH}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/PUSH}      -radix bin {0 0ns}
run 30ns
# PUSH 8
add_force {/fifo/DIN}       -radix hex {8 0ns}
add_force {/fifo/PUSH}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/PUSH}      -radix bin {0 0ns}
run 30ns
# PUSH B
add_force {/fifo/DIN}       -radix hex {B 0ns}
add_force {/fifo/PUSH}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/PUSH}      -radix bin {0 0ns}
run 30ns
# PUSH F
add_force {/fifo/DIN}       -radix hex {F 0ns}
add_force {/fifo/PUSH}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/PUSH}      -radix bin {0 0ns}
run 30ns

############################ WAIT
run 20ns

############################ POP
# POP
add_force {/fifo/POP}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/POP}      -radix bin {0 0ns}
run 30ns
# POP
add_force {/fifo/POP}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/POP}      -radix bin {0 0ns}
run 30ns
# POP
add_force {/fifo/POP}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/POP}      -radix bin {0 0ns}
run 30ns
# POP
add_force {/fifo/POP}      -radix bin {1 0ns}
run 8ns
add_force {/fifo/POP}      -radix bin {0 0ns}
run 30ns
