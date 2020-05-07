library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity sim_mcgen is
  Port ( RsTx: out std_logic);
end sim_mcgen;

architecture Behavioral of sim_mcgen is
        component au2mc
            port (data_in     : in  std_logic_vector (11 downto 0);
                out_data   : out std_logic;
                clk : in  std_logic;
                clr     : in  std_logic);
        end component;
        component symdet
            Port ( d_bin : in STD_LOGIC;
                    dot : out STD_LOGIC;
                    dash : out STD_LOGIC;
                    lg : out STD_LOGIC;
                    wg : out STD_LOGIC;
                    valid : out STD_LOGIC;
                    clr : in STD_LOGIC;
                    clk : in STD_LOGIC);
        end component;
        component mcdecoder is
            port(clk : in std_logic;
                 valid : in std_logic;
                    clr : in std_logic;
                    dash : in std_logic;
                    dot : in std_logic;
                    lg :in std_logic;
                    wg : in std_logic;
                    dvalid :  out std_logic;
                    error : out std_logic;
                    dout : out std_logic_vector(7 downto 0));
        end component;
        component uart_wren
            Port (
                    clr : in std_logic;
                    clk : in STD_LOGIC;
                    wr_valid : in STD_LOGIC;
                    dout : out STD_LOGIC;
                    data_in : in std_logic_vector(7 downto 0);
                    data_out : out std_logic_vector(7 downto 0));
        end component;
        component simpuart
            Port ( din : in STD_LOGIC_VECTOR (7 downto 0);
                wen : in STD_LOGIC;
                sout : out STD_LOGIC;
                clr : in STD_LOGIC;
                clk_48k : in STD_LOGIC);
        end component;
        --audio
        signal ain: std_logic_vector (11 downto 0);
        file file_in : text;
        signal TbSimEnded : std_logic := '0';
        signal clk_48: std_logic;
        --symdet
        signal d_bin, dot, dash, lg, wg, valid: std_logic;
        signal clr: std_logic:= '0';
        --mcdecod
        signal dvalid, error: std_logic;
        signal decoder_out: std_logic_vector (7 downto 0);
        --uart_wren
        signal uart_wr: std_logic; 
        signal uartFIFO_out: std_logic_vector (7 downto 0);
        --simpuart
        signal sout_i: std_logic_vector (0 downto 0);
        --blank
        constant clkPeriod : time := (1 ms)/48;
begin
dut : au2mc
    port map (data_in     => ain,
              out_data   => d_bin,
              clk => clk_48,
              clr     => clr);
symdet_inst: symdet PORT MAP (
       d_bin=>d_bin,
       dot=>dot,
       dash=>dash,
       lg=>lg,
       wg=>wg,
       valid=>valid,
       clr=>clr,
       clk=>clk_48);
mcdecoder_inst: mcdecoder PORT MAP (
         clk => clk_48,
         valid => valid,
          clr =>clr,
          dash=>dash,
          dot=>dot,
          lg=>lg,
          wg=>wg,
          dvalid=>dvalid,
          error=> error,
          dout => decoder_out);
uart_wren_inst: uart_wren PORT MAP (
       clr => clr,
       clk => clk_48,
       wr_valid => dvalid,
       dout => uart_wr,
       data_in => decoder_out,
       data_out => uartFIFO_out);
simpuart_inst: simpuart PORT MAP (
       din=>uartFIFO_out,
       wen=>uart_wr,
       sout=>sout_i(0),
       clr=>clr,
       clk_48k=>clk_48);
       
RsTx <= sout_i(0);
         
clkPro : process
                 begin
                     clk_48 <= '0';
                     wait for clkPeriod/2;
                     clk_48 <= '1';
                     wait for clkPeriod/2;
             end process; 
             
stimuli : process
        -- Variables for simulation
        variable v_linein     : line;
        variable v_auin       : std_logic_vector(15 downto 0);

    begin
        -- EDIT Adapt initialization as needed
        ain <= (others => '0');

        -- Reset generation
        clr <= '1';
        wait for 100 ns;
        clr <= '0';
        wait for 100 ns;

        -- Stimuli starts here.  DO NOT modify anything above this line

        file_open(file_in, "morse_48k_goodluck.txt",  read_mode);

        while not endfile(file_in) loop
          readline(file_in, v_linein);
          read(v_linein, v_auin);
          ain <= v_auin(15 downto 4);

          wait until rising_edge(clk_48);
        end loop;

        file_close(file_in);

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;
end Behavioral;

configuration cfg_tb_au2mc of sim_mcgen is
    for Behavioral
    end for;
end cfg_tb_au2mc;
