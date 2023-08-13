
GHDL=ghdl

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
   GHDL=arch -x86_64 ../../.macos/ghdl/bin/ghdl
endif


FLAGS="--std=08"

SOURCE_FILES=mux_bram_3.vhd tb_mux.vhd
TOP_ENTITY=tb_mux


all: 
	$(GHDL) -a $(FLAGS) $(SOURCE_FILES)
	$(GHDL) -e $(FLAGS) $(TOP_ENTITY)
	$(GHDL) -r $(FLAGS) $(TOP_ENTITY) --wave=wave.ghw --stop-time=40us

clean:
	rm -f wave.ghw *.cf input_file.txt output_file.txt
