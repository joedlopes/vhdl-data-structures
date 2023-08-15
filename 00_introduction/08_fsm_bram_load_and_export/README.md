# FSM BRAM Loader and Export

This example implements the test bench for testing a "DUT"
by loading data from a text file to a BRAM, 
running the DUT, 
later exporting the BRAM data to a file.

This example implements the three stages:

1. **Stage 1 - Data Loader:** data from a text file will be loaded to the block ram.

2. **Stage 2 - DUT run:** DUT will process and store the results in the block ram.

3. **Stage 3 - Save Outputs:** data from the block ram will be stored in a text file.

It uses the multiplexer to enable the BRAM for each of stages.

A state machine controls the stages, and for each stage there are 
other state machines or logic running.


Each stage should have an "ENA" enable input and a "VALID" output.

When ENA is activated (rising edge), the respective should start. 
If ENA is low, the circuit will be in a reset state.

When it successfully finishes, the "VALID" signal should be set to high.


## States

STATE_IDLE, 
LOADER_PREPARE, LOADER_RUN, LOADER_DONE,
DUT_PREPARE, DUT_RUN, DUT_DONE,
EXPORT_PREPARE, EXPORT_RUN, EXPORT_DONE
STATE_END
