library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity fsm_tb is

    port(
        clk_out: out std_logic;
        ena_out: out std_logic;
        valid_out: out std_logic
    );

end entity;


architecture BEHAV of fsm_tb is

    type tb_state is (STATE_IDLE, STATE_LOAD0, STATE_LOAD1, STATE_END);

    signal clk         : std_logic;
    signal ena         : std_logic;
    signal valid       : std_logic;
    signal we          : std_logic;
        
    signal sys_counter : integer range 0 to 255;

    signal CURRENT_STATE : tb_state;
    -- signal NEXT_STATE : tb_state;

begin

    clk_out <= clk;
    ena_out <= ena;
    valid_out <= valid;

    process -- clock generator
    begin
        clk <= '0';
        wait for 20 ns;
        clk <= '1';
        wait for 25 ns;
    end process;

    process -- reset init
    begin
        ena <= '0';
        wait for 100 ns;
        ena <= '1';
        wait for 20000 ns;        
    end process;

    process (clk) -- reset FSM
    begin
        
        if rising_edge(clk) then

            if ena = '0' then
                CURRENT_STATE <= STATE_IDLE;
                we <= '0';
                sys_counter <= 0;
                valid <= '0';
            else
                
            case CURRENT_STATE is
                when STATE_LOAD0 =>
                    sys_counter <= 0;
                    valid <= '0';
                    CURRENT_STATE <= STATE_LOAD1;
                    we <= '1';
                when STATE_LOAD1 =>
                    if sys_counter >= 255 then
                        sys_counter <= 0;
                        CURRENT_STATE <= STATE_END;
                        we <= '0';
                    else 
                        sys_counter <= sys_counter + 1;
                        CURRENT_STATE <= STATE_LOAD1;
                        we <= '1';
                    end if;
                    valid <= '0';
                    
                when STATE_END =>
                    we <= '0';
                    sys_counter <= 0;
                    CURRENT_STATE <= STATE_END;
                    valid <= '1';

                when others =>
                    we <= '0';
                    sys_counter <= 0;
                    valid <= '0';
                    if ena = '1' then
                        CURRENT_STATE <= STATE_LOAD0;
                    else
                        CURRENT_STATE <= STATE_IDLE;
                    end if;
            end CASE;
                

            end if;
        end if;

    end process;


end architecture;