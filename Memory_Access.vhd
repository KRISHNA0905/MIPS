library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Memory_Access is
port (
             clk: in std_logic;
             Read_En_DM :in std_logic;
             Wr_En_DM: in std_logic; 
             ALU_Result : in std_logic_vector(31 downto 0);
             Wr_data_DM: in std_logic_Vector(31 downto 0); 
             mux_4: in std_logic_vector(4 downto 0);
             
             Read_data_1: out std_logic_vector(31 downto 0);
             mux_another_4: out std_logic_vector(4 downto 0);
             ALU_Result_2: out std_logic_vector(31 downto 0)        
);
end Memory_Access;

architecture Behavioral5 of Memory_Access is
 

component DataMemory is
 Port (  clk: in std_logic;
             read_from_memory :in std_logic; -----read function
             write_in_memory :in std_logic; -----write function
             write_data: in std_logic_Vector(31 downto 0); ------32 bit data for Store
             ALU_RESULT_Address: in std_logic_Vector(31 downto 0); ----- 32 bit address
             read_data: out std_logic_Vector(31 downto 0)); -----for LOAD instruction
 end component;
 
component InterMediate_stage_4 is
port(
  clock: in std_logic;
  mem_read: in std_logic_vector(31 downto 0);
  ALU_result_int: in std_logic_vector(31 downto 0);
  Mux_4_out: in std_logic_vector(4 downto 0);
  mem_read_out: out std_logic_vector(31 downto 0);
  Write_data1 : out std_logic_vector(31 downto 0);
  Mux_4_memout: out std_logic_vector(4 downto 0)
  
);
 end component;
 
signal Read_data_DM: std_logic_vector(31 downto 0);
begin
 
c1: DataMemory port map (clk, Read_En_DM, Wr_En_DM, Wr_data_DM, ALU_Result,Read_data_1);
c2: InterMediate_stage_4 port map (clk, Read_data_DM, ALU_Result, mux_4, Read_data_DM, ALU_Result_2, mux_another_4 ); --mem_read_data is bogus variable. not used!!!


end Behavioral5;