-- dual read and write 8bit block ram

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity block_ram is
    port (
        clk      : in  std_logic;

        we       : in  std_logic;
        waddr    : in  std_logic_vector(7 downto 0);
        wdata    : in  std_logic_vector(7 downto 0);

        raddr    : in  std_logic_vector(7 downto 0);
        rdata    : out std_logic_vector(7 downto 0));
end entity;


architecture BEHAV of block_ram is
    type ram_type is array (255 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (others => "01110111");
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                RAM(to_integer(unsigned(waddr))) <= wdata;
            end if;
            rdata <= RAM(to_integer(unsigned(raddr)));
        end if;
    end process;

end architecture;