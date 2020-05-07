library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sim_encoder is
  Port (sout: out std_logic);
end sim_encoder;

architecture Behavioral of sim_encoder is
    component mcencoder
        port(din: in std_logic_vector(7 downto 0);
             den, clk, clr: in std_logic;
             sout: out std_logic
             );
    end component;
    
    --clock
    signal clk_48: std_logic;
    signal clr: std_logic;
    constant clkPeriod : time := (1 ms)/48;
    --ASCII input signal
    signal din: std_logic_vector(7 downto 0):= "00000000";
    signal den: std_logic:= '0';
begin
    top: mcencoder port map
        (din => din,
         den => den,
         clk => clk_48,
         clr => clr,
         sout => sout);
         
    clkPro : process
                 begin
                     clk_48 <= '0';
                     wait for clkPeriod/2;
                     clk_48 <= '1';
                     wait for clkPeriod/2;
             end process; 

    process
    begin
        --A wg B C
        clr <= '1';
        wait for clkPeriod*10;
        clr <= '0';
        wait for 0.8ms/100;
        din <= "01000001";
        den <= '1';
        wait for clkPeriod;
        din <= "00100000";
        wait for clkPeriod;
        din <= "01000010";
        wait for clkPeriod;
        din <= "01000011";
        wait for clkPeriod;
        din <= "00101110";
        wait for clkPeriod;
        din <= "00000000";
        den <= '0';  
        wait for 300*clkPeriod;
        din <= "01000110";
        den <= '1';
        wait for clkPeriod;
        din <= "00101110";
        wait for clkPeriod;
        din <= "00000000";
        den <= '0';     
    wait;
    end process;

    FINISH : process
    begin
        wait for clkPeriod*1000;
        std.env.finish;
    end process;
end Behavioral;
