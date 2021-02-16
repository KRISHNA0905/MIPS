library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Instruction_Fetch is
port(
    I_clock: in std_logic;
    PC_clear: in std_logic:='0';
    branch_add: in std_logic_vector(15 downto 0);
    Next_Add_Selector: in std_logic;    ---pc_src
    Next_Add: out std_logic_vector(7 downto 0);
    Instruction: out std_logic_vector(31 downto 0)
);
end Instruction_Fetch;

-- Architecture
architecture Behaviour1 of Instruction_Fetch is

---component declaration
-- component-ProgramCounter
component ProgramCounter is
port(
  clock: in std_logic;
  clear: in std_logic;
  data_in: in std_logic_vector(7 downto 0);
  data_out: out std_logic_vector(7 downto 0)
);
end component;

-- component-InstructionMemory 
component InstructionMemory is
port(
  address: in std_logic_vector(7 downto 0);
   instruction: out std_logic_vector(31 downto 0)
);
end component;

-- component-Mux
component Mux_8_16 is
	Port ( mux_in0 : in  STD_LOGIC_VECTOR(7 downto 0);
           mux_in1 : in  STD_LOGIC_VECTOR(15 downto 0);
           selection_line : in  STD_LOGIC;
           mux_out : out  STD_LOGIC_VECTOR(7 downto 0));
end component;

-- component-Adder
component Adder_IF is
generic(n: natural:=8);
  port(
      a: in std_logic_vector (n-1 downto 0);
      b: in std_logic_vector (n-1 downto 0):= x"04";
      carry: out std_logic;
      sum: out std_logic_vector (n-1 downto 0)
      );
end component;


--component-InterMediate stage 1
component InterMediate_stage_1 is
Generic (N : integer := 40);
     port(
        clock: in std_logic;
        input: in std_logic_vector(N-1 downto 0);
        output: out std_logic_vector(N-1 downto 0));
end component;

--intermediary signals

signal out_mux: std_logic_vector(7 downto 0):="00000000";
signal out_pc, out_adder: std_logic_vector(7 downto 0);
signal out_instruction: std_logic_vector(31 downto 0);
signal carry_address: std_logic;
signal in_IM_stage_1, out_IM_stage_1: std_logic_vector(39 downto 0);

-------------------------------------------------------
--connections
---port mapping
begin
	IF_PC: ProgramCounter port map(I_clock, PC_clear, out_mux, out_pc);
	IF_Add_1: Adder_IF port map(out_pc, x"04", carry_address, out_adder);
	IF_Mux_1: Mux_8_16 port map(out_adder, branch_add, Next_Add_Selector, out_mux);
	IF_InstructionMemory: InstructionMemory port map(out_pc, out_instruction);
	in_IM_stage_1<=out_adder & out_instruction;
	IF_IM_stage_1: InterMediate_Stage_1 port map(I_clock, in_IM_stage_1, out_IM_stage_1);

Next_add<=out_IM_stage_1(39 downto 32);
instruction<=out_IM_stage_1(31 downto 0);

end Behaviour1;

