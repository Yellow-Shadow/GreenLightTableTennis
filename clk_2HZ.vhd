library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_2HZ is		-- 週期為0.5秒 --
	port(
		  clk:in std_logic;
		  clk2:out std_logic);
end clk_2HZ;
	
architecture Frequency_Eliminator of clk_2HZ is
signal cnt:std_logic_vector(24 downto 0);
begin
		process(clk)
			begin
				if clk'event and clk = '1' then
					if cnt  = "1011111010111100000111111" then -- 25M-1 --
						cnt <= "0000000000000000000000000";
					else
						cnt <= cnt + 1;
					end if;
				end if;
		end process;
		
		clk2 <= cnt(24);
		
end Frequency_Eliminator;