library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Table_Tennis is
	port(
		  A, B, clk, reset, switch:in std_logic;
		  HEX0, HEX1, HEX2, HEX3:out std_logic_vector(6 downto 0);
		  LED:out std_logic_vector(9 downto 0)
		  );
end Table_Tennis;

architecture Table_Tennis of Table_Tennis is

		component clk_2HZ is			-- 週期為0.5秒 --
			port(
				  clk:in std_logic;
				  clk2:out std_logic);
		end component;
		
		component clk_10HZ is		-- 週期為0.1秒 --
			port(
				  clk:in std_logic;
				  clk10:out std_logic);
		end component;

		component SEG7_Decoder is
			port(I:in std_logic_vector(3 downto 0);
				  SEG7:out std_logic_vector(6 downto 0));
		end component SEG7_Decoder;
		
		type State is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11,
							 S12, S13, S14, S15, S16, S17, S18, S19, S20, S21);
		signal Present_State : State;
		signal Next_State : State;
		signal ball_speed, clk2, clk10, scoreA, scoreB, casoutA, casoutB:std_logic;
		signal scorecnt0, scorecnt1, scorecnt2, scorecnt3:std_logic_vector(3 downto 0);
		
begin
		
U1: clk_2HZ port map(clk, clk2);
U2: clk_10HZ port map(clk, clk10);
U3: SEG7_Decoder port map(scorecnt0, HEX0);
U4: SEG7_Decoder port map(scorecnt1, HEX1);
U5: SEG7_Decoder port map(scorecnt2, HEX2);
U6: SEG7_Decoder port map(scorecnt3, HEX3);
		
		ball_speed <= clk2 when switch = '0' else
						  clk10;
				 
		process(ball_speed, reset)
			begin
				if reset = '0' then
					Present_State <= S0;
				elsif ball_speed'event and ball_speed = '1' then
					Present_state <= Next_state;
				end if;
		end process;
			
		process(scoreA, reset)
			begin
				if reset = '0' then
					scorecnt0 <= "0000";
				elsif scoreA'event and scoreA = '1' then
					if scorecnt0  = "1001" then
						scorecnt0 <= "0000";
					else
						scorecnt0 <= scorecnt0 + 1;
					end if;
				end if;
		end process;
		
		casoutA <= '1' when scorecnt0 = "1001" else
					  '0';
		
		process(scoreA, reset)
			begin
				if reset = '0' then
					scorecnt1 <= "0000";
				elsif scoreA'event and scoreA = '1' and casoutA = '1' then
					if scorecnt1  = "1001" then
						scorecnt1 <= "0000";
					else
						scorecnt1 <= scorecnt1 + 1;
					end if;
				end if;
		end process;
	
		process(scoreB, reset)
			begin
				if reset = '0' then
					scorecnt2 <= "0000";
				elsif scoreB'event and scoreB = '1' then
					if scorecnt2  = "1001" then
						scorecnt2 <= "0000";
					else
						scorecnt2 <= scorecnt2 + 1;
					end if;
				end if;
		end process;
		
		casoutB <= '1' when scorecnt2 = "1001" else
					  '0';
		
		process(scoreB, reset)
			begin
				if reset = '0' then
					scorecnt3 <= "0000";
				elsif scoreB'event and scoreB = '1' and casoutB = '1' then
					if scorecnt3  = "1001" then
						scorecnt3 <= "0000";
					else
						scorecnt3 <= scorecnt3 + 1;
					end if;
				end if;
		end process;
		
		process(Present_state, A, B)
			begin
				case Present_state is
					when S0 =>
							if A = '0' then			-- A = '0' 代表開始揮擊 --
								Next_state <= S1;
							else
						      Next_state <= S0;		-- A = '1' 代表揮擊失敗 --
							end if;
							LED <= "0000000000";
							scoreA <= '0';
					when S1 =>							-- Entering the Next_State unconditionally --
							Next_state <= S2;
							LED <= "0000000001";
					when S2 =>							-- Entering the Next_State unconditionally --
							Next_state <= S3;
							LED <= "0000000010";		
					when S3 =>							-- Entering the Next_State unconditionally --
							Next_state <= S4;
							LED <= "0000000100";
					when S4 =>							-- Entering the Next_State unconditionally --
							Next_state <= S5;
							LED <= "0000001000";
					when S5 =>							-- Entering the Next_State unconditionally --
							Next_state <= S6;
							LED <= "0000010000";
					when S6 =>							-- Entering the Next_State unconditionally --
							Next_state <= S7;
							LED <= "0000100000";		
					when S7 =>							-- Entering the Next_State unconditionally --
							Next_state <= S8;
							LED <= "0001000000";
					when S8 =>
					      if B = '0' then			-- B = '0' 代表提前揮擊(失敗) --
							   Next_state <= S0;
								scoreA <= '1';
							else
								Next_state <= S9;		-- B = '1' 代表無提前揮擊(進入S9) --
							end if;	
							LED <= "0010000000";
					when S9 =>
					      if B = '0' then			-- B = '0' 代表提前揮擊(失敗) --
							   Next_state <= S0;
								scoreA <= '1';
							else
								Next_state <= S10;	-- B = '1' 代表無提前揮擊(進入S10) --
							end if;	
							LED <= "0100000000";
							scoreA <= '0';
					when S10 =>
					      if B = '0' then			-- B = '0' 代表揮擊成功 --
							   Next_state <= S11;
								scoreA <= '0';
							else
								Next_state <= S0; 	-- B = '1' 代表揮擊失敗 --
								scoreA <= '1';
							end if;	
							LED <= "1000000000";
					when S11 =>							-- Entering the Next_State unconditionally --
							Next_state <= S12;
							LED <= "0100000000";
					when S12 =>							-- Entering the Next_State unconditionally --
							Next_state <= S13;
							LED <= "0010000000";
					when S13 =>							-- Entering the Next_State unconditionally --
							Next_state <= S14;
							LED <= "0001000000";
					when S14 =>							-- Entering the Next_State unconditionally --
							Next_state <= S15;
							LED <= "0000100000";		
					when S15 =>							-- Entering the Next_State unconditionally --
							Next_state <= S16;
							LED <= "0000010000";
					when S16 =>							-- Entering the Next_State unconditionally --
							Next_state <= S17;
							LED <= "0000001000";	
					when S17 =>
					      if A = '0' then			-- A = '0' 代表提前揮擊(失敗) --
							   Next_state <= S20;
								scoreB <= '1';
							else
								Next_state <= S18;	-- A = '1' 代表無提前揮擊(進入S18) --
							end if;	
							LED <= "0000000100";
					when S18 =>
					      if A = '0' then			-- A = '0' 代表提前揮擊(失敗) --
							   Next_state <= S20;
								scoreB <= '1';
							else
								Next_state <= S19;	-- A = '1' 代表無提前揮擊(進入S19) --
							end if;	
							LED <= "0000000010";
							scoreB <= '0';
					when S19 =>
					      if A = '0' then			-- A = '0' 代表揮擊成功 --
							   Next_state <= S2;
								scoreB <= '0';
							else
								Next_state <= S20; 	-- A = '1' 代表揮擊失敗 --
								scoreB <= '1';
							end if;	
							LED <= "0000000001";							
					when S20 =>
							if B = '0' then			-- B = '0' 代表開始揮擊 --
								Next_state <= S21;
							else
						      Next_state <= S20;	-- B = '1' 代表揮擊失敗 --
							end if;
							LED <= "0000000000";
							scoreB <= '0';
					when S21 =>							-- Entering the Next_State unconditionally --
							Next_state <= S11;
							LED <= "1000000000";
				end case;
		end process;

end Table_Tennis;	