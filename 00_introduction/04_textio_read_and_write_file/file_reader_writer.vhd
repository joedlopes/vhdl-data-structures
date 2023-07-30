library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity file_reader_writer is
    port(done       : out std_logic;
         clk        : out std_logic;
         c_out     : out std_logic_vector(7 downto 0);
         v_out          : out std_logic_vector(7 downto 0)
         );
end entity;

architecture BEHAV of file_reader_writer is
    file in_text_file : text open read_mode is "input_file.txt";
    file out_text_file : text open write_mode is "output_file.txt";
begin

    process
        variable text_line : line;
        variable text_line2 : line;
        variable clk_var : std_logic := '0';
        variable row_count : natural := 0;

        variable str1: string(1 to 8);

    begin

        if not endfile(in_text_file) then
            readline(in_text_file, text_line);
            read(text_line, str1);
            
            write(output, "> ");
            write(output, str1 & LF);
            
            write(out_text_file, "> ");
            write(out_text_file, str1 & LF);

            row_count := row_count + 1;        
            done <= '0';
        else
            done <= '1';
        end if;


        for idx in 1 to 8 loop
            if str1(idx) = '0' then
                v_out(8-idx) <= '0';
            else
                v_out(8-idx) <= '1';
            end if;
        end loop;

        c_out <= std_logic_vector(to_unsigned(row_count, c_out'length));
        

        clk_var := not clk_var;        
        clk <= clk_var;
        wait for 10 ns;
    end process;

end BEHAV;
