-- dual read and write 8bit block ram

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_mux is
end entity;


architecture BEHAV of tb_mux is
    
    signal sel       : std_logic_vector(1 downto 0) := "00";
    signal we1       : std_logic;
    signal we2       : std_logic;
    signal we3       : std_logic;
    signal waddr1    : std_logic_vector(7 downto 0);
    signal waddr2    : std_logic_vector(7 downto 0);
    signal waddr3    : std_logic_vector(7 downto 0);

    signal wdata1    : std_logic_vector(7 downto 0);
    signal wdata2    : std_logic_vector(7 downto 0);
    signal wdata3    : std_logic_vector(7 downto 0);   
    
    signal raddr1    : std_logic_vector(7 downto 0);
    signal raddr2    : std_logic_vector(7 downto 0);
    signal raddr3    : std_logic_vector(7 downto 0);  

    signal rdata1    : std_logic_vector(7 downto 0);
    signal rdata2    : std_logic_vector(7 downto 0);
    signal rdata3    : std_logic_vector(7 downto 0);

    -- BRAM IO
    signal we        : std_logic;
    signal waddr     : std_logic_vector(7 downto 0);
    signal wdata     : std_logic_vector(7 downto 0);

    signal raddr     : std_logic_vector(7 downto 0);
    signal rdata     : std_logic_vector(7 downto 0);

    component mux_bram_3 is
        port (
            sel       : in   std_logic_vector(1 downto 0); -- 00, 01, 11 (3 stages)

            we1       : in   std_logic;
            we2       : in   std_logic;
            we3       : in   std_logic;
            waddr1    : in   std_logic_vector(7 downto 0);
            waddr2    : in   std_logic_vector(7 downto 0);
            waddr3    : in   std_logic_vector(7 downto 0);

            wdata1    : in   std_logic_vector(7 downto 0);
            wdata2    : in   std_logic_vector(7 downto 0);
            wdata3    : in   std_logic_vector(7 downto 0);   
            
            raddr1    : in   std_logic_vector(7 downto 0);
            raddr2    : in   std_logic_vector(7 downto 0);
            raddr3    : in   std_logic_vector(7 downto 0);  
    
            rdata1    : out  std_logic_vector(7 downto 0);
            rdata2    : out  std_logic_vector(7 downto 0);
            rdata3    : out  std_logic_vector(7 downto 0);
    
            -- BRAM IO
            we        : out  std_logic;
            waddr     : out  std_logic_vector(7 downto 0);
            wdata     : out  std_logic_vector(7 downto 0);
    
            raddr     : out  std_logic_vector(7 downto 0);
            rdata     : in   std_logic_vector(7 downto 0)
        );
    end component;

begin

    MUX_BRAM: mux_bram_3 PORT MAP (
        sel  =>  sel, we1 => we1, we2 => we2, we3 => we3, 
        waddr1 => waddr1, waddr2 => waddr2, waddr3 => waddr3, 
        wdata1 => wdata1, wdata2 => wdata2, wdata3 => wdata3,
        raddr1 => raddr1, raddr2 => raddr2, raddr3 => raddr3,
        rdata1 => rdata1, rdata2 => rdata2, rdata3 => rdata3,
        we => we, waddr => waddr, wdata => wdata, 
        raddr => raddr, rdata => rdata);

    process
    begin
        rdata <= "10000001";

        waddr1 <= "00010001";
        wdata1 <= "00010001";
        
        raddr1 <= "00010001";
        we1 <= '1';

        waddr2 <= "00100010";
        wdata2 <= "00100010";
        
        raddr2 <= "00100010";
        we2 <= '0';

        waddr3 <= "00110011";
        wdata3 <= "00110011";
        
        raddr3 <= "00110011";
        we3 <= '1';

        sel <= "00";
        wait for 100 ns;

        sel <= "01";
        wait for 100 ns;

        sel <= "10";
        wait for 100 ns;
        
        wait;
    end process;

end architecture;
