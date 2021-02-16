library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


-------------------------------------

entity InterMediate_stage_2 is
port(
  clock: in std_logic;
  pc_in: in std_logic_vector(7 downto 0);
  Rt_data1_in: in std_logic_vector(31 downto 0);
  Rd_data2_in: in std_logic_vector(31 downto 0);
  extended_data_in : in std_logic_vector(31 downto 0);
  Rt_in : in std_logic_vector(4 downto 0);
  Rd_in : in std_logic_vector(4 downto 0);
  
  pc_out: out std_logic_vector(7 downto 0);
  Rt_data1_out: out std_logic_vector(31 downto 0);
  Rd_data2_out: out std_logic_vector(31 downto 0);
  extended_data_out : out std_logic_vector(31 downto 0);
  Rt_out : out std_logic_vector(4 downto 0);
  Rd_out : out std_logic_vector(4 downto 0)
);
end InterMediate_stage_2;

architecture Behaviour2 of InterMediate_stage_2 is
begin
    process(clock)
    begin
                                                              -- clock rising edge
    if clock'event and clock='1' then
      pc_out <= pc_in;
      extended_data_out <= extended_data_in;
      Rt_out <= Rt_in;
      Rt_data1_out<=Rt_data1_in;
      Rd_out <= Rd_in;
      Rd_data2_out<=Rd_data2_in;
    end if;
    end process;
    
end Behaviour2;

