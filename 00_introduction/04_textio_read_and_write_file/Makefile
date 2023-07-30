
GHDL=ghdl
FLAGS="--std=08"

SOURCE_FILES=file_reader_writer.vhd
TOP_ENTITY=file_reader_writer


all: 
	$(GHDL) -a $(FLAGS) $(SOURCE_FILES)
	$(GHDL) -e $(FLAGS) $(TOP_ENTITY)
	$(GHDL) -r $(FLAGS) $(TOP_ENTITY) --wave=wave.ghw --stop-time=1us

clean:
	rm -f wave.ghw *.cf output_file.txt
