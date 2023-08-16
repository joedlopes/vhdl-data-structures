library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity linear_search_max is
    port(
        clk           : in   std_logic;
        ena           : in   std_logic;
        rdy           : out  std_logic;

        max_value     : out  std_logic_vector(7 downto 0);

        bram_we       : out  std_logic;
        bram_waddr    : out  std_logic_vector(7 downto 0);
        bram_wdata    : out  std_logic_vector(7 downto 0);

        bram_raddr    : out  std_logic_vector(7 downto 0);
        bram_rdata    : in   std_logic_vector(7 downto 0)
    );
end entity;

architecture behav of linear_search_max is

    type LOADER_STATE is (STATE_IDLE, STATE_PREPARE, STATE_RUN, STATE_RDY);
    signal CURRENT_STATE: LOADER_STATE := STATE_IDLE;
    signal address : integer range 0 to 255 := 0;
    
begin
    
    bram_raddr <= std_logic_vector(to_unsigned(address, bram_raddr'length));
    bram_we <= '0';
    bram_waddr <= "00000000";
    bram_wdata <= "00000000";

    process(clk, ena)
        variable max_val : integer range 0 to 255 := 0;
    begin
        if ena = '0' then
            CURRENT_STATE <= STATE_IDLE;
            rdy <= '0';
            address <= 0;
            max_val := 0;

        elsif falling_edge(clk) then
            case CURRENT_STATE is
                when STATE_IDLE =>
                    rdy <= '0';
                    max_val := 0;
                    CURRENT_STATE <= STATE_PREPARE;

                when STATE_PREPARE =>
                    rdy <= '0';
                    address <= 0;
                    max_val := 0;
                    
                    CURRENT_STATE <= STATE_RUN;
                    
                when STATE_RUN =>
                    rdy <= '0';
                    
                    
                    if to_integer(unsigned(bram_rdata)) > max_val then
                        CURRENT_STATE <= STATE_RDY;
                        max_val := to_integer(unsigned(bram_rdata));
                        
                    end if;

                    if address >= 255 then
                        CURRENT_STATE <= STATE_RDY;
                        address <= 0;
                    else
                        address <= address + 1;
                        CURRENT_STATE <= STATE_RUN;
                    end if;

                when STATE_RDY =>
                    rdy <= '1';
                    address <= 0;
                    CURRENT_STATE <= STATE_RDY;

                when others => 
                    CURRENT_STATE <= STATE_IDLE;
                    rdy <= '0';
                    address <= 0;
            end case;
        end if;

        max_value <= std_logic_vector(to_unsigned(max_val, bram_raddr'length));

    end process;



end behav;