library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity bram_export is
    port (
        clk           : in  std_logic;
        ena           : in  std_logic;
        rdy           : out  std_logic;

        bram_raddr    : out  std_logic_vector(7 downto 0);
        bram_rdata    : in  std_logic_vector(7 downto 0)
        );

end entity;

architecture behav of bram_export is

    function slv_to_string(signal slv: std_logic_vector(7 downto 0)) return string is
        variable temp_string: string(1 to 8);
    begin
        for i in slv'range loop
            case slv(i) is
                when '0' =>
                    temp_string(8 - i) := '0';
                when '1' =>
                    temp_string(8 - i) := '1';
                when others =>
                    temp_string(8 - i) := 'X'; -- 'X' for unknown value
            end case;
        end loop;
        return temp_string;
    end function;

    file out_text_file : text open write_mode is "output_file.txt";

    type LOADER_STATE is (STATE_IDLE, STATE_PREPARE, STATE_RUN, STATE_READY);

    signal CURRENT_STATE: LOADER_STATE := STATE_IDLE;

    signal address : integer range 0 to 255 := 0;
    
begin

    bram_raddr <= std_logic_vector(to_unsigned(address, bram_raddr'length));
    
    process(clk, ena)
        variable str1: string(1 to 8);
        variable text_line : line;
    begin
        if ena = '0' then
            CURRENT_STATE <= STATE_IDLE;
            rdy <= '0';
            address <= 0;

        elsif falling_edge(clk) then
            case CURRENT_STATE is
                when STATE_IDLE =>
                    rdy <= '0';
                    address <= 0;
                    CURRENT_STATE <= STATE_PREPARE;

                when STATE_PREPARE =>
                    rdy <= '0';
                    address <= 0;
                    CURRENT_STATE <= STATE_RUN;
                    
                when STATE_RUN =>

                    write(out_text_file, slv_to_string(bram_rdata) & LF);
                    
                    rdy <= '0';
                    if address >= 255 then
                        CURRENT_STATE <= STATE_READY;
                        address <= 0;
                    else
                        address <= address + 1;
                        CURRENT_STATE <= STATE_RUN;
                    end if;

                when STATE_READY =>
                    rdy <= '1';
                    address <= 0;
                    CURRENT_STATE <= STATE_READY;

                when others => 
                    CURRENT_STATE <= STATE_IDLE;
                    rdy <= '0';
                    address <= 0;

            end case;
        end if;
    end process;

end behav;