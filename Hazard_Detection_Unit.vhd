library ieee ;
use ieee.std_logic_1164.all;

entity Hazard_Detection_Unit is
port(
  HZ_clock: in std_logic;
 Instruction: in std_logic_vector(31 downto 0);
  
  hazard_detected: out std_logic:='0';
	data_hazard_detected: inout std_logic:='0'
  );
end Hazard_Detection_Unit;

architecture Behaviour1 of Hazard_Detection_Unit is

--for control hazards
signal Last_Inst: std_logic_vector(31 downto 0);
signal Stall_Count: integer range -2 to 4:=-2;

--for data hazards
signal Last_Op_Reg_1: std_logic_vector(4 downto 0):="00000";
signal Last_Op_Reg_2: std_logic_vector(4 downto 0):="00000";

begin
  process(Instruction)
    variable Opcode: std_logic_vector(5 downto 0);
    variable Funct: std_logic_vector(5 downto 0);

	--data hazards
  	variable dest_Reg: std_logic_vector(4 downto 0);
  	variable Rt: std_logic_vector(4 downto 0);
  	variable Rs: std_logic_vector(4 downto 0); 
  begin

  Opcode:=Instruction(31 downto 26);
  Funct:=Instruction(5 downto 0);
  
  Rt:=Instruction(20 downto 16);
  Rs:=Instruction(25 downto 21 );
  dest_reg:=instruction(15 downto 11);

	--hazard on consecutive instructions
  if (Last_Op_Reg_1=Rt and (Rt/="00000" and Last_Op_Reg_1/="XXXXX") and data_hazard_detected='0') then
		data_hazard_detected<='1';
    data_hazard_detected<= transport '0' after 300 ns;  --stall for 2 cycles
	elsif (Last_Op_Reg_1=Rs and (Rs/="00000" and Last_Op_Reg_1/="XXXXX") and data_hazard_detected='0') then
		data_hazard_detected<='1';
    data_hazard_detected<= transport '0' after 300 ns;--stall for 2 cycles
	
	elsif (Last_Op_Reg_2=Rt and (Rt/="00000" and Last_Op_Reg_1/="XXXXX") and data_hazard_detected='0') then
		data_hazard_detected<='1';
    data_hazard_detected<= transport '0' after 200 ns;--stall for 1 cycles 
	elsif (Last_Op_Reg_2=Rs and (Rs/="00000" and Last_Op_Reg_1/="XXXXX") and data_hazard_detected='0') then
		data_hazard_detected<='1';
    data_hazard_detected<= transport '0' after 200 ns;--stall for 1 cycles


--CONTROL Hazards --if no data hazards were found, check for control hazards
--Branch Equal or Jump Register
  elsif (Opcode="000010" or Opcode="000100") then  
    hazard_detected<='1';
    hazard_detected<= transport '0' after 205 ns;--stall for 2 cycles and a little more
  
  else
  end if;

	if (Opcode="000000") then --r type
		Last_Op_Reg_2<=Last_Op_Reg_1;
		Last_Op_Reg_1<=dest_reg;
	elsif (Opcode="001000" or Opcode="000011" or Opcode="100011") then --immediate instruction
		Last_Op_Reg_2<=Last_Op_Reg_1;
		Last_Op_Reg_1<=Rs;
	else
		Last_Op_Reg_2<=Last_Op_Reg_1;
		Last_Op_Reg_1<="XXXXX"; ---other instructions will never create stall
	end if;

  end process;

end Behaviour1;
