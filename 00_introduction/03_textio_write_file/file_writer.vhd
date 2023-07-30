library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity file_writer is
    port(y       : out std_logic;
         clk     : out std_logic;
         c_out   : out std_logic_vector(7 downto 0)
         );
end entity;


architecture BEHAV of file_writer is
    file text_file : text open write_mode is "output_file.txt";    
begin

    process 
        variable text_line : line;
        variable clk_var : std_logic := '0';
        variable counter : natural range 0 to 10 := 0;
    begin        
        
        clk_var := not clk_var;        
        clk <= clk_var;

        if counter < 10 then
            write(text_line, counter);
            writeline(text_file, text_line);
            counter := counter + 1;
            y <= '0';
        else
            y <= '1';
        end if;

        c_out <= std_logic_vector(to_unsigned(counter, c_out'length));

        wait for 10 ns;

    end process;

end BEHAV;