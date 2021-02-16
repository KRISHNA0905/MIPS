library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Sign_Extender is
		port ( Sign_Extender_in: in STD_LOGIC_VECTOR(15 downto 0);
				 Sign_Extender_out: out STD_LOGIC_VECTOR(31 downto 0)
		);
end Sign_Extender;

architecture Behavioral of Sign_Extender is

begin

      Sign_Extender_out <= "0000000000000000" & Sign_Extender_in when Sign_Extender_in(15) ='0' else
					 "1111111111111111" & Sign_Extender_in;
end Behavioral;



