library ieee ;
use ieee.std_logic_1164.all;

-----------------------------------------------------

entity MIPS is
port(
  Mips_clock: in std_logic; 
  Pc_clear: in std_logic:='0'; --if zero, clears

  Mips_out_R0: out std_logic_vector(31 downto 0);	---read_0
  Mips_out_R1: out std_logic_vector(31 downto 0);	---read_1
  Mips_Alu_Output: out std_logic_vector(31 downto 0)
);
end MIPS;


--Architecture
architecture Behavioral11 of MIPS is
---------component declaration
---1st stage-Instruction Fetch stage
component Instruction_Fetch is
port(
    I_clock: in std_logic;
    PC_clear: in std_logic:='0';
    branch_add: in std_logic_vector(15 downto 0);
    Next_Add_Selector: in std_logic;    ---pc_src
    Next_Add: out std_logic_vector(7 downto 0);
    Instruction: out std_logic_vector(31 downto 0)
);
end component;

--2nd stage-instruction decode stage
component Instruction_Decode is
  port(
    D_clk : in std_logic;
    pc_in: in std_logic_vector(7 downto 0);
    Wr_enable : in std_logic;
    Reg_add_0: in std_logic_vector(4 downto 0);
    Reg_add_1: in std_logic_vector(4 downto 0);
    Wr_addr : in std_logic_vector(4 downto 0);
    Wr_data : in std_logic_vector(31 downto 0);
    Sign_Ext_in : in std_logic_vector(15 downto 0);
    Rt_in : in std_logic_vector(4 downto 0);
    Rd_in : in std_logic_vector(4 downto 0);
   
    PC_out : out std_logic_vector(7 downto 0);
    Reg_data_0 : out std_logic_vector(31 downto 0);
    Reg_data_1 : out std_logic_vector(31 downto 0);
    Sign_Ext_out: out std_logic_vector(31 downto 0);
    Rt_out : out std_logic_vector(4 downto 0);
    Rd_out: out std_logic_vector(4 downto 0)
  );
end component;

--3rd stage-execution stage
component Execution_Stage is
port(
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
   
  Ex_addr: out std_logic_vector(7 downto 0);
  Ex_ALU_out: out std_logic_vector(31 downto 0);
  Ex_zero_flag: out std_logic;
  Ex_Carry: out std_logic;
  Ex_Wr_data_mem: out std_logic_vector(31 downto 0);
  Ex_Wr_Reg: out std_logic_vector(4 downto 0)
 
);
end component;

--4th stage-Memory access
component Memory_Access is
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
end component;

--5th stage-write back
component Write_Back is
port (
             ALU_Result: in std_logic_Vector(31 downto 0); -- 32 bit ALU result
             Read_data_mem: in std_logic_Vector(31 downto 0);
             Select_1: in std_logic; --select line
             mux_Wr_in: in std_logic_vector(4 downto 0);
             
             WR_Reg: out std_logic_vector(31 downto 0);
             Wr_mux_out: out std_logic_vector(4 downto 0)
);
end component;

--Control unit
component Control_Unit is
port(
    instruction: in std_logic_vector(31 downto 0);
    Rd: out std_logic;
    Alu_Op: out std_logic_vector(5 downto 0);
    Reg_to_addr: out std_logic;
    Alu_src: out std_logic;
    Branch: out std_logic;
    Read_from_mem: out std_logic;
    Wr_in_mem: out std_logic;
    Wr_Reg: out std_logic;
    mem_to_Reg: out std_logic
  );
end component;

--Hazard Detection Unit
component Hazard_Detection_Unit is
port(
  HZ_clock: in std_logic;
  Instruction: in std_logic_vector(31 downto 0);
 
  hazard_detected: out std_logic:='0';
  data_hazard_detected: inout std_logic:='0'
  );
end component;


--intermediary signals

--1st stage
signal branch_add_s: std_logic_vector(15 downto 0):="0000000000000000";
signal next_addr_selector_s: std_logic;
signal next_addr_s: std_logic_vector(7 downto 0);
signal instruction_init_s: std_logic_vector(31 downto 0):=x"00000000";
signal instruction_s: std_logic_vector(31 downto 0):=x"00000000";

--2nd stage
signal Wr_En_c: std_logic;
signal Wr_reg_id_s: std_logic_vector(4 downto 0);
signal Wr_data_s: std_logic_vector(31 downto 0);
signal pc_out_s: std_logic_vector(7 downto 0);
signal rdata0_s: std_logic_vector(31 downto 0);
signal rdata1_s: std_logic_vector(31 downto 0);
signal sig_ext_s: std_logic_vector(31 downto 0);
signal Rt_s: std_logic_vector(4 downto 0);
signal Rd_s: std_logic_vector(4 downto 0);

--Control unit 

