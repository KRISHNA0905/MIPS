library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity Intermediate_stage_4 is
port(
  clock: in std_logic;
  mem_read: in std_logic_vector(31 downto 0);
  ALU_result_int: in std_logic_vector(31 downto 0);
  Mux_4_out: in std_logic_vector(4 downto 0);
  mem_read_out: out std_logic_vector(31 downto 0);
  Write_data1 : out std_logic_vector(31 downto 0);
  Mux_4_memout: out std_logic_vector(4 downto 0));
end Intermediate_stage_4;

architecture Behaviour1 of Intermediate_stage_4 is
begin
  process(clock)
    begin
    								--- rising edge 
    if clock'event and clock='1' then
      Write_data1<=  ALU_result_int;    
      Mux_4_memout<= Mux_4_out;
      mem_read_out<=mem_read;
      
    end if;
    end process;
    
end Behaviour1;
