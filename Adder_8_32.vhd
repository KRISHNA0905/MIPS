library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity adder_8_32 is
port(
    in1: in std_logic_vector (7 downto 0);
    in2: in std_logic_vector (31 downto 0);
    sum: out std_logic_vector (7 downto 0);
    carry: out std_logic
    );
end adder_8_32;

architecture Behavioural of adder_8_32 is
  
signal result: std_logic_vector(8 downto 0);

begin

  result <= ('0' & in1) + ('0' & in2(7 downto 0));
  carry <= result(8);
  sum<=result(7 downto 0);

end Behavioural;
