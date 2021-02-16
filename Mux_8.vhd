library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_8 is
	Generic (N : integer := 8);
    Port ( mux_in0 : in  STD_LOGIC_VECTOR(N-1 downto 0);
           mux_in1 : in  STD_LOGIC_VECTOR(N-1 downto 0);
           selection_line : in  STD_LOGIC;
           mux_out : out  STD_LOGIC_VECTOR(N-1 downto 0));
end Mux_8;

architecture Behavioral of Mux_8 is

begin

		mux_out <= mux_in0 when selection_line = '0' else
						mux_in1;

end Behavioral;


