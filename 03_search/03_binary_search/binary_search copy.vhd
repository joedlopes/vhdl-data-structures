-- perform binary search to find the closest value at left

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_search is
    port(
        clk           : in   std_logic;
        ena           : in   std_logic;
        rdy           : out  std_logic;
        found         : out  std_logic; -- found exact value

        target_value  : in  std_logic_vector(7 downto 0);

        bram_we       : out  std_logic;
        bram_waddr    : out  std_logic_vector(7 downto 0);
        bram_wdata    : out  std_logic_vector(7 downto 0);

        bram_raddr    : out  std_logic_vector(7 downto 0);
        bram_rdata    : in   std_logic_vector(7 downto 0)
    );
end entity;

architecture behav of binary_search is

    type SEARCH_STATES is (
        STATE_IDLE, STATE_PREPARE,
        STATE_READ,

        STATE_LIMIT_LEFT,
        STATE_LIMIT_RIGHT,

        STATE_LOOP,

        STATE_CHECK_MIDDLE,
        STATE_CHECK_LEFT,
        STATE_CHECK_RIGHT,
        STATE_SUB,
        STATE_MINMAX,
        
        STATE_RDY
    );
    signal CURRENT_STATE: SEARCH_STATES := STATE_IDLE;
    signal address : integer range 0 to 255 := 0;
    
    signal target: integer range 0 to 255 := 0;
    signal bram_value : integer range 0 to 255 := 0;

    constant MAX_LENGTH : integer := 255;
begin
    
    bram_raddr <= std_logic_vector(to_unsigned(address, bram_raddr'length));
    bram_we <= '0';
    bram_waddr <= "00000000";
    bram_wdata <= "00000000";
    found <= '0';

    bram_value <= to_integer(unsigned(bram_rdata));
    target <= to_integer(unsigned(target_value));

    process(clk, ena)
        variable idx_left   : integer range 0 to 255 := 0;
        variable idx_right  : integer range 0 to 255 := MAX_LENGTH;
        variable diff       : integer range 0 to 255 := 0;

        -- variable sig_left   : unsigned(7 downto 0) := "00000000";
        -- variable sig_right  : unsigned(7 downto 0) := "11111111";
    begin
        if ena = '0' then
            CURRENT_STATE <= STATE_IDLE;
            rdy <= '0';
            address <= 0;

        elsif falling_edge(clk) then
            case CURRENT_STATE is
                when STATE_IDLE =>
                    CURRENT_STATE <= STATE_PREPARE;
                    rdy <= '0';

                when STATE_PREPARE =>
                    CURRENT_STATE <= STATE_LIMIT_LEFT;
                    address <= 0;
                    
                when STATE_LIMIT_LEFT =>
                    if target <= bram_value then
                        CURRENT_STATE <= STATE_RDY;
                    else
                        address <= MAX_LENGTH;
                        CURRENT_STATE <= STATE_LIMIT_RIGHT;
                    end if;

                when STATE_LIMIT_RIGHT =>
                    if target > bram_value then
                        CURRENT_STATE <= STATE_RDY;
                    else
                        address <= MAX_LENGTH;
                        CURRENT_STATE <= STATE_LOOP;
                    end if;
                    
                    -- diff := idx_right/2 - idx_left/2;
                    
                    -- sig_left := to_unsigned(idx_left, bram_raddr'length);
                    -- address <=  to_integer(unsigned(idx_left) srl 1);
                            -- + shift_right(to_unsigned(idx_right, 8), 1);

                when STATE_LOOP =>
                    
                    if diff > 2 then
                        CURRENT_STATE <= STATE_CHECK_MIDDLE;
                        if address = idx_left then
                            address <= address + 1;
                        elsif address = idx_right then
                            address <= address - 1;
                        end if;

                    else
                        CURRENT_STATE <= STATE_LOOP;
                        diff := idx_right - idx_left;

                        if bram_value > target then
                            idx_left := address;
                        else
                            idx_right := address;
                        end if;
                        
                        -- address <= (idx_left srl 1) + (idx_right srl 1); 
                    end if;

                when STATE_CHECK_MIDDLE =>
                    CURRENT_STATE <= STATE_LOOP;

                when STATE_CHECK_LEFT =>
                    CURRENT_STATE <= STATE_LOOP;

                when STATE_CHECK_RIGHT =>
                    CURRENT_STATE <= STATE_LOOP;
                    
                when STATE_RDY =>
                    CURRENT_STATE <= STATE_RDY;
                    rdy <= '1';

                when others => 
                    CURRENT_STATE <= STATE_IDLE;

            end case;

            
        end if;

    end process;

end behav;