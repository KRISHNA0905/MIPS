library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;
    
  entity Adder_8 is
  generic(n: natural:=8);
  port(
      p,q: in std_logic_vector (n-1 downto 0);
      carry: out std_logic;
      sum: out std_logic_vector (n-1 downto 0)
      );
  end Adder_8;
  
  architecture Behaviour1 of Adder_8 is
    signal result: std_logic_vector(n downto 0);
  
  begin
    result<=('0' & p)+('0' & q);
      carry<=result(n);
      sum<=result(n-1 downto 0);
  end Behaviour1;

