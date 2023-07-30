use std.textio.all;

entity file_reader is
    port(y    : out bit;
         clk  : out bit);
end entity;

architecture BEHAV of file_reader is
    file text_file : text open read_mode is "file.txt";
    
begin

    process 
        variable text_line : line;
        variable clk_var : bit := '0';
    begin
        wait for 10 ns;
        clk_var := not clk_var;        
        clk <= clk_var;

        if not endfile(text_file) then
            readline(text_file, text_line);
            write(output, "> ");
            writeline(output, text_line);
            y <= '0';
        else
            y <= '1';
        end if;
        
        

    end process;

end BEHAV;