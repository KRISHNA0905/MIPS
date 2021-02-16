library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity adder32 is
  port (
    a     : in std_logic_vector(31 downto 0);
    b     : in std_logic_vector(31 downto 0);
    sum   : out std_logic_vector(31 downto 0);
    carry : out std_logic
  );
end entity adder32;

architecture behavioural of adder32 is

signal temp : std_logic_vector(32 downto 0);

begin
 process(a,b)
 begin
  temp <= ('0' & a) + ('0' & b); ---concatenation operation
 end process;
 sum  <= temp(31 downto 0);
 carry   <= temp(32);
end behavioural;


