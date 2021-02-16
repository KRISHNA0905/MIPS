  library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;
  
  -------------------------------------
  
  entity Adder_IF is
  generic(n: natural:=8);
  port(
      a: in std_logic_vector (n-1 downto 0);
      b: in std_logic_vector (n-1 downto 0):= x"04";
      carry: out std_logic;
      sum: out std_logic_vector (n-1 downto 0)
      );
  end Adder_IF;
  
  -------------------------------------
  
  architecture Behaviour1 of Adder_IF is
    signal result: std_logic_vector(n downto 0);
  
  begin
    result<=('0' & a)+('0' & b);
      carry<=result(n);
      sum<=result(n-1 downto 0);
  end Behaviour1;
