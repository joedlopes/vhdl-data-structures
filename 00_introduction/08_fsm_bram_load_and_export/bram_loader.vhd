library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity bram_loader is
    port (
        clk           : in  std_logic;
        ena           : in  std_logic;
        valid         : out  std_logic;

        bram_we       : out  std_logic;
        bram_waddr    : out  std_logic_vector(7 downto 0);
        bram_wdata    : out  std_logic_vector(7 downto 0)
        
        -- bram reader is ignored

        );

end entity;

architecture behav of bram_loader is

    function str_to_slv(slv: string(1 to 8)) return std_logic_vector is
        variable w_data: std_logic_vector(7 downto 0);
    begin
        for I in 1 to 8 loop
            if slv(I) = '0' then
                w_data(8 - I) := '0';
            else
                w_data(8 - I) := '1';
            end if;
        end loop;
        return w_data;
    end function;

    file in_text_file : text open read_mode is "input_file.txt";

    type LOADER_STATE is (STATE_IDLE, STATE_PREPARE, STATE_RUN, STATE_VALID);

    signal CURRENT_STATE: LOADER_STATE := STATE_IDLE;

    signal address : integer range 0 to 255 := 0;

    signal wdata    : std_logic_vector(7 downto 0) := "00000000";
    
begin

    bram_waddr <= std_logic_vector(to_unsigned(address, bram_waddr'length));
    bram_wdata <= wdata;

    process(clk, ena)
        variable str1: string(1 to 8);
        variable text_line : line;
    begin
        if ena = '0' then
            CURRENT_STATE <= STATE_IDLE;
            valid <= '0';
            bram_we <= '0';            
            address <= 0;
            wdata <= "01110111";

        elsif falling_edge(clk) then
            case CURRENT_STATE is
                when STATE_IDLE =>
                    valid <= '0';
                    bram_we <= '0';
                    address <= 0;
                    CURRENT_STATE <= STATE_PREPARE;
                    wdata <= "01110111";

                when STATE_PREPARE =>
                    valid <= '0';
                    bram_we <= '1';
                    address <= 0;
                    CURRENT_STATE <= STATE_RUN;

                    if not endfile(in_text_file) then
                        readline(in_text_file, text_line);
                        read(text_line, str1);
                        wdata <= str_to_slv(str1);
                    else
                        wdata <= "01110111";
                    end if;

                when STATE_RUN =>

                    if not endfile(in_text_file) then
                        readline(in_text_file, text_line);
                        read(text_line, str1);
                        wdata <= str_to_slv(str1);
                    else
                        wdata <= "00100011";
                    end if;
                    valid <= '0';
                    if address >= 255 then
                        bram_we <= '0';
                        CURRENT_STATE <= STATE_VALID;
                    else
                        address <= address + 1;
                        valid <= '0';
                        bram_we <= '1';
                        CURRENT_STATE <= STATE_RUN;
                    end if;

                when STATE_VALID =>
                    valid <= '1';
                    bram_we <= '0';
                    address <= 0;
                    CURRENT_STATE <= STATE_VALID;
                    wdata <= "00100011";

                when others => 
                    CURRENT_STATE <= STATE_IDLE;
                    valid <= '0';
                    bram_we <= '0';
                    address <= 0;
                    wdata <= "00100011";
            end case;
        end if;
    end process;

end behav;