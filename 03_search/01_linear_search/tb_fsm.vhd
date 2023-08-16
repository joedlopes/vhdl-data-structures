library ieee;

use ieee.std_logic_1164.all;

entity tb_fsm is

end entity;

architecture behav of tb_fsm is
    
    signal clk: std_logic := '0';
    signal rst: std_logic := '1';

    type FSM_STATE is (
        STATE_IDLE, 
        LOADER_PREPARE, LOADER_RUN, LOADER_DONE,
        DUT_PREPARE, DUT_RUN, DUT_DONE,
        EXPORT_PREPARE, EXPORT_RUN, EXPORT_DONE,
        STATE_END
    );

    signal CURRENT_STATE: FSM_STATE := STATE_IDLE;

    -- block ram 256 bytes

    signal bram_clk      : std_logic;
    signal bram_we       : std_logic := '0';
    signal bram_waddr    : std_logic_vector(7 downto 0) := "11111111";
    signal bram_wdata    : std_logic_vector(7 downto 0) := "11111111";
    signal bram_raddr    : std_logic_vector(7 downto 0) := "11111111";
    signal bram_rdata    : std_logic_vector(7 downto 0) := "11111111";
    
    component block_ram is
        port (clk      : in  std_logic;
              we       : in  std_logic;
              waddr    : in  std_logic_vector(7 downto 0);
              wdata    : in  std_logic_vector(7 downto 0);
              raddr    : in  std_logic_vector(7 downto 0);
              rdata    : out std_logic_vector(7 downto 0));
    end component;
    
    -- mux bram
    
    signal sel : std_logic_vector(1 downto 0) := "11";

    component mux_bram_3 is
        port (
        sel             : in std_logic_vector(1 downto 0); -- 00, 01, 11 (3 stages)
        loader_we       : in std_logic; -- loader
        dut_we          : in std_logic; -- dut
        loader_waddr    : in  std_logic_vector(7 downto 0);
        dut_waddr       : in  std_logic_vector(7 downto 0);
        loader_wdata    : in  std_logic_vector(7 downto 0);
        dut_wdata       : in  std_logic_vector(7 downto 0);
        dut_raddr       : in  std_logic_vector(7 downto 0);
        export_raddr    : in  std_logic_vector(7 downto 0);
        dut_rdata       : out  std_logic_vector(7 downto 0);
        export_rdata    : out  std_logic_vector(7 downto 0);
        bram_we         : out  std_logic;
        bram_waddr      : out  std_logic_vector(7 downto 0);
        bram_wdata      : out  std_logic_vector(7 downto 0);
        bram_raddr      : out  std_logic_vector(7 downto 0);
        bram_rdata      : in   std_logic_vector(7 downto 0));
    end component;

    -- BRAM LOADER

    signal loader_clk       : std_logic;
    signal loader_ena       : std_logic;
    signal loader_rdy       : std_logic;
    signal loader_we        : std_logic;
    signal loader_waddr     : std_logic_vector(7 downto 0);
    signal loader_wdata     : std_logic_vector(7 downto 0);

    component bram_loader is
        port (
            clk           : in   std_logic;
            ena           : in   std_logic;
            rdy           : out  std_logic;
            bram_we       : out  std_logic;
            bram_waddr    : out  std_logic_vector(7 downto 0);
            bram_wdata    : out  std_logic_vector(7 downto 0));
    end component;

    -- BRAM EXPORT
    signal export_clk     : std_logic;
    signal export_ena     : std_logic;
    signal export_rdy     : std_logic;
    signal export_raddr   : std_logic_vector(7 downto 0);
    signal export_rdata   : std_logic_vector(7 downto 0);

    component bram_export is
        port (
            clk           : in   std_logic;
            ena           : in   std_logic;
            rdy           : out  std_logic;
            bram_raddr    : out  std_logic_vector(7 downto 0);
            bram_rdata    : in   std_logic_vector(7 downto 0));
    end component;

    -- DUT

    signal dut_clk              : std_logic;
    signal dut_ena              : std_logic;
    signal dut_rdy              : std_logic;
    signal dut_success          : std_logic;
    signal dut_target_value     : std_logic_vector(7 downto 0) := "00011100";

    signal dut_we    : std_logic                    := '0';
    signal dut_waddr : std_logic_vector(7 downto 0) := "00001111";
    signal dut_wdata : std_logic_vector(7 downto 0) := "00001111";
    signal dut_raddr : std_logic_vector(7 downto 0) := "00001111";
    signal dut_rdata : std_logic_vector(7 downto 0) := "00001111";

    component linear_search is
        port(
            clk           : in   std_logic;
            ena           : in   std_logic;
            rdy           : out  std_logic;
            
            success       : out  std_logic; -- result in br
            target_value  : in   std_logic_vector(7 downto 0);
    
            bram_we       : out  std_logic;
            bram_waddr    : out  std_logic_vector(7 downto 0);
            bram_wdata    : out  std_logic_vector(7 downto 0);
            bram_raddr    : out  std_logic_vector(7 downto 0);
            bram_rdata    : in   std_logic_vector(7 downto 0)
        );
    end component;

