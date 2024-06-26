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
    
    signal diff_debug : integer range 0 to 255 := 0;

    signal bram_value2 : integer range 0 to 255 := 0;

    constant MAX_LENGTH : integer := 255;


    signal val_left : integer range 0 to 255 := 0;
    signal val_right : integer range 0 to 255 := 0;
begin
    
    bram_raddr <= std_logic_vector(to_unsigned(address, bram_raddr'length));
    bram_we <= '0';
    bram_waddr <= "00000000";
    bram_wdata <= "00000000";
    found <= '0';

    

    process(clk, ena)
        variable idx_left   : integer range 0 to 255 := 0;
        variable idx_right  : integer range 0 to 255 := MAX_LENGTH;
        variable diff       : integer range 0 to 255 := 0;

        variable min_val    : integer range 0 to 255 := 0;
        variable max_val    : integer range 0 to 255 := 0;

        variable target     : integer range 0 to 255 := 0;
        variable bram_value : integer range 0 to 255 := 0;

    begin
        diff_debug <= diff;
        bram_value2 <= bram_value;
        
        if ena = '0' then
            CURRENT_STATE <= STATE_IDLE;
            rdy <= '0';
            address <= 0;

        elsif falling_edge(clk) then

            bram_value := to_integer(unsigned(bram_rdata));
            target := to_integer(unsigned(target_value));

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
                    
                    diff := idx_right - idx_left;

                when STATE_LOOP =>
                    
                    if diff > 2 then
                        CURRENT_STATE <= STATE_LOOP;
                        
                        if target > bram_value then
                            idx_left := address;
                        else
                            idx_right := address;
                        end if;
                        
                        address <= to_integer(to_unsigned(idx_left,8) srl 1) + to_integer(to_unsigned(idx_right,8) srl 1);
                        diff := idx_right - idx_left;
                    else
                        
                        CURRENT_STATE <= STATE_CHECK_MIDDLE;
                        if address = idx_left then
                            address <= address + 1;
                        elsif address = idx_right then
                            address <= address - 1;
                        end if;
                        
                    end if;

                when STATE_CHECK_MIDDLE =>
                    CURRENT_STATE <= STATE_CHECK_LEFT;

                    if target < bram_value then
                        idx_right := address;
                    else
                        idx_left := address;
                    end if;
                    address <= idx_left;

                when STATE_CHECK_LEFT =>
                    
                    if bram_value = target then
                        CURRENT_STATE <= STATE_RDY;
                    else
                        address <= idx_right;
                        min_val := bram_value;
                        CURRENT_STATE <= STATE_CHECK_RIGHT;
                    end if;

                when STATE_CHECK_RIGHT =>

                    if bram_value = target then
                        CURRENT_STATE <= STATE_RDY;
                    else
                        max_val := bram_value;
                        CURRENT_STATE <= STATE_MINMAX;
                    end if;

                when STATE_MINMAX =>
                    CURRENT_STATE <= STATE_RDY;

                    if (target - min_val) > (max_val - target) then
                        address <= idx_right;
                    else
                        address <= idx_left;
                    end if;
                    
                when STATE_RDY =>
                    CURRENT_STATE <= STATE_RDY;
                    rdy <= '1';

                when others => 
                    CURRENT_STATE <= STATE_IDLE;

            end case;

            
        end if;

        val_left <= idx_left;
        val_right <= idx_right;

    end process;

end behav;