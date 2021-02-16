library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

entity Register_file is
  port(
    clk : in std_logic;
    Wr_Enable: in std_logic;
    Wr_address : in std_logic_vector(4 downto 0);
    Wr_data: in std_logic_vector(31 downto 0);
    Read_reg_add_0 : in std_logic_vector(4 downto 0);
    Read_reg_add_1 : in std_logic_vector(4 downto 0);
    Reg_data0 : out std_logic_vector(31 downto 0);
    Reg_data1 : out std_logic_vector(31 downto 0));
end Register_file;

architecture Behavioral of Register_file is

  type reg_file_type is array (0 to 31) of std_logic_vector(31 downto 0);
	signal array_reg : reg_file_type := ( x"00000000",   --$rz ----add:00000 
														  x"11111111",   --$t0 ---addr:00001
														  x"24242424",   --$t1 ---addr:00010
														  x"42424242",   --$t2 ---addr:00011
														  x"24242424",   --$t3 ---addr:00100
														  x"22222222",   --$t4
														  x"33333333",   --$t5
														  x"55555555",   --$t6
														  x"FFFFFFFF",   --$t7
														  x"00000000",   --$t8
														  x"88888888",   --$t9
														  x"0000000a",   --$t10
														  x"44444444",   --$t11
														  x"45678686",   --$t12
														  x"aaaaaaaa",   --$t13
														  x"ffffffff",   --$t14
														  x"11110000",   --$t15
														  x"00001111",   --$t16
														  x"55555555",   --$t17
														  x"55555555",   --$t18
														  x"44444444",   --$t19
														  x"00000005",   --$t20
														  x"11111111",   --$t21
														  x"77777777",   --$t22
														  x"11111111",   --$t23
														  x"99999999",   --$t24
														  x"aaaaaaaa",   --$t25
														  x"bbbbbbbb",   --$t26
														  x"99999999",   --$t27
														  x"7FFFF1EC",   --$t28
														  x"e12f342a",   --$t29
														  x"ffffffff"    --$t30
														  );
  
begin
  process(clk, Read_reg_add_0, Read_reg_add_1)
    begin
      if  (falling_edge(clk)) then
        Reg_data0 <= array_reg(CONV_INTEGER(Read_reg_add_0)); -- read data from reg specified by Read_reg_add0
        Reg_data1 <= array_reg(CONV_INTEGER(Read_reg_add_1)); -- read data from reg specified by Read_reg_add1	
      end if ;
      if (Wr_enable = '1' and rising_edge(clk)) then  --write enable
        array_reg(CONV_INTEGER(Wr_address)) <= Wr_data; -- write data to register
      end if;  
    end process ;
 end Behavioral;   


















