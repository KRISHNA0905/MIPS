library IEEE;
use ieee.std_logic_1164.all;
---use ieee.std_logic_unsigned.all;
---use ieee.std_logic_arith.all;

entity left_shift_by_2 is
    port (
    data_in : in std_logic_vector(31 downto 0);
    shifted_data_out : out std_logic_vector(31 downto 0)
    );
    end left_shift_by_2;

Architecture behavioral of left_shift_by_2 is

begin
    shifted_data_out <= data_in(29 downto 0) & "00";  
    
end behavioral;
