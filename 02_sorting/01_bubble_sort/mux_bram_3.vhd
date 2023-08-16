library ieee;

use ieee.std_logic_1164.all;

entity mux_bram_3 is

    port (
        sel       : in std_logic_vector(1 downto 0); -- 00, 01, 11 (3 stages)
        -- 00 loader
        -- 01 dut
        -- 10 export
        -- 11 idle

        loader_we       : in std_logic; -- loader
        dut_we          : in std_logic; -- dut

        loader_waddr    : in  std_logic_vector(7 downto 0);
        dut_waddr       : in  std_logic_vector(7 downto 0);

        loader_wdata   : in  std_logic_vector(7 downto 0);
        dut_wdata      : in  std_logic_vector(7 downto 0);
        
        dut_raddr       : in  std_logic_vector(7 downto 0);
        export_raddr    : in  std_logic_vector(7 downto 0);

        dut_rdata       : out  std_logic_vector(7 downto 0);
        export_rdata    : out  std_logic_vector(7 downto 0);

        -- BRAM IO
        bram_we         : out  std_logic;
        bram_waddr      : out  std_logic_vector(7 downto 0);
        bram_wdata      : out  std_logic_vector(7 downto 0);

        bram_raddr      : out  std_logic_vector(7 downto 0);
        bram_rdata      : in   std_logic_vector(7 downto 0)
    );

end entity;


architecture behav of mux_bram_3 is
begin

bram_we <= loader_we when (sel = "00") else
           dut_we when (sel = "01") else
           '0';

bram_waddr <= loader_waddr when (sel = "00") else
              dut_waddr when (sel = "01") else
              "01110111";

bram_wdata <= loader_wdata when (sel = "00") else
              dut_wdata when (sel = "01") else
              "01110111";

bram_raddr <= dut_raddr when (sel = "01") else
              export_raddr when (sel = "10") else
              "01110111";

dut_rdata <= bram_rdata when (sel = "01") else
             "01110111";

export_rdata <= bram_rdata when (sel = "10") else
                "01110111";


end behav;
