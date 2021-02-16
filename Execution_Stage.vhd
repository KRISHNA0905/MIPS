
-- EX Stage -- Execution stage
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Execution_Stage is 
port(
---inputs
  Ex_clk: in std_logic;  
  Ex_Data_Selector_2: in std_logic;
  Ex_ALU_Opcode: in std_logic_vector(5 downto 0);
  Ex_Wr_Reg_Selector: in std_logic;
  Ex_Next_addr_selector: in std_logic;
  
  Ex_addr_ID: in std_logic_vector (7 downto 0);
  Ex_data_in_0: in std_logic_vector(31 downto 0);
  Ex_data_in_1: in std_logic_vector(31 downto 0);
  Ex_sign_ext_in: in std_logic_vector(31 downto 0);
  Ex_inst_1: in std_logic_vector(4 downto 0); 
  Ex_inst_2: in std_logic_vector(4 downto 0);
---outputs   
  Ex_addr: out std_logic_vector(7 downto 0);
  Ex_ALU_out: out std_logic_vector(31 downto 0);
  Ex_zero_flag: out std_logic;
  Ex_Carry: out std_logic;
  Ex_Wr_data_mem: out std_logic_vector(31 downto 0);
  Ex_Wr_Reg: out std_logic_vector(4 downto 0)
  
);
end Execution_Stage;

architecture dataflow of Execution_Stage is
--selector for Data2
  component MUX_32 is
 Generic (N : integer := 32);
    Port ( mux_in0 : in  STD_LOGIC_VECTOR(N-1 downto 0);
           mux_in1 : in  STD_LOGIC_VECTOR(N-1 downto 0);
           selection_line : in  STD_LOGIC;
           mux_out : out  STD_LOGIC_VECTOR(N-1 downto 0));
  end component;

--Shifting of sign extended bits
  component left_shift_by_2 is
   port (
    data_in : in std_logic_vector(31 downto 0);
    shifted_data_out : out std_logic_vector(31 downto 0)
    );
    end component;
 
---Selector for Write Register  
  component MUX_4 is
  Generic (N : integer := 5);
    Port ( mux_in0 : in  STD_LOGIC_VECTOR(N-1 downto 0);
           mux_in1 : in  STD_LOGIC_VECTOR(N-1 downto 0);
           selection_line : in  STD_LOGIC;
           mux_out : out  STD_LOGIC_VECTOR(N-1 downto 0));
    end component;  
  
---selector for next address    
  component Mux_8_32 is
  Port ( mux_in0 : in  STD_LOGIC_VECTOR(7 downto 0);
           mux_in1 : in  STD_LOGIC_VECTOR(31 downto 0);
           selection_line : in  STD_LOGIC;
           mux_out : out  STD_LOGIC_VECTOR(7 downto 0));
  end component;
  
  
  
---deciding opcode 
  component ALU_Control is
  port(
  Alu_Opcode : in std_logic_vector(5 downto 0);
  Alu_Function : in std_logic_vector(5 downto 0);
  Alu_Control_Out : out std_logic_vector(5 downto 0)
);
  end component;

----Operations are performed here
  component ALU_Main_Unit is
port(Alu_Opcode : in std_logic_vector(5 downto 0);      --decide type of operation
     Reg_Data_0 : in std_logic_vector(31 downto 0);     -- Reading data from Register 0
     Reg_Data_1 : in std_logic_vector(31 downto 0);     -- Reading data from Register 1
        
     Alu_Out : out std_logic_vector(31 downto 0);   ---ALU result after performing operations
     Zero_Flag : out std_logic;
     Alu_Carry: out std_logic                         --- for BEQ command 
);
  end component;
    
  component Adder_8_32 is
 port(
    in1: in std_logic_vector (7 downto 0);
    in2: in std_logic_vector (31 downto 0);
    sum: out std_logic_vector (7 downto 0);
    carry: out std_logic
    );
  end component;
  
  component InterMediate_stage_3 is
	Generic (N : integer := 79);
     port(
        clock: in std_logic;
        input: in std_logic_vector(N-1 downto 0);
        output: out std_logic_vector(N-1 downto 0)
);
  end component;


signal out_mux_32: std_logic_vector(31 downto 0); 
signal out_mux_4: std_logic_vector(4 downto 0); 
signal out_left_shift_by_2: std_logic_vector(31 downto 0);
signal Sum_Adder: std_logic_vector (7 downto 0); 
signal Carry_Adder: std_logic; 
signal out_mux_8: std_logic_vector (7 downto 0);
signal out_Alu_Control: std_logic_vector (5 downto 0);
signal out_Alu_Result: std_logic_vector(31 downto 0);
signal out_Alu_Zero: std_logic; 
signal out_Alu_Carry: std_logic;--
signal in_InterMediate_stage_3: std_logic_vector (78 downto 0); 
signal out_InterMediate_stage_3: std_logic_vector (78 downto 0); 
   
begin  
  
EX_Mux_32:  MUX_32 port map (Ex_data_in_1,Ex_sign_ext_in,Ex_Data_Selector_2, out_mux_32);
EX_Mux_4: MUX_4 port map ( Ex_inst_1, Ex_inst_2, Ex_Wr_Reg_Selector, out_mux_4);
EX_sl2: left_shift_by_2 port map (Ex_sign_ext_in, out_left_shift_by_2);
EX_Adder: adder_8_32 port map (Ex_addr_ID,out_left_shift_by_2, Sum_Adder, Carry_Adder); 
EX_Mux8_32:   MUX_8_32 port map (Sum_Adder,Ex_data_in_0, Ex_Next_addr_selector, out_mux_8);
EX_ALU_Contol:  ALU_Control port map (Ex_ALU_Opcode ,Ex_sign_ext_in(5 downto 0), out_Alu_Control);
EX_ALU:  ALU_Main_Unit port map (out_Alu_Control, Ex_data_in_0,out_mux_32, out_Alu_Result, out_Alu_Zero, out_Alu_Carry); 
 
in_InterMediate_stage_3<=   (out_mux_8 &  out_Alu_Zero & out_Alu_Result & out_Alu_Carry & Ex_data_in_0 & out_mux_4); 

EX_IM: InterMediate_stage_3 port map (Ex_clk, in_InterMediate_stage_3,out_InterMediate_stage_3); 
  
Ex_addr <= out_InterMediate_stage_3(78 downto 71);
Ex_zero_flag <= out_InterMediate_stage_3(70);
Ex_ALU_out <= out_InterMediate_stage_3(69 downto 38);
Ex_Carry <= out_InterMediate_stage_3(37);
Ex_Wr_data_mem <= out_InterMediate_stage_3(36 downto 5);
Ex_Wr_Reg<= out_InterMediate_stage_3(4 downto 0);
  
end dataflow; 




