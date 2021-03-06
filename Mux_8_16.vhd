library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_8_16 is	
    Port ( mux_in0 : in  STD_LOGIC_VECTOR(7 downto 0);
           mux_in1 : in  STD_LOGIC_VECTOR(15 downto 0);
           selection_line : in  STD_LOGIC;
           mux_out : out  STD_LOGIC_VECTOR(7 downto 0));
end Mux_8_16;

architecture Behavioral13 of Mux_8_16 is

begin
	   mux_out <= mux_in0 when selection_line = '0' else
						mux_in1(7 downto 0);

end Behavioral13;

