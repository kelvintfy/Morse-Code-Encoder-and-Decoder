library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mcencoder is
  Port (din: in std_logic_vector(7 downto 0);
        den: in std_logic;
        clk: in std_logic;
        clr: in std_logic;
        sout: out std_logic);
end mcencoder;

architecture Behavioral of mcencoder is
    component rd_ascii
        port(din: in std_logic_vector(7 downto 0);
             den, clk, clr: in std_logic;
             next_letter: in std_logic;
             dout: out std_logic_vector(7 downto 0);
             dvalid: out std_logic
             );
    end component;
    component symbol_output
        port(din: in std_logic_vector(7 downto 0);
             wen, clk, clr: in std_logic;
             sout: out std_logic;
             endd: out std_logic
             );
    end component;
    
    --transfer signal
    signal dout: std_logic_vector(7 downto 0);
    signal dvalid, next_letter: std_logic:= '0';
begin
    FIFO: rd_ascii port map
        (din => din,
         den => den,
         clk => clk,
         clr => clr,
         next_letter => next_letter,
         dout => dout,
         dvalid => dvalid);
    output: symbol_output port map
        (din => dout,
         wen => dvalid,
         clk => clk,
         clr => clr,
         sout => sout,
         endd => next_letter);

end Behavioral;