library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bubble_sort is
    port(
        clk           : in   std_logic;
        ena           : in   std_logic;
        rdy           : out  std_logic;

        bram_we       : out  std_logic;
        bram_waddr    : out  std_logic_vector(7 downto 0);
        bram_wdata    : out  std_logic_vector(7 downto 0);

        bram_raddr    : out  std_logic_vector(7 downto 0);
        bram_rdata    : in   std_logic_vector(7 downto 0)
    );
end entity;

architecture behav of bubble_sort is

    type SORT_STATE is (
        STATE_IDLE, 
        STATE_PREPARE, 
        STATE_READ_1, STATE_READ_2,
        STATE_COMPARE,
        STATE_SWAP_1, STATE_SWAP_2,
        STATE_RDY
    );
    signal CURRENT_STATE: SORT_STATE := STATE_IDLE;
    signal read_address : integer range 0 to 255 := 0;
    signal write_address : integer range 0 to 255 := 0;
    signal write_data : integer range 0 to 255 := 0;
    
    signal a1 : integer range 0 to 255 := 0;
    signal a2 : integer range 0 to 255 := 0;

    signal r1 : integer range 0 to 255 := 0;
    signal r2 : integer range 0 to 255 := 0;
begin
    
    bram_raddr <= std_logic_vector(to_unsigned(read_address, bram_raddr'length));
    bram_waddr <= std_logic_vector(to_unsigned(write_address, bram_waddr'length));
    bram_wdata <= std_logic_vector(to_unsigned(write_data, bram_wdata'length));

    process(clk, ena)
        variable val1: integer range 0 to 255 := 0;
        variable val2: integer range 0 to 255 := 0;
        variable idx1: integer range 0 to 255 := 0;
        variable idx2: integer range 0 to 255 := 0;
    begin
        if ena = '0' then
            rdy <= '0';
            read_address <= 0;
            write_address <= 0;
            bram_we <= '0';
            val1 := 0;
            val2 := 0;
            idx1 := 0;
            idx2 := 0;
            CURRENT_STATE <= STATE_IDLE;

        elsif falling_edge(clk) then
            case CURRENT_STATE is
                when STATE_IDLE =>
                    rdy <= '0';
                    bram_we <= '0';
                    read_address <= 0;
                    write_address <= 0;
                    val1 := 0;
                    val2 := 0;
                    idx1 := 0;
                    idx2 := 1;
                    CURRENT_STATE <= STATE_PREPARE;

                when STATE_PREPARE =>
                    bram_we <= '0';
                    write_address <= 0;
                    write_data <= 0;
                    read_address <= 0;
                    rdy <= '0';                    
                    CURRENT_STATE <= STATE_READ_1;
                
                when STATE_READ_1 =>
                    rdy <= '0';
                    bram_we <= '0';
                    write_address <= 0;
                    write_data <= 0;

                    read_address <= idx1;
                    CURRENT_STATE <= STATE_READ_2;
                
                when STATE_READ_2 =>
                    read_address <= idx2;
                    CURRENT_STATE <= STATE_COMPARE;
                    val1 := to_integer(unsigned(bram_rdata));
                
                when STATE_COMPARE =>
                    rdy <= '0';
                    
                    val2 := to_integer(unsigned(bram_rdata));

                    if val1 > val2 then
                        CURRENT_STATE <= STATE_SWAP_1;
                        
                        bram_we <= '1';
                        write_address <= idx1;
                        write_data <= val2;

                    else
                        
                        bram_we <= '0';
                        write_address <= 0;
                        write_data <= 0;
                        
                        if idx1 = 254 and idx2 = 255 then
                            CURRENT_STATE <= STATE_RDY;
                        else

                            if idx2 = 255 then
                                idx1 := idx1 + 1;
                                idx2 := idx1 + 1;
                            else
                                idx2 := idx2 + 1;
                            end if;
                            read_address <= idx1;
                        
                            CURRENT_STATE <= STATE_READ_2;
                        end if;
                    end if;
                
                when STATE_SWAP_1 =>
                    rdy <= '0';
                    
                    bram_we <= '1';
                    write_address <= idx2;
                    write_data <= val1;

                    CURRENT_STATE <= STATE_SWAP_2;
                
                when STATE_SWAP_2 =>
                    rdy <= '0';
                    bram_we <= '0';
                    write_address <= 0;
                    write_data <= 0;

                    if idx1 = 254 and idx2 = 255 then
                        CURRENT_STATE <= STATE_RDY;
                    else
                        if idx2 = 255 then
                            idx1 := idx1 + 1;
                            idx2 := idx1 + 1;
                        else
                            idx2 := idx2 + 1;
                        end if;
                        
                        CURRENT_STATE <= STATE_READ_2;
                    end if;

                    read_address <= idx1;

                when STATE_RDY =>
                    rdy <= '1';
                    read_address <= 0;
                    CURRENT_STATE <= STATE_RDY;

                    bram_we <= '0';
                    write_address <= 0;
                    write_data <= 0;

                when others => 
                    CURRENT_STATE <= STATE_IDLE;
                    rdy <= '0';
                    read_address <= 0;

                    bram_we <= '0';
                    write_address <= 0;
                    write_data <= 0;

            end case;
        end if;

        
        a1 <= idx1;
        a2 <= idx2;

        r1 <= val1;
        r2 <= val2;

    end process;



end behav;