library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rd_ascii is
  Port (din: in std_logic_vector(7 downto 0);
        den, clk, clr: in std_logic;
        next_letter: in std_logic;
        dout: out std_logic_vector(7 downto 0);
        dvalid: out std_logic
        );
end rd_ascii;

architecture Behavioral of rd_ascii is

type t_FIFO_DATA is array (0 to 63) of std_logic_vector(7 downto 0);
signal r_FIFO_DATA : t_FIFO_DATA := (others => (others => '0'));
signal wr_index   : integer range 0 to 63 := 0;
signal rd_index   : integer range 0 to 63 := 0;

type state_type is (st_idle, st_rd, st_clear);
signal state, next_state : state_type;
signal ns_idle, ns_clear, ns_rd: std_logic:='0';

signal ren, footstop: std_logic:= '0';
signal empty: std_logic:= '1';
signal items: integer range 0 to 64:=0;

begin
store_data: process(clk,den,clr)
    begin
        if clr = '1' then
            r_FIFO_DATA <= (others => (others => '0'));
            wr_index <= 0;
            rd_index <= 0;
            items <= 0;
            dout <= "00000000";
            dvalid <= '0';
        else
            if rising_edge(clk) then
                state <= next_state;
                if den = '1' then
                    r_FIFO_DATA(wr_index) <= din;
                    items <= items + 1;
                    if wr_index = 7 then
                        wr_index <= 0;
                    else
                        wr_index <= wr_index + 1;
                    end if;
                end if;
                if din = "00101110" then
                    footstop <= '1';
                else
                    footstop <= '0';
                end if;
                if (ren = '1' and empty = '0') or (next_letter = '1' and empty = '0') then
                    dvalid <= '1';
                    items <= items - 1;
                    dout <= r_FIFO_DATA(rd_index);
                    if rd_index = 7 then
                        rd_index <= 0;
                    else
                        rd_index <= rd_index + 1;
                    end if;
                else
                    dvalid <= '0';
                end if;
            end if;
        end if;
end process;
empty_or_not: process(items)
    begin
            if items = 0 then
                empty <= '1';
            else
                empty <= '0';
            end if;
end process;
output: process(clr, footstop, next_letter, state)
   begin
        case state is
            when st_idle =>
                if clr = '1' then
                    ns_clear <= '1';
                elsif footstop = '1' then
                    ns_rd <= '1';
                end if;
            when st_rd =>
                if clr = '1' then
                    ns_clear <= '1';
                else
                    ren <= '1';
                    ns_clear <= '1';
                end if;
            when st_clear =>
                ren <= '0';
                ns_clear <= '0';
                ns_rd <= '0';
                ns_idle <= '1';
        end case;
end process;
proc_ns: process (state, next_state, ns_clear, ns_idle, ns_rd)
   begin
      next_state <= state;  --default is to stay in current state
         case state is
            when st_idle =>
              if ns_rd = '1' then
                 next_state <= state_type(st_rd);
              end if;
            when st_clear =>
                if ns_idle = '1' then
                    next_state <= state_type(st_idle);
                end if;
            when st_rd =>
                if ns_clear = '1' then
                    next_state <= state_type(st_clear);
                end if;
         end case;
   end process;
end Behavioral;
