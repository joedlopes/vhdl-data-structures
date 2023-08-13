# FSM Counter

This test bench creates a state machine that will be the basis for 
loading data to a block ram.

It is based in a single process state machine. Additionaly, it contains two signals:

- *ena*: used for activating the counter.
- *valid*: that signalized the counter has reached the end.
- *we*: to enable the writing of the block ram.
- *sys_counter*: address, increases at every cycle.

The *valid* signal will be used in the future for notifying the start of the DUT.

## References

- N-Process state machine (VHDLWhiz.com)[https://vhdlwhiz.com/n-process-state-machine/]
