library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity bram_test is
    port(
         out_clk     : out std_logic;
         out_we      : out std_logic;
         
         out_waddr   : out std_logic_vector(7 downto 0);  
         out_wdata   : out std_logic_vector(7 downto 0);

         out_raddr   : out std_logic_vector(7 downto 0);
         out_rdata   : out std_logic_vector(7 downto 0));
end entity;

architecture behav of bram_test is

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

    process
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process;

    process
    begin
        
        we <= '0';
        waddr <= "00000000";
        wdata <= "00000000";
        raddr <= "00000000";
        wait for 60 ns;
        we <= '1';
        wait for 60 ns;
        we <= '0';
        wait for 25 ns;
        raddr <= "00000001";
        wait for 70 ns;
        raddr <= "00000010";
        wait for 70 ns;

        waddr <= "00001000";
        wdata <= "00011000";
        raddr <= "00001000";
        we <= '1';
        wait for 70 ns;
        we <= '0';        
        wait for 70 ns;

        wait;

    end process;

end architecture;
