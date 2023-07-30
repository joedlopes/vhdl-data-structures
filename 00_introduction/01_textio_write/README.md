# Text IO

This section introduces the basics on how to build a VHDL code.


## Makefile

```makefile
GHDL=ghdl # path to call the GHDL
FLAGS="--std=08" # to use the 2008 standard

all:
    # Analysis: list of files to perform the analysis
	@$(GHDL) -a $(FLAGS) hello.vhd  
    # Elaboration: the entity name to be elaborated
	@$(GHDL) -e $(FLAGS) hello_world
    # Run the simulation: List of top entitity to run
    # --wave to save the results in a wave file
    # --stop-time to run the simulation for 1us
	@$(GHDL) -r $(FLAGS) hello_world --wave=wave.ghw --stop-time=1us
```

## References

This section is based on the example of Steven Bell's tutorial (https://www.youtube.com/watch?v=j9hya97kRJA)

