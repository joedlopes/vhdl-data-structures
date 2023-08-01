
GHDL=ghdl
FLAGS="--std=08"

SOURCE_FILES=bram_init.vhd block_ram.vhd
TOP_ENTITY=bram_init


all: 
	python3 gen_input_file.py
	$(GHDL) -a $(FLAGS) $(SOURCE_FILES)
	$(GHDL) -e $(FLAGS) $(TOP_ENTITY)
	$(GHDL) -r $(FLAGS) $(TOP_ENTITY) --wave=wave.ghw --stop-time=40us

clean:
	rm -f wave.ghw *.cf input_file.txt output_file.txt