begin
    -- BRAM mapping
    BRAM1: block_ram PORT MAP(
        clk      => bram_clk,
        we       => bram_we,
        waddr    => bram_waddr,
        wdata    => bram_wdata,
        raddr    => bram_raddr,
        rdata    => bram_rdata
    );
    
    bram_clk <= clk;

    -- BRAM LOADER

    LOADER1: bram_loader PORT MAP(
        clk           => loader_clk,
        ena           => loader_ena,
        rdy           => loader_rdy,
        bram_we       => loader_we,
        bram_waddr    => loader_waddr,
        bram_wdata    => loader_wdata
    );

    loader_clk <= clk;

    -- BRAM EXPORT

    EXPORT1: bram_export PORT MAP(
        clk           => export_clk,
        ena           => export_ena,
        rdy           => export_rdy  ,
        bram_raddr    => export_raddr,
        bram_rdata    => export_rdata
    );

    export_clk <= clk;

    -- DUT mapping
    DUT1: linear_search PORT MAP(
        clk           => dut_clk,
        ena           => dut_ena,
        rdy           => dut_rdy,
        
        success       => dut_success,
        target_value  => dut_target_value,

        bram_we       => dut_we,
        bram_waddr    => dut_waddr,
        bram_wdata    => dut_wdata,
        bram_raddr    => dut_raddr,
        bram_rdata    => dut_rdata
    );

    dut_clk <= clk;

    -- MUX3 BRAM mapping

    MUX3 : mux_bram_3 PORT MAP(
        sel           => sel,
        loader_we     => loader_we,
        dut_we        => dut_we,
        loader_waddr  => loader_waddr,
        dut_waddr     => dut_waddr,
        loader_wdata  => loader_wdata,
        dut_wdata     => dut_wdata,
        dut_raddr     => dut_raddr,
        export_raddr  => export_raddr,
        dut_rdata     => dut_rdata,
        export_rdata  => export_rdata,
        bram_we       => bram_we,
        bram_waddr    => bram_waddr,
        bram_wdata    => bram_wdata,
        bram_raddr    => bram_raddr,
        bram_rdata    => bram_rdata
    );

    process -- clock generator
    begin
        clk <= '0';
        wait for 20 ns;
        clk <= '1';
        wait for 20 ns;
    end process;

    process -- reset
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;


    process (clk) -- fsm
    begin
        if rst = '1' then
            CURRENT_STATE <= STATE_IDLE;
            loader_ena <= '0';
            export_ena <= '0';
            dut_ena <= '0';
            sel <= "11";

        elsif rising_edge(clk) then

            case CURRENT_STATE is

                when STATE_IDLE =>
                    CURRENT_STATE <= LOADER_PREPARE;
                    loader_ena <= '0';
                    export_ena <= '0';
                    dut_ena <= '0';
                    sel <= "11";
                    
                -- loader ------------------------------------------------------
                when LOADER_PREPARE =>
                    CURRENT_STATE <= LOADER_RUN;
                    loader_ena <= '1';
                    export_ena <= '0';
                    dut_ena <= '0';
                    sel <= "00";

                when LOADER_RUN =>

                    loader_ena <= '1';
                    export_ena <= '0';
                    dut_ena <= '0';
                    sel <= "00";

                    if loader_rdy = '1' then
                        CURRENT_STATE <= LOADER_DONE;
                    else
                        CURRENT_STATE <= LOADER_RUN;                    
                    end if;
                
                when LOADER_DONE =>
                    CURRENT_STATE <= DUT_PREPARE;
                    loader_ena <= '0';
                    export_ena <= '0';
                    dut_ena <= '0';
                    sel <= "11";
                
                -- dut ---------------------------------------------------------
                when DUT_PREPARE =>
                    CURRENT_STATE <= DUT_RUN;
                    loader_ena <= '0';
                    export_ena <= '0';
                    dut_ena <= '1';
                    sel <= "01";

                when DUT_RUN =>
                    CURRENT_STATE <= DUT_DONE;
                    loader_ena <= '0';
                    export_ena <= '0';
                    dut_ena <= '1';
                    sel <= "01";

                    if dut_rdy = '1' then
                        CURRENT_STATE <= DUT_DONE;
                    else
                        CURRENT_STATE <= DUT_RUN;                    
                    end if;

                when DUT_DONE =>
                    CURRENT_STATE <= EXPORT_RUN;
                    loader_ena <= '0';
                    export_ena <= '0';
                    dut_ena <= '0';
                    sel <= "11";

                -- export ------------------------------------------------------

                when EXPORT_PREPARE =>
                    CURRENT_STATE <= EXPORT_RUN;
                    loader_ena <= '0';
                    export_ena <= '1';
                    dut_ena <= '0';
                    sel <= "10";

                when EXPORT_RUN =>
                    CURRENT_STATE <= EXPORT_DONE;
                    loader_ena <= '0';
                    export_ena <= '1';
                    dut_ena <= '0';
                    sel <= "10";

                    if export_rdy   = '1' then
                        CURRENT_STATE <= EXPORT_DONE;
                    else
                        CURRENT_STATE <= EXPORT_RUN;                    
                    end if;

                when EXPORT_DONE =>
                    CURRENT_STATE <= STATE_END;
                    loader_ena <= '0';
                    export_ena <= '0';
                    dut_ena <= '0';
                    sel <= "11";

                -- done ------------------------------------------------------
                when others =>
                    CURRENT_STATE <= STATE_END;
                    
                    loader_ena <= '0';
                    export_ena <= '0';
                    dut_ena <= '0';
                    sel <= "11";
            end case;

        end if;
    end process;


end behav;