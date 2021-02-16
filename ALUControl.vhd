library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ALU_Control is
port(
  Alu_Opcode : in std_logic_vector(5 downto 0);
  Alu_Function : in std_logic_vector(5 downto 0);
  Alu_Control_Out : out std_logic_vector(5 downto 0)
);
end ALU_Control;

architecture behavioral of ALU_Control is
begin
process(Alu_Opcode,Alu_Function)
  begin
    case Alu_Opcode is    
    when "000000" => 
      case  Alu_Function is
      when "100000" =>
      Alu_Control_Out <= "100000";       -- Tell the ALU to perform ADD operation 
      when "100010" =>
      Alu_Control_Out <= "100010";       -- Tell the ALU to perform SUB operation 
      when "100100" =>
      Alu_Control_Out <= "100100";       -- Tell the ALU to perform AND operation 
      when "100101" =>
      Alu_Control_Out <= "100101";       -- Tell the ALU to perform OR operation
      when "100111" =>
      Alu_Control_Out <= "100111";       -- Tell the ALU to perform XOR operation
      when others =>
      Alu_Control_Out <= "111111";       -- Tell the ALU for NO Operation or Error
      end case;
    
    when "100011" =>
    Alu_Control_Out <= "100011";         -- Tell the ALU to perform LW operation
    when "101011" =>
    Alu_Control_Out <= "101011";         -- Tell the ALU to perform SW operation
    when "000100" =>
    Alu_Control_Out <= "000100";         -- Tell the ALU to perform BEQ operation 
    when "000010" =>
    Alu_Control_Out <= "000010";         -- Tell the ALU to perform Jump operation 
    when others => 
    Alu_Control_Out <= "111111";         -- Tell the ALU for NO Operation or Error
    end case;
end process;
end behavioral;


