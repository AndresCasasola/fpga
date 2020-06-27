
## Restart
restart
## Init
run 10ns
add_force {/uart_test/RST}          -radix bin {1 0ns} {0 100ns}
add_force {/uart_test/CLK}          -radix bin {0 0ns} {1 5ns} -repeat_every 10ns
add_force {/uart_test/TX_TRIGGER}   -radix bin {0 0ns}
run 100us

## TX = 1
add_force {/uart_test/TX_TRIGGER}        -radix bin {1 0ns}
run 50us
add_force {/uart_test/TX_TRIGGER}        -radix bin {0 0ns}
run 600us

## TX = 1
#add_force {/tm1637_test/TX}        -radix bin {1 0ns}
#run 50us
#add_force {/tm1637_test/TX}        -radix bin {0 0ns}
#run 200us