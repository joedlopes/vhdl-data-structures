
GHDL=ghdl

UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
   GHDL=arch -x86_64 ../../.macos/ghdl/bin/ghdl
endif

FLAGS="--std=08"

SOURCE_FILES=bram_test.vhd block_ram.vhd
TOP_ENTITY=bram_test


all: 
	$(GHDL) -a $(FLAGS) $(SOURCE_FILES)
	$(GHDL) -e $(FLAGS) $(TOP_ENTITY)
	$(GHDL) -r $(FLAGS) $(TOP_ENTITY) --wave=wave.ghw --stop-time=1us

clean:
	rm -f wave.ghw *.cf 
