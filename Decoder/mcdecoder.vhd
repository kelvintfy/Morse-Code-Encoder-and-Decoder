library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mcdecoder is
    Port ( dot : in STD_LOGIC;
           dash : in STD_LOGIC;
           lg : in STD_LOGIC;
           wg : in STD_LOGIC;
           valid : in STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (7 downto 0);
           dvalid : out STD_LOGIC := '0';
           error : out STD_LOGIC := '0';
           clr : in STD_LOGIC;
           clk : in STD_LOGIC);
end mcdecoder;

architecture Behavioral of mcdecoder is

   --Use descriptive names for the states, like st1_reset, st2_search
   type state_type is (st2, st1_reset, st2t, st3, st3t, st4, st4t, st5, st5t, st6, st6t, st7, st_wg);
   signal state, next_state : state_type;

   --Declare other internal signals here
   signal nsx_1 : std_logic := '0';
   signal ns1_2 : std_logic := '0';
   signal ns2_2t: std_logic := '0';
   signal ns2t_3: std_logic := '0';
   signal ns3_3t: std_logic := '0';
   signal ns3t_4: std_logic := '0';
   signal ns4_4t: std_logic := '0';
   signal ns4t_5: std_logic := '0';
   signal ns5_5t: std_logic := '0';
   signal ns5t_6: std_logic := '0';
   signal ns6_6t: std_logic := '0';
   signal ns6t_7: std_logic := '0';
   signal nswg: std_logic := '0';
   signal dash1: std_logic := '0';
   signal dash2: std_logic := '0';
   signal dash3: std_logic := '0';
   signal dash4: std_logic := '0';
   signal dash5: std_logic := '0';
   signal dot1: std_logic := '0';
   signal dot2: std_logic := '0';
   signal dot3: std_logic := '0';
   signal dot4: std_logic := '0';
   signal dot5: std_logic := '0';

