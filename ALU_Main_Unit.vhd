library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

---all Input Output declaration 
entity Alu_Main_Unit is
port(Alu_Opcode : in std_logic_vector(5 downto 0);      --to decide the type of operation
     Reg_Data_0 : in std_logic_vector(31 downto 0);     -- data from Register 1
     Reg_Data_1 : in std_logic_vector(31 downto 0);     -- data from Register 2
        
     Alu_Out : out std_logic_vector(31 downto 0);   -- ALU result after performing operations
     Zero_Flag : out std_logic;
     Alu_Carry: out std_logic                         -- Providing ALU result only for BEQ command 
);
end Alu_Main_Unit;

architecture behavioral of Alu_Main_Unit is


signal ALU_out_1 : std_logic_vector (32 downto 0);      -- Intermediate signal to store ALU result 

begin

process (Alu_Opcode, Reg_Data_0, Reg_Data_1) 
  variable ALU_out_1: std_logic_vector (32 downto 0);      -- Intermediate signal to store ALU result 
  begin
  

  --alu_result <= x"00000000" & '0';
  Alu_Carry <= '0';
            
  case Alu_Opcode is 
      when "100000" => 
                ALU_out_1 := ('0' & Reg_Data_0) + ('0' & Reg_Data_1);		----Add     			
      when "100010" => 
                    ALU_out_1 := '0' & (Reg_Data_0 - Reg_Data_1);            -- SUB   Operation -- take Care of this subtraction 
      when "100100" => 
                    ALU_out_1 := '0' & (Reg_Data_0 and Reg_Data_1);
      when "100101" => 
                    ALU_out_1 := '0' & (Reg_Data_0 or Reg_Data_1);
      when "100111" => 
                    ALU_out_1 := '0' & (Reg_Data_0 xor Reg_Data_1);
      when "100011" => 
                    ALU_out_1 := ('0' & Reg_Data_0) + ('0' & Reg_Data_1);      --LW
      when "101011" => 
		    ALU_out_1 := ('0' & Reg_Data_0) + ('0' & Reg_Data_1);      --sw
      when "000010" => 
      		    ALU_out_1 := x"00000000" & '0'; 				--jump
      when "000100" =>
                    ALU_out_1 := '0' & (Reg_Data_0 - Reg_Data_1);             ---BEQ                 
      when others =>
        	    ALU_out_1 := x"00000000" & '0';                          --- NO OPERATION
  
  end case; 
  
  if ALU_out_1(32) = '1' then
          Alu_Carry <= '1';
  else
          Alu_Carry <= '0';
  end if;
  
  if (ALU_out_1(31 downto 0)=x"00000000" and (Alu_Opcode="000010" or Alu_Opcode="000100")) then ----Jump or BEQ
    Zero_Flag <= '1';
  else
    Zero_Flag <= '0';
  end if;
    
  Alu_Out <= ALU_out_1(31 downto 0);

end process;   

end behavioral;
