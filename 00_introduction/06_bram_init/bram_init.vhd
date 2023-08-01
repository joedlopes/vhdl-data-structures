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
    
    function slv_to_string(signal slv: std_logic_vector(7 downto 0)) return string is
        variable temp_string: string(1 to 8);
    begin
        for i in slv'range loop
            case slv(i) is
                when '0' =>
                    temp_string(8 - i) := '0';
                when '1' =>
                    temp_string(8 - i) := '1';
                when others =>
                    temp_string(8 - i) := 'X'; -- 'X' for unknown value
            end case;
        end loop;
        return temp_string;
    end function;

    function str_to_slv(slv: string(1 to 8)) return std_logic_vector is
        variable w_data: std_logic_vector(7 downto 0);
    begin
        for I in 1 to 8 loop
            if slv(I) = '0' then
                w_data(8 - I) := '0';
            else
                w_data(8 - I) := '1';
            end if;
        end loop;
        return w_data;
    end function;
  

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

    type prog_state is (
        state_idle,
        state_load1, state_load2, state_load3,
        state_save1, state_save2, state_save3,
        state_done
    );
    
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
        wait for 20 ns;
        clk <= '1';
        wait for 25 ns;
    end process;

    process -- reset init
    begin
        rst <= '1';
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
        variable idx : integer range 0 to 256 := 0;
        variable w_data : std_logic_vector(7 downto 0);
        variable str1: string(1 to 8);
        variable text_line : line;
    begin
        if falling_edge(clk) and rst = '0' then

            if pr_state = state_idle then
                next_state <= state_load1;
                we <= '0';
                w_data := "00100011";
                idx := 33;
            elsif pr_state = state_load1 then -- prepare to load from file
                idx := 0;
                we <= '0';
                next_state <= state_load2;
            elsif pr_state = state_load2 then -- read line by line
                we <= '1';

                if not endfile(in_text_file) then
                    readline(in_text_file, text_line);
                    read(text_line, str1);
                    for I in 1 to 8 loop
                        if str1(I) = '0' then
                            w_data(8 - I) := '0';
                        else
                            w_data(8 - I) := '1';
                        end if;
                    end loop;
                end if;
                
                next_state <= state_load3;
            
            elsif pr_state = state_load3 then -- read line by line
                
                we <= '1';

                if not endfile(in_text_file) then
                    readline(in_text_file, text_line);
                    read(text_line, str1);

                    w_data := str_to_slv(str1);

                end if;
                
                if idx < 255 then
                    idx := idx + 1;
                else
                    we <= '0';
                    idx := 0;
                    next_state <= state_save1;                    
                end if;
            
            elsif pr_state = state_save1 then -- prepare to write to file
                idx := 0;
                we <= '0';
                next_state <= state_save2;
            
            elsif pr_state = state_save2 then -- write to file
                
                write(out_text_file, slv_to_string(rdata) & LF);

                if idx < 255 then
                    idx := idx + 1;
                else
                    next_state <= state_done;
                end if;                
            end if; 

        end if;

        out_idx <= std_logic_vector(to_unsigned(idx, out_idx'length));
        raddr <= std_logic_vector(to_unsigned(idx, raddr'length));
        waddr <= std_logic_vector(to_unsigned(idx, waddr'length));
        
        wdata <= w_data;

    end process;

end architecture;
