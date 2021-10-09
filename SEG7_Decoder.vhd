library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity SEG7_Decoder is
	port(I:in std_logic_vector(3 downto 0);
		  SEG7:out std_logic_vector(6 downto 0));
end SEG7_Decoder;

architecture SEG7_Decoder of SEG7_Decoder is
begin	  -- 1代表High(無電位差)為暗，0代表Low(有電位差)為亮 --
	SEG7 <= "1000000" when I = "0000" else			  -- 0 --
			  "1111001" when I = "0001" else			  -- 1 --
		     "0100100" when I = "0010" else			  -- 2 --
		     "0110000" when I = "0011" else			  -- 3 --
		     "0011001" when I = "0100" else		  	  -- 4 --
		     "0010010" when I = "0101" else			  -- 5 --
		     "0000010" when I = "0110" else			  -- 6 --
		     "1111000" when I = "0111" else			  -- 7 --
		     "0000000" when I = "1000" else			  -- 8 --
		     "0010000" when I = "1001" else			  -- 9 --
		     "1111111";
end SEG7_Decoder;