signal Rd_c: std_logic;
signal ALU_Opcode_c: std_logic_vector(5 downto 0);
signal reg_to_addr_c: std_logic;
signal data_selector_2_c: std_logic;
signal branch_c: std_logic;
signal mem_read_c: std_logic;
signal mem_wr_c: std_logic;
signal mem_to_reg_c: std_logic;

--3rd stage

signal ALU_Out_s: std_logic_vector(31 downto 0);
signal zero_flag_c: std_logic;
signal ALU_carry_c: std_logic;
signal Wr_data_mem_s: std_logic_vector(31 downto 0);
signal Wr_reg_s: std_logic_vector(4 downto 0);

--4th Stage
signal read_data_s: std_logic_vector(31 downto 0);
signal mux_wr_s: std_logic_vector(4 downto 0);
signal ALU_to_reg_s: std_logic_vector(31 downto 0);

--5th stage

--intermediate signals
signal control_array_2_c: std_logic_vector(13 downto 0):="00000000000000";
signal control_array_3_c: std_logic_vector(13 downto 0):="00000000000000";
signal control_array_4_c: std_logic_vector(13 downto 0):="00000000000000";
signal control_array_5_c: std_logic_vector(13 downto 0):="00000000000000";

--output instructions
signal instruction_s_3: std_logic_vector(31 downto 0);
signal instruction_s_4: std_logic_vector(31 downto 0);
signal instruction_s_5: std_logic_vector(31 downto 0);

--Hazard Detection Unit
signal hazard_detected: std_logic:='0';
signal last_hazard_detected: std_logic:='0';
signal data_hazard_detected: std_logic:='0';
signal in_clock_stage_1: std_logic;

-------------------------------------------------------
--connections
begin
  in_clock_stage_1<=Mips_clock or (hazard_detected or data_hazard_detected);
  
  ---for 1st stage
  FirstStage: Instruction_Fetch port map(in_clock_stage_1,Pc_clear,branch_add_s, next_addr_selector_s, next_addr_s, instruction_init_s);

 
  last_hazard_detected<=transport hazard_detected after 100 ns;
  instruction_s<= x"00000000" when (data_hazard_detected='1') else
x"00000000" when (last_hazard_detected='1') else instruction_init_s;
  ---for 2nd stage
  SecondStage: Instruction_Decode port map(Mips_clock, next_addr_s,control_array_5_c(1),instruction_s(25 downto 21), instruction_s(20 downto 16),
    Wr_reg_id_s,Wr_data_s, instruction_s(15 downto 0),instruction_s(20 downto 16),instruction_s(15 downto 11),pc_out_s,rdata0_s,rdata1_s,
    sig_ext_s,Rt_s, Rd_s);
  
   ---for 3rd stage
   ThirdStage: Execution_Stage port map(Mips_clock,control_array_3_c(5),control_array_3_c(12 downto 7),control_array_3_c(13),control_array_3_c(6),pc_out_s,rdata0_s,rdata1_s,sig_ext_s,Rt_s, Rd_s,branch_add_s(7 downto 0),
    ALU_Out_s,zero_flag_c,ALU_carry_c,Wr_data_mem_s, Wr_reg_s);  
  
   ---for 4th stage
   ForthStage: Memory_Access port map(Mips_clock,control_array_4_c(3),control_array_4_c(2),ALU_Out_s,Wr_data_mem_s,Wr_reg_s,read_data_s,mux_Wr_s,ALU_to_reg_s);
   next_addr_selector_s <= control_array_4_c(4) and zero_flag_c;     -----for next address selection which goes to 1st stage
 
  --5th stage
  FifthStage:  WRITE_BACK port map(ALU_to_reg_s,read_data_s,control_array_5_c(0),mux_Wr_s,Wr_data_s,Wr_reg_s);
 
  --Control Unit
  MIPS_Control_Unit: Control_Unit port map(instruction_s,Rd_c,ALU_Opcode_c,reg_to_addr_c,data_selector_2_c,branch_c,mem_read_c,mem_Wr_c,Wr_En_c,mem_to_reg_c);
  control_array_2_c<=Rd_c & ALU_Opcode_c & reg_to_addr_c & data_selector_2_c & branch_c & mem_read_c & mem_Wr_c & Wr_En_c & mem_to_reg_c;
 
  --Hazard Detection Unit
  Hazard_Unit: Hazard_Detection_Unit port map(Mips_clock, instruction_s, hazard_detected, data_hazard_detected);
 
  --output assignments
  Mips_out_R0<=rdata0_s;
  Mips_out_R1<=rdata1_s;
  Mips_Alu_Output<=ALU_Out_s;
  
  process(Mips_clock)
  begin
    if (rising_edge(Mips_clock)) then 
      control_array_5_c<=control_array_4_c;
      control_array_4_c<=control_array_3_c;
      control_array_3_c<=control_array_2_c;
      instruction_s_5<=instruction_s_4;
      instruction_s_4<=instruction_s_3;
      instruction_s_3<=instruction_s;
    end if;
  end process;

end Behavioral11;

