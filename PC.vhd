library ieee;
use ieee.std_logic_1164.all;
use work.all;

-------------------------------------

entity ProgramCounter is
port(
  clock: in std_logic;
  clear: in std_logic;
  data_in: in std_logic_vector(7 downto 0);
  data_out: out std_logic_vector(7 downto 0)
);
end ProgramCounter;

-------------------------------------

architecture Behaviour1 of ProgramCounter is
begin
  process(data_in, clock)
    begin
    if clear='0' then
      data_out <= x"00";
    -- clock falling edge
    elsif rising_edge(clock) then
      data_out <= data_in;
    end if;
    end process;
    
end Behaviour1;