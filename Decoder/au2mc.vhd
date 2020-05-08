library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity au2mc is
Port ( 
 data_in    : in std_logic_vector(11 downto 0);
 out_data :     out std_logic; 
 clk, clr      : in std_logic -- 48k clock 
 );
end au2mc;

architecture Behavioral of au2mc is
signal data_int: integer range 0 to 5000 := 2048;
signal temp_int, abs_int, abs_avg: integer range -5000 to 5000 := 0;
signal abs_sum: integer := 0;
signal threshold: integer range 0 to 1000 := 1000;

type t_FIFO_DATA is array (0 to 127) of integer range 0 to 4000;
signal r_FIFO_DATA : t_FIFO_DATA := (others => 0);
signal r_WR_INDEX   : integer range 0 to 127 := 0;
signal lag_index : integer range 0 to 127 := 127;
signal count : integer range 0 to 128 := 128;

begin
proc_audio: process(clk, clr)
begin
    if clr = '1' then
        abs_sum <= 0;
        abs_avg <= 0;
    else
        if rising_edge(clk) then
            r_FIFO_DATA(r_WR_INDEX) <= abs_int;
            abs_sum <= abs_sum  + r_FIFO_DATA(lag_INDEX) -r_FIFO_DATA(r_WR_index);
            abs_avg <= abs_sum/count;
            if r_WR_INDEX = 127 then
                r_WR_INDEX <= 0;
            else
                r_WR_INDEX <= r_WR_INDEX + 1;
            end if;
            if lag_index = 127 then
                lag_index <= 0;
            else
                lag_index <= lag_index + 1;
            end if;
            if abs_avg> threshold then
                out_data <= '1';
            else 
                out_data <= '0';
            end if;
        end if;
    end if;
end process;
shift_down2048: process(data_in,clk)
begin
    if clr = '1' then
        data_int <= 2048;
        else
        data_int <= to_integer(unsigned(data_in));
        temp_int <= data_int - 2048;
        if temp_int <0 then
            abs_int <= -temp_int;
        else 
            abs_int <= temp_int;
        end if;
    end if;
end process;
end Behavioral;