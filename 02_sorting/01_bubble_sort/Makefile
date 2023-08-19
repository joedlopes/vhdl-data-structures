
GHDL=ghdl

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
   GHDL=arch -x86_64 ../../.macos/ghdl/bin/ghdl
endif


FLAGS="--std=08"

SOURCE_FILES=tb_fsm.vhd block_ram.vhd mux_bram_3.vhd bram_loader.vhd bram_export.vhd bubble_sort.vhd
TOP_ENTITY=tb_fsm


all:
	python3 gen_input_file.py
	$(GHDL) -a $(FLAGS) $(SOURCE_FILES)
	$(GHDL) -e $(FLAGS) $(TOP_ENTITY)
	$(GHDL) -r $(FLAGS) $(TOP_ENTITY) --wave=wave.ghw --stop-time=10ms
	python3 check_output_file.py
clean:
	rm -f wave.ghw *.cf input_file.txt output_file.txt
