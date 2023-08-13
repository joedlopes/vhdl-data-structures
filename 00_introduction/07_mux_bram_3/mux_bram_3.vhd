library ieee;

use ieee.std_logic_1164.all;

entity mux_bram_3 is

    port (
        sel       : in std_logic_vector(1 downto 0); -- 00, 01, 11 (3 stages)

        we1       : in std_logic;
        we2       : in std_logic;
        we3       : in std_logic;

        waddr1    : in  std_logic_vector(7 downto 0);
        waddr2    : in  std_logic_vector(7 downto 0);
        waddr3    : in  std_logic_vector(7 downto 0);

        wdata1    : in  std_logic_vector(7 downto 0);
        wdata2    : in  std_logic_vector(7 downto 0);
        wdata3    : in  std_logic_vector(7 downto 0);   
        
        raddr1    : in  std_logic_vector(7 downto 0);
        raddr2    : in  std_logic_vector(7 downto 0);
        raddr3    : in  std_logic_vector(7 downto 0);  

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

end entity;


architecture behav of mux_bram_3 is
begin

we <= we1 when (sel = "00") else
      we2 when (sel = "01") else
      we3;

waddr <= waddr1 when (sel = "00") else
         waddr2 when (sel = "01") else
         waddr3;

wdata <= wdata1 when (sel = "00") else
         wdata2 when (sel = "01") else
         wdata3;

raddr <= raddr1 when (sel = "00") else
         raddr2 when (sel = "01") else
         raddr3;

rdata1 <= rdata when (sel = "00") else
          "00000000";

rdata2 <= rdata when (sel = "01") else
          "00000000";

rdata3 <= rdata when (sel = "10") else
          "00000000";

end behav;
