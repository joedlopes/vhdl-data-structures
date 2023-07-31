library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity bram_init is
    port(
         done    : out std_logic; -- notify end of the process
         rst_out : out std_logic; -- reset the process
         clk_out : out std_logic; -- to monitor system cycle
         re      : out std_logic; -- reading
         we      : out std_logic; -- writing
         addr    : out std_logic_vector(7 downto 0);  -- address index
         val     : out std_logic_vector(7 downto 0)); -- current value
end entity;

architecture behav of bram_init is
    file in_text_file : text open read_mode is "input_file.txt";
    file out_text_file : text open write_mode is "output_file.txt";

    signal clk: std_logic;
    signal rst: std_logic;

    type prog_state is (state_idle, state_read, state_write, state_done);
    
    signal pr_state, next_state : prog_state;

begin

    --- clock generator
    process
    begin
        clk <= '0';
        wait for 20 ns;
        clk <= '1';
        wait for 20 ns;
    end process;

    clk_out <= clk;

    -- reset initial pusle generator
    process

    begin
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait;
    end process;

    rst_out <= rst;

    -- state machine reset state

    process (clk, rst)
    begin
        
        if rst = '1' then
            pr_state <= state_idle;
        elsif rising_edge(clk) then
            pr_state <= next_state;
        end if;
        
    end process;

    -- state machine run

    process(clk)
        variable idx : integer range 0 to 255 := 0;

    begin

        if rising_edge(clk) then

            if pr_state = state_idle then
                idx := idx + 1;
            else
                idx := 0;
            end if;
            
        end if;

        addr <= std_logic_vector(to_unsigned(idx, addr'length));

    end process;


    -- process (clk, pr_state)
    --     variable idx : integer range 0 to 255 := 0;
    --     variable idx2 : integer range 0 to 255 := 0;
    -- begin

    --     if rising_edge(clk) and rst = '0' then

    --         if pr_state = state_idle then
    --             idx := 0;
    --             idx2 := 0;
    --             next_state <= state_read;
    --             write(output, "IDLE" & LF);

    --         elsif pr_state = state_read then

    --             idx := idx + 1;
    --             if idx > 5 then
    --                 idx := 0;
    --                 next_state <= state_write;
    --                 write(output, " GO TO WRITE" & LF);
    --             else
    --                 write(output, "STAY READ" & LF);
    --                 next_state <= state_read;
    --             end if;

    --         elsif pr_state = state_write then

    --             idx2 := idx2 + 1;
    --             if idx2 > 5 then
    --                 idx2 := 0;
    --                 write(output, " GO TO DONE" & LF);
    --                 next_state <= state_done;
    --             else
    --                 write(output, "GO WRITE" & LF);   
    --                 next_state <= state_write;
    --             end if;

    --         else
    --             -- idx := 77;
    --             next_state <= state_done;
    --         end if;
            
        
    --     end if;

    --     addr <= std_logic_vector(to_unsigned(idx, addr'length));
    
    -- end process;

end architecture;