begin

   --A clock process for state register
   proc_statereg: process (clk, clr)
   begin
      if (clr = '1') then
         -- jump to reset state here
         state <= state_type(st1_reset);
      end if;
      if (clk'event and clk = '1') then
         state <= next_state;
      end if;
   end process;

   --MEALY State-Machine - Outputs based on state and inputs
   proc_output: process (state, next_state, dash, dot, valid, lg, wg)
   begin
      case state is
      --state1
      when st1_reset =>
         ns1_2 <= '1';
         dash1 <= '0';
         dash2 <= '0';
         dash3 <= '0';
         dash4 <= '0';
         dash5 <= '0';
         dot1 <= '0';
         dot2 <= '0';
         dot3 <= '0';
         dot4 <= '0';
         dot5 <= '0';
         nsx_1 <= '0';
         ns2_2t <= '0';
         ns2t_3 <= '0';
         ns3_3t <= '0';
         ns3t_4 <= '0';
         ns4_4t <= '0';
         ns4t_5 <= '0';
         ns5_5t <= '0';
         ns5t_6 <= '0';
         ns6_6t <= '0';
         ns6t_7 <= '0';
         nswg <= '0';
         dvalid <= '0';
         error <= '0';
      --state2
      when st2 =>
      if dash = '1' and valid = '1' then
         dash1 <= '1';
         ns2_2t <= '1';
      end if;
      if dot = '1' and valid = '1' then
         dot1 <= '1';
         ns2_2t <= '1';
      end if;
      if wg = '1' and valid = '1' then
         dout <= "00100000";
         dvalid <= '1';
         nsx_1 <= '1';
      end if;
      --state2t
      when st2t =>
         ns2t_3 <= '1';

      --state3
      when st3 =>
      if dash = '1' and valid = '1' then
         dash2 <= '1';
         ns3_3t <= '1';
      end if;
      if dot = '1' and valid = '1' then
         dot2 <= '1';
         ns3_3t <= '1';
      end if;
      if (lg = '1' or wg = '1') and valid ='1' then
         if (wg = '1') then
         nswg <= '1';
         dvalid <= '1';
         end if;
         if lg = '1' then
         nsx_1 <= '1';
         dvalid <= '1';
         end if;
         --T:
         if (dot1 = '0' and dot2 = '0' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '1' and dash2 = '0' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01010100";
         --E:
         elsif (dot1 = '1' and dot2 = '0' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '0' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01000101";
         else
         error <= '1';
         end if;
      end if;
      --state3t
      when st3t =>
         ns3t_4 <= '1';
      
      --state4
      when st4 =>
      if dash = '1' and valid = '1' then
         dash3 <= '1';
         ns4_4t <= '1';
      end if;
      if dot = '1' and valid = '1' then
         dot3 <= '1';
         ns4_4t <= '1';
      end if;
      if (lg = '1' or wg = '1') and valid ='1' then
         if (wg = '1') then
         nswg <= '1';
         dvalid <= '1';
         end if;
         if lg = '1' then
         nsx_1 <= '1';
         dvalid <= '1';
         end if;
         --A:
         if (dot1 = '1' and dot2 = '0' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '1' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01000001";         
         --M:
         elsif (dot1 = '0' and dot2 = '0' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '1' and dash2 = '1' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01001101";        
         --I:
         elsif (dot1 = '1' and dot2 = '1' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '0' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01001001";        
         --N:
         elsif (dot1 = '0' and dot2 = '1' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '1' and dash2 = '0' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01001110";       
         else
         error <= '1';
         end if;
      end if;
      --state4t
      when st4t =>
         ns4t_5 <= '1';

      --state5
      when st5 =>
      if dash = '1' and valid = '1' then
         dash4 <= '1';
         ns5_5t <= '1';
      end if;
      if dot = '1' and valid = '1' then
         dot4 <= '1';
         ns5_5t <= '1';
      end if;
       if (lg = '1' or wg = '1') and valid ='1' then
         if (wg = '1') then
         nswg <= '1';
         dvalid <= '1';
         end if;
         if lg = '1' then
         dvalid <= '1';
         nsx_1 <= '1'; 
         end if;
         --D:
         if (dot1 = '0' and dot2 = '1' and dot3 = '1' and dot4 = '0' and dot5 = '0' and dash1 = '1' and dash2 = '0' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01000100";        
         --G:
         elsif (dot1 = '0' and dot2 = '0' and dot3 = '1' and dot4 = '0' and dot5 = '0' and dash1 = '1' and dash2 = '1' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01000111";        
         --K:
         elsif (dot1 = '0' and dot2 = '1' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '1' and dash2 = '0' and dash3 = '1' and dash4 = '0' and dash5 = '0') then
         dout <= "01001011";        
         --O:
         elsif (dot1 = '0' and dot2 = '0' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '1' and dash2 = '1' and dash3 = '1' and dash4 = '0' and dash5 = '0') then
         dout <= "01001111";         
         --R:
         elsif (dot1 = '1' and dot2 = '0' and dot3 = '1' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '1' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01010010";         
         --S:
         elsif (dot1 = '1' and dot2 = '1' and dot3 = '1' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '0' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01010011";         
         --U:
         elsif (dot1 = '1' and dot2 = '1' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '0' and dash3 = '1' and dash4 = '0' and dash5 = '0') then
         dout <= "01010101";        
         --W:
         elsif (dot1 = '1' and dot2 = '0' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '1' and dash3 = '1' and dash4 = '0' and dash5 = '0') then
         dout <= "01010111";        
         else
         error <= '1';
         end if;
      end if;
      --state5t
      when st5t =>
         ns5t_6 <= '1';

      --state6
      when st6 =>
      if dash = '1' and valid = '1' then
         dash5 <= '1';
         ns6_6t <= '1';
      end if;
      if dot = '1' and valid = '1' then
         dot5 <= '1';
         ns6_6t <= '1';
      end if;
      if (lg = '1' or wg = '1') and valid ='1' then
         if (wg = '1') then
         nswg <= '1';
         dvalid <= '1';
         end if;
         if lg = '1' then
         dvalid <= '1';
         nsx_1 <= '1';
         end if;
         --B:
         if (dot1 = '0' and dot2 = '1' and dot3 = '1' and dot4 = '1' and dot5 = '0' and dash1 = '1' and dash2 = '0' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01000010";         
         --C:
         elsif (dot1 = '0' and dot2 = '1' and dot3 = '0' and dot4 = '1' and dot5 = '0' and dash1 = '1' and dash2 = '0' and dash3 = '1' and dash4 = '0' and dash5 = '0') then
         dout <= "01000101";
         --F:
         elsif (dot1 = '1' and dot2 = '1' and dot3 = '0' and dot4 = '1' and dot5 = '0' and dash1 = '0' and dash2 = '0' and dash3 = '1' and dash4 = '0' and dash5 = '0') then
         dout <= "01000110";        
         --H:
         elsif (dot1 = '1' and dot2 = '1' and dot3 = '1' and dot4 = '1' and dot5 = '0' and dash1 = '0' and dash2 = '0' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01001000";       
         --J:
         elsif (dot1 = '1' and dot2 = '0' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '1' and dash3 = '1' and dash4 = '1' and dash5 = '0') then
         dout <= "01001010";        
         --L:
         elsif (dot1 = '1' and dot2 = '0' and dot3 = '1' and dot4 = '1' and dot5 = '0' and dash1 = '0' and dash2 = '1' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01001100";        
         --P:
         elsif (dot1 = '1' and dot2 = '0' and dot3 = '0' and dot4 = '1' and dot5 = '0' and dash1 = '0' and dash2 = '1' and dash3 = '1' and dash4 = '0' and dash5 = '0') then
         dout <= "01010000";        
         --Q:
         elsif (dot1 = '0' and dot2 = '0' and dot3 = '1' and dot4 = '0' and dot5 = '0' and dash1 = '1' and dash2 = '1' and dash3 = '0' and dash4 = '1' and dash5 = '0') then
         dout <= "01010001";      
         --V:
         elsif (dot1 = '1' and dot2 = '1' and dot3 = '1' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '0' and dash3 = '0' and dash4 = '1' and dash5 = '0') then
         dout <= "01010110";      
         --X:
         elsif (dot1 = '0' and dot2 = '1' and dot3 = '1' and dot4 = '0' and dot5 = '0' and dash1 = '1' and dash2 = '0' and dash3 = '0' and dash4 = '1' and dash5 = '0') then
         dout <= "01011000";       
         --Y:
         elsif (dot1 = '0' and dot2 = '1' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '1' and dash2 = '0' and dash3 = '1' and dash4 = '1' and dash5 = '0') then
         dout <= "01011001";      
         --Z:
         elsif (dot1 = '0' and dot2 = '0' and dot3 = '1' and dot4 = '1' and dot5 = '0' and dash1 = '1' and dash2 = '1' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01011010";       
         else
         error <= '1';
         end if;
      end if;
      --state6t
      when st6t =>
         ns6t_7 <= '1';

      --state7\
      when st7 =>
      if (dot = '1' or dash = '1') then
         error <= '1';
         nsx_1 <= '1';
      end if;
      if (lg = '1' or wg = '1') and valid ='1' then
         if (wg = '1') then
         nswg <= '1';
         dvalid <= '1';  
         end if;    
         if lg = '1' then
         dvalid <= '1';
         nsx_1 <= '1';
         end if;
         --1:
         if (dot1 = '1' and dot2 = '0' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '1' and dash3 = '1' and dash4 = '1' and dash5 = '1') then
         dout <= "00110001";       
         --2:
         elsif (dot1 = '1' and dot2 = '1' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '0' and dash3 = '1' and dash4 = '1' and dash5 = '1') then
         dout <= "00110010";      
         --3:
         elsif (dot1 = '1' and dot2 = '1' and dot3 = '1' and dot4 = '0' and dot5 = '0' and dash1 = '0' and dash2 = '0' and dash3 = '0' and dash4 = '1' and dash5 = '1') then
         dout <= "00110011";    
         --4:
         elsif (dot1 = '1' and dot2 = '1' and dot3 = '1' and dot4 = '1' and dot5 = '0' and dash1 = '0' and dash2 = '0' and dash3 = '0' and dash4 = '0' and dash5 = '1') then
         dout <= "01001000";      
         --5:
         elsif (dot1 = '1' and dot2 = '1' and dot3 = '1' and dot4 = '1' and dot5 = '1' and dash1 = '0' and dash2 = '0' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "00110101";      
         --6:
         elsif (dot1 = '0' and dot2 = '1' and dot3 = '1' and dot4 = '1' and dot5 = '1' and dash1 = '1' and dash2 = '0' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "00110110";     
         --7:
         elsif (dot1 = '0' and dot2 = '0' and dot3 = '1' and dot4 = '1' and dot5 = '1' and dash1 = '1' and dash2 = '1' and dash3 = '0' and dash4 = '0' and dash5 = '0') then
         dout <= "01010000";     
         --8:
         elsif (dot1 = '0' and dot2 = '0' and dot3 = '0' and dot4 = '1' and dot5 = '1' and dash1 = '1' and dash2 = '1' and dash3 = '1' and dash4 = '0' and dash5 = '0') then
         dout <= "01010001";     
         --9:
         elsif (dot1 = '0' and dot2 = '0' and dot3 = '0' and dot4 = '0' and dot5 = '1' and dash1 = '1' and dash2 = '1' and dash3 = '1' and dash4 = '1' and dash5 = '0') then
         dout <= "00111001";       
         --0:
         elsif (dot1 = '0' and dot2 = '0' and dot3 = '0' and dot4 = '0' and dot5 = '0' and dash1 = '1' and dash2 = '1' and dash3 = '1' and dash4 = '1' and dash5 = '1') then
         dout <= "00110000";       
         else
         error <= '1';
         end if;
      end if;
      --state word gap
      when st_wg =>
         dout <= "00100000";
         nsx_1 <= '1';

      end case;
   end process;
   -- Next State Logic.  This corresponds to your next state logic table
   proc_ns: process (state, next_state, nsx_1, ns1_2, ns2_2t, ns2t_3, ns3_3t, ns3t_4, ns4_4t, ns4t_5, ns5_5t, ns5t_6, ns6_6t, ns6t_7, nswg)
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
         case state is
         when st1_reset =>
            if ns1_2 = '1' then
               next_state <= state_type(st2);
            end if;

         when st2 =>
            if ns2_2t = '1' then
               next_state <= state_type(st2t);

            elsif nsx_1 = '1' then
               next_state <= state_type(st1_reset);

            elsif nswg = '1' then
               next_state <= state_type(st_wg);
            end if;

         when st2t =>
            if ns2t_3 = '1' then
               next_state <= state_type(st3);
            end if;

         when st3 =>
            if ns3_3t = '1' then
               next_state <= state_type(st3t);

            elsif nsx_1 = '1' then
               next_state <= state_type(st1_reset);

            elsif nswg = '1' then
               next_state <= state_type(st_wg);
            end if;

         when st3t =>
            if ns3t_4 = '1' then
               next_state <= state_type(st4);
            end if;

         when st4 =>
            if ns4_4t = '1' then
               next_state <= state_type(st4t);

            elsif nsx_1 = '1' then
               next_state <= state_type(st1_reset);

            elsif nswg = '1' then
               next_state <= state_type(st_wg);
            end if;

         when st4t =>
            if ns4t_5 = '1' then
               next_state <= state_type(st5);
            end if;

         when st5 =>
            if ns5_5t = '1' then
               next_state <= state_type(st5t);

            elsif nsx_1 = '1' then
               next_state <= state_type(st1_reset);

            elsif nswg = '1' then
               next_state <= state_type(st_wg);
            end if;

         when st5t =>
            if ns5t_6 = '1' then
               next_state <= state_type(st6);
            end if;

         when st6 =>
            if ns6_6t = '1' then
               next_state <= state_type(st6t);

            elsif nsx_1 = '1' then
               next_state <= state_type(st1_reset);

            elsif nswg = '1' then
               next_state <= state_type(st_wg);
            end if;

         when st6t =>
            if ns6t_7 = '1' then
               next_state <= state_type(st7);
            end if;

         when st7 =>
            if nsx_1 = '1' then
               next_state <= state_type(st1_reset);

            elsif nswg = '1' then
               next_state <= state_type(st_wg);
            end if;

         when st_wg =>
            if nsx_1 = '1' then
                next_state <= state_type(st1_reset);
            end if;

         end case;
   end process;
end Behavioral;