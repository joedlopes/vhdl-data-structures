# BRAM Mux3

This examples implements a multiplexer with 3 channels to control the block ram.

The main objective is to provide a multiplexer channel to run
the 3 states of a device under test (DUT) that uses the block ram:

1. **Stage 1 - Data Loader:** data from a text file will be loaded to the block ram.

2. **Stage 2 - DUT run:** DUT will process and store the results in the block ram.

3. **Stage 3 - Save Outputs:** data from the block ram will be stored in a text file.

For these three stages a multiplexer is needed to commuicate with the block ram.


## References

Surf-vhdl: How to implement digital mux (link)[https://surf-vhdl.com/how-to-implement-digital-mux-in-vhdl/]