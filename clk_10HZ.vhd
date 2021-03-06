library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_10HZ is		-- 週期為0.1秒 --
	port(
		  clk:in std_logic;
		  clk10:out std_logic);
end clk_10HZ;
	
architecture Frequency_Eliminator of clk_10HZ is
signal cnt:std_logic_vector(22 downto 0);
begin
		process(clk)
			begin
				if clk'event and clk = '1' then
					if cnt  = "10011000100101100111111" then -- 5M-1 --
						cnt <= "00000000000000000000000";
					else
						cnt <= cnt + 1;
					end if;
				end if;
		end process;
		
		clk10 <= cnt(22);
		
end Frequency_Eliminator;