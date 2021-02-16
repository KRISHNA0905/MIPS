library ieee;
use ieee.std_logic_1164.all;

entity Write_Back is
port (
             ALU_Result: in std_logic_Vector(31 downto 0);      -- 32 bit ALU result
             Read_data_mem: in std_logic_Vector(31 downto 0);   -- Loadig from memory and writing into register block
             Select_1: in std_logic; 				--select line
             mux_Wr_in: in std_logic_vector(4 downto 0);        
             
             WR_Reg: out std_logic_vector(31 downto 0);
             Wr_mux_out: out std_logic_vector(4 downto 0)
);
end Write_Back;

architecture Behavioural of Write_Back is
begin 
  process(ALU_Result,Read_data_mem,Select_1,mux_Wr_in)
    begin
      if Select_1= '0' THEN
      Wr_Reg <= ALU_Result;
    ELSE
      Wr_Reg <= Read_data_mem;
    end if;
   Wr_mux_out <= mux_Wr_in;
  end process;
end behavioural;
