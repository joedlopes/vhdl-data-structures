library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity bram_init is
    port(
         out_clk     : out std_logic;
         out_we      : out std_logic;
         
         out_waddr   : out std_logic_vector(7 downto 0);  
         out_wdata   : out std_logic_vector(7 downto 0);

         out_raddr   : out std_logic_vector(7 downto 0);
         out_rdata   : out std_logic_vector(7 downto 0);

         out_idx     : out std_logic_vector(7 downto 0)); -- current value
end entity;

architecture behav of bram_init is

    file in_text_file : text open read_mode is "input_file.txt";
    file out_text_file : text open write_mode is "output_file.txt";

    signal clk      : std_logic;
    signal we       : std_logic;
    signal waddr    : std_logic_vector(7 downto 0);
    signal wdata    : std_logic_vector(7 downto 0);
    signal raddr    : std_logic_vector(7 downto 0);
    signal rdata    : std_logic_vector(7 downto 0);

    component block_ram is
        port (
            clk      : in  std_logic;

            we       : in  std_logic;
            waddr    : in  std_logic_vector(7 downto 0);
            wdata    : out std_logic_vector(7 downto 0);

            raddr    : in  std_logic_vector(7 downto 0);
            rdata    : out std_logic_vector(7 downto 0));
    end component;

    type prog_state is (state_idle, state_read1, state_read2, state_write1, state_write2, state_done);
    
    signal pr_state, next_state : prog_state;
    signal rst : std_logic;

begin

    RAM1: block_ram PORT MAP (clk => clk, we => we,
                              waddr => waddr, wdata => wdata,
                              raddr => raddr, rdata => rdata);

    out_clk <= clk;
    out_we <= we;
    out_rdata <= rdata;
    out_wdata <= wdata;
    out_raddr <= raddr;
    out_waddr <= waddr;

    process -- clock generator
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process;

    process -- reset init
    begin
        -- we <= '0';
        rst <= '1';
        -- waddr <= "00000000";
        -- wdata <= "00000000";
        -- raddr <= "00000000";
        -- next_state <= state_idle;
        -- pr_state <= state_idle;
        wait for 200 ns;
        rst <= '0';
        wait;
    end process;

    process (clk, rst) -- reset FSM
    begin
        if rst = '1' then
            pr_state <= state_idle;
        elsif rising_edge(clk) then
            pr_state <= next_state;
        end if;
    end process;

    process (clk, pr_state)
        variable idx : integer := 0;
    begin
        if falling_edge(clk) and rst = '0' then

            if pr_state = state_idle then
                next_state <= state_read1;
                we <= '0';
            elsif pr_state = state_read1 then
                idx := 0;
                we <= '1';
                next_state <= state_read2;
            elsif pr_state = state_read2 then
                we <= '1';
                idx := idx + 1;
                if idx >= 9 then
                    next_state <= state_write1;
                end if;
            elsif pr_state = state_write1 then
                we <= '0';
                idx := 0;
                next_state <= state_write2;
            elsif pr_state = state_write2 then
                we <= '0';
                idx := idx + 1;
                if idx >= 9 then
                    next_state <= state_done;
                end if;
            else
                idx := 77;
                next_state <= state_idle;
            end if;

        end if;

        out_idx <= std_logic_vector(to_unsigned(idx, out_idx'length));
        raddr <= std_logic_vector(to_unsigned(idx, raddr'length));
        waddr <= std_logic_vector(to_unsigned(idx, waddr'length));
        wdata <= std_logic_vector(to_unsigned(idx, wdata'length));

    end process;

end architecture;
