library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity symbol_output is
  Port (din: in std_logic_vector(7 downto 0);
        wen: in std_logic;
        clk, clr: in std_logic;
        sout: out std_logic:= '0';
        endd: out std_logic:= '0'
        );
end symbol_output;

architecture Behavioral of symbol_output is

type state_type is (st_clear, st_output_A, st_output_B, st_output_C, st_output_D, st_output_E, st_output_F, st_output_wg, st_output_fs);
signal state, next_state : state_type;
signal ns_clear: std_logic:='0';
signal counter: integer range 0 to 100000:=0;

begin
state_changing: process(clk, clr)
    begin
        if clr = '1' then
            state <= state_type(st_clear);
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
end process;
output: process(clk, state, clr)
    begin
        case state is        
            when st_output_A =>
                if rising_edge(clk) then
                    counter <= counter + 1;
                    case counter is
                        when 0 => sout <= '1';
                        when 1 => sout <= '0';
                        when 2 => sout <= '1';
                        when 5 => sout <= '0'; ns_clear <= '1'; endd <= '1';
                        when others => NULL;                  
                    end case;
                end if;
            when st_output_B =>
                if rising_edge(clk) then
                    counter <= counter + 1;
                    case counter is
                        when 0 => sout <= '1';
                        when 3 => sout <= '0';
                        when 4 => sout <= '1';
                        when 5 => sout <= '0';
                        when 6 => sout <= '1';
                        when 7 => sout <= '0';
                        when 8 => sout <= '1';
                        when 9 => sout <= '0'; ns_clear <= '1'; endd <= '1';
                        when others => NULL;                  
                    end case;
                end if;
            when st_output_C =>
                if rising_edge(clk) then
                    counter <= counter + 1;
                    case counter is
                        when 0 => sout <= '1';
                        when 3 => sout <= '0';
                        when 4 => sout <= '1';
                        when 5 => sout <= '0';
                        when 6 => sout <= '1';
                        when 9 => sout <= '0';
                        when 10 => sout <= '1';
                        when 11 => sout <= '0'; ns_clear <= '1'; endd <= '1';
                        when others => NULL;                  
                    end case;
                end if;
            when st_output_D =>
                if rising_edge(clk) then
                    counter <= counter + 1;
                    case counter is
                        when 0 => sout <= '1';
                        when 3 => sout <= '0';
                        when 4 => sout <= '1';
                        when 5 => sout <= '0';
                        when 6 => sout <= '1';
                        when 7 => sout <= '0'; ns_clear <= '1'; endd <= '1';
                        when others => NULL;                  
                    end case;
                end if;
            when st_output_E =>
                if rising_edge(clk) then
                    counter <= counter + 1;
                    case counter is
                        when 0 => sout <= '1';
                        when 1 => sout <= '0'; ns_clear <= '1'; endd <= '1';
                        when others => NULL;                  
                    end case;
                end if;
            when st_output_F =>
                if rising_edge(clk) then
                    counter <= counter + 1;
                    case counter is
                        when 0 => sout <= '1';
                        when 1 => sout <= '0';
                        when 2 => sout <= '1';
                        when 3 => sout <= '0';
                        when 4 => sout <= '1';
                        when 7 => sout <= '0';
                        when 8 => sout <= '1';
                        when 9 => sout <= '0'; ns_clear <= '1'; endd <= '1';
                        when others => NULL;                  
                    end case;
                end if;
            when st_output_wg =>
                if rising_edge(clk) then
                    counter <= counter + 1;
                    case counter is
                        when 0 => sout <= '0';
                        when 1 => ns_clear <= '1'; endd <= '1';
                        when others => NULL;                  
                    end case;
                end if;
            when st_output_fs =>
                if rising_edge(clk) then
                    counter <= counter + 1;
                    case counter is
                        when 0 => sout <= '1';
                        when 1 => sout <= '0';
                        when 2 => sout <= '1';
                        when 5 => sout <= '0';
                        when 6 => sout <= '1';
                        when 7 => sout <= '0';
                        when 8 => sout <= '1';
                        when 11 => sout <= '0'; ns_clear <= '1';
                        when others => NULL;                  
                    end case;
                end if;
            when st_clear =>
                counter <= 0;
                endd <= '0';
                ns_clear <= '0'; 
            when others => NULL;
        end case;
end process;

proc_ns: process(wen, din, state, next_state, ns_clear)
   begin
      next_state <= state;  --default is to stay in current state
         case state is
            when st_clear =>
                if wen = '1' then
                    case din is
                        when "01000001" => next_state <= state_type(st_output_A);
                        when "01000010" => next_state <= state_type(st_output_B);
                        when "01000011" => next_state <= state_type(st_output_C);
                        when "01000100" => next_state <= state_type(st_output_D);
                        when "01000101" => next_state <= state_type(st_output_E);
                        when "01000110" => next_state <= state_type(st_output_F);
                        when "00100000" => next_state <= state_type(st_output_wg);
                        when "00101110" => next_state <= state_type(st_output_fs);
                        when others => NULL;
                    end case;
                end if;  
            when st_output_A =>
                if ns_clear = '1' then
                    next_state <= state_type(st_clear);
                end if;
            when st_output_B =>
                if ns_clear = '1' then
                    next_state <= state_type(st_clear);
                end if;
            when st_output_C =>
                if ns_clear = '1' then
                    next_state <= state_type(st_clear);
                end if;
            when st_output_D =>
                if ns_clear = '1' then
                    next_state <= state_type(st_clear);
                end if;
            when st_output_E =>
                if ns_clear = '1' then
                    next_state <= state_type(st_clear);
                end if;  
            when st_output_F =>
                if ns_clear = '1' then
                    next_state <= state_type(st_clear);
                end if;
            when st_output_wg =>
                if ns_clear = '1' then
                    next_state <= state_type(st_clear);
                end if;
            when st_output_fs =>
                if ns_clear = '1' then
                    next_state <= state_type(st_clear);
                end if;
            when others => NULL;         
         end case;
   end process;
end Behavioral;
