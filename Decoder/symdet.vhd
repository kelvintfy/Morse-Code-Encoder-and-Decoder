library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.std_logic_unsigned.ALL;
--use IEEE.std_logic_arith.ALL;
--use IEEE.numeric_std.all;

entity symdet is
    Port (d_bin, clk, clr : in STD_LOGIC;
           dot, dash, lg, wg, valid: out STD_LOGIC
           );
end symdet;

architecture Behavioral of symdet is

type state_type is (st_clear, st_idle, st_found, st_foundsp, st_silence);
signal state, next_state : state_type;
signal ns_idle, ns_clear, ns_found, ns_foundsp, ns_silence: std_logic:='0';
signal found,exception: std_logic:='0';
signal counter_0: integer range 0 to 35000:=0;
signal epcounter_0: integer range 0 to 35000:=0;
signal counter_1: integer range 0 to 35000:=0;
signal epcounter_1: integer range 0 to 35000:=0;
signal unit_counter_0: integer range 0 to 35000:=0;
signal unit_counter_1: integer range 0 to 35000:=0;
signal unit: integer range 0 to 10000 := 2800;--2800clk:0.05s
signal currentdin: integer range 0 to 1:=1;
signal prevdin: integer range 0 to 1:=1;
signal silence: std_logic:= '0';
signal endd: std_logic:= '0';
signal active_flag: std_logic:= '0';

begin
 proc_state: process(clk)
    begin
    if rising_edge(clk) then
         state <= next_state;
    end if;
 end process;

 proc_incoming: process (clk, clr, d_bin, counter_0, state)
    begin
        if(clr = '1') then
            counter_0<=0;
            counter_1<=0;
            epcounter_0<=0;
            epcounter_1<=0;
            unit_counter_0<=0;
            unit_counter_1<=0;
        else   
            if (rising_edge(clk)) then
            if d_bin = '1' then
                active_flag <= '1';
            end if;
            if counter_0 = unit*10 then
                silence <= '1';
                active_flag <= '0';
                counter_0 <= 0;
                prevdin <= 1;
                currentdin <= 1;
            else silence <= '0';
            end if;
            if active_flag = '1' then
                case d_bin is
                when '0' =>
                    counter_0 <= counter_0 + 1;
                    epcounter_0 <= epcounter_0 + 1;
                    currentdin<=0;
                when '1' =>
                    counter_1 <= counter_1 + 1;
                    currentdin<=1;
                when others =>
                    null;
                end case;
                if not(prevdin = currentdin) then
                    if(prevdin = 0) then
                        unit_counter_0 <= counter_0;
                        counter_0<=0;
                        epcounter_0<=0;
                        found <= '1';
                    else
                        unit_counter_1 <= counter_1;
                        epcounter_1 <= counter_1;
                        counter_1<=0;
                    end if;
                else
                    found <= '0';
                    if (100*epcounter_0 > 259*epcounter_1 and 100*epcounter_0 < 260*epcounter_1 and epcounter_1>0 and unit_counter_1 < 4801) or (300*epcounter_0 > 259*epcounter_1 and 300*epcounter_0 < 260*epcounter_1 and epcounter_1>0 and unit_counter_1 > 7199) then
                        exception <= '1';
                        epcounter_0 <= 0;
                        epcounter_1 <= 0;
                    else exception <= '0';
                    end if;
                end if;        
                prevdin <= currentdin;
            end if;
            end if;
        end if;
    end process;

proc_estimate: process (clr, unit_counter_0, unit_counter_1, state, next_state, found, exception, silence, active_flag)
    begin
        case state is
         when st_clear =>      
            dot <= '0';
            dash <= '0';
            lg <= '0';
            wg <= '0';
            valid <= '0';
            ns_clear <= '0';
            ns_found <= '0';
            ns_foundsp <= '0';
            ns_silence <= '0';
            ns_idle <= '1';
        when st_idle =>
            if found = '1' then
                ns_found <= '1';
            end if;
            if exception = '1' then
                ns_foundsp <= '1';
            end if;
            if silence = '1' then
                ns_silence <= '1';
            end if;
            if clr = '1' then
                ns_clear <= '1';
            end if;
        when st_silence =>
            lg <= '1';
            valid <= '1';
            ns_clear <= '1';
        --output in the middle of 0s    
        when st_foundsp =>
                --dash and lg/wg output dash
                if unit_counter_1>7199 then
                    dash <= '1';
                    valid <= '1';
                    ns_clear <= '1';
                end if;
                --dot and lg/wg output dot
                if unit_counter_1<4801 then
                    dot <= '1';
                    valid <= '1';
                    ns_clear <= '1';
                end if;
        --output when rising edge of d_bin:
        when st_found =>
                --dot and lg
                if 100*unit_counter_0 > 90*3*unit_counter_1 and 100*unit_counter_0 < 110*3*unit_counter_1 then
                    unit <= unit_counter_1;
                    lg <= '1';
                    valid <= '1';
                    ns_clear <= '1';
                --dash only 
                elsif 100*unit_counter_1 > 90*3*unit_counter_0 and 100*unit_counter_1 < 110*3*unit_counter_0 then
                    unit <= unit_counter_0;
                    dash <= '1';
                    valid <= '1';
                    ns_clear <= '1';
                --dot and wg
                elsif 100*unit_counter_0 > 90*7*unit_counter_1 and 100*unit_counter_0 < 110*7*unit_counter_1 then
                    unit <= unit_counter_1;
                    wg <= '1';
                    valid <= '1';
                    ns_clear <= '1';
                --dash and wg
                elsif 100*3*unit_counter_0 > 90*7*unit_counter_1 and 100*3*unit_counter_0 < 110*7*unit_counter_1 then
                    unit <= unit_counter_1 / 3;
                    wg <= '1';
                    valid <= '1';
                    ns_clear <= '1';
                elsif 100*unit_counter_0 > 90*unit_counter_1 and 100*unit_counter_0 < 110*unit_counter_1 then
                    --dash and lg
                    if unit_counter_0 > 7199 then
                        unit <= unit_counter_0 / 3;
                        lg <= '1';
                        valid <= '1';
                        ns_clear <= '1';
                    --dot only
                    elsif unit_counter_0 < 4801 then
                        unit <= unit_counter_0;
                        dot <= '1';
                        valid <= '1';
                        ns_clear <= '1';
                    end if;
                 end if;
        end case;
    end process;
proc_ns: process (state, next_state, ns_clear, ns_found, ns_foundsp, ns_silence, ns_idle)
   begin
      next_state <= state;  --default is to stay in current state
      case state is
         when st_idle =>
              if ns_found = '1' then
                 next_state <= state_type(st_found);
              end if;
              if ns_foundsp = '1' then
                 next_state <= state_type(st_foundsp);
              end if;
              if ns_silence = '1' then
                 next_state <= state_type(st_silence);
              end if;
              if ns_clear = '1' then
                 next_state <= state_type(st_clear);
              end if;

         when st_clear =>
            if ns_idle = '1' then
               next_state <= state_type(st_idle);
            end if;

         when st_found =>
            if ns_clear = '1' then
               next_state <= state_type(st_clear);
            end if;

         when st_foundsp =>
            if ns_clear = '1' then
               next_state <= state_type(st_clear);
            end if;

         when st_silence =>
            if ns_clear = '1' then
               next_state <= state_type(st_clear);
            end if;
         
         end case;          
   end process;
end Behavioral;