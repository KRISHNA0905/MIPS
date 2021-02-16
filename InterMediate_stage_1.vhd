library ieee;
use ieee.std_logic_1164.all;
use work.all;

-------------------------------------

entity Intermediate_stage_1 is
	Generic (N : integer := 40);
     port(
        clock: in std_logic;
        input: in std_logic_vector(N-1 downto 0);
        output: out std_logic_vector(N-1 downto 0)
);
end Intermediate_stage_1;

architecture Behaviour1 of Intermediate_stage_1 is
begin
  --process(input, clock)
    process(clock) 
    begin
    if clock'event and clock='1' then
      output <= input;
    end if;
    end process;
    
end Behaviour1;
