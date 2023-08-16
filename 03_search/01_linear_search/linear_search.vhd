library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity linear_search is
    port(
        clk           : in   std_logic;
        ena           : in   std_logic;
        rdy           : out  std_logic;
        
        success       : out  std_logic; -- result in br
        target_value  : in   std_logic_vector(7 downto 0);

        bram_we       : out  std_logic;
        bram_waddr    : out  std_logic_vector(7 downto 0);
        bram_wdata    : out  std_logic_vector(7 downto 0);

        bram_raddr    : out  std_logic_vector(7 downto 0);
        bram_rdata    : in   std_logic_vector(7 downto 0)
    );
end entity;

architecture behav of linear_search is

    type LOADER_STATE is (STATE_IDLE, STATE_PREPARE, STATE_RUN, STATE_FAIL, STATE_SUCCESS);
    signal CURRENT_STATE: LOADER_STATE := STATE_IDLE;
    signal address : integer range 0 to 255 := 0;

begin

    bram_raddr <= std_logic_vector(to_unsigned(address, bram_raddr'length));
    bram_we <= '0';
    bram_waddr <= "00000000";
    bram_wdata <= "00000000";

    process(clk, ena)
    begin
        if ena = '0' then
            CURRENT_STATE <= STATE_IDLE;
            rdy <= '0';
            success <= '0';
            address <= 0;

        elsif falling_edge(clk) then
            case CURRENT_STATE is
                when STATE_IDLE =>
                    rdy <= '0';
                    success <= '0';
                    address <= 0;
                    CURRENT_STATE <= STATE_PREPARE;

                when STATE_PREPARE =>
                    rdy <= '0';
                    success <= '0';
                    address <= 0;
                    CURRENT_STATE <= STATE_RUN;
                    
                when STATE_RUN =>
                    
                    rdy <= '0';
                    success <= '0';

                    if bram_rdata = target_value then
                        CURRENT_STATE <= STATE_SUCCESS;
                        address <= address + 0;
                    elsif address >= 255 then
                        CURRENT_STATE <= STATE_FAIL;
                        address <= 0;
                    else
                        address <= address + 1;
                        CURRENT_STATE <= STATE_RUN;
                    end if;

                when STATE_FAIL =>
                    rdy <= '1';
                    success <= '0';
                    address <= 0;
                    CURRENT_STATE <= STATE_FAIL;

                when STATE_SUCCESS =>
                    rdy <= '1';
                    address <= address + 0;
                    success <= '1';
                    CURRENT_STATE <= STATE_SUCCESS;

                when others => 
                    CURRENT_STATE <= STATE_IDLE;
                    rdy <= '0';
                    success <= '0';
                    address <= 0;

            end case;
        end if;
    end process;



end behav;