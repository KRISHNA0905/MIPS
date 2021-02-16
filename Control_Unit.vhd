  library ieee ;
  use ieee.std_logic_1164.all;
  
  -----------------------------------------------------
  
  entity Control_Unit is
  port(
    instruction: in std_logic_vector(31 downto 0);
    
    Rd: out std_logic;
    Alu_Op: out std_logic_vector(5 downto 0);
    Reg_to_addr: out std_logic;
    Alu_src: out std_logic;    ----Data_2_selector
    Branch: out std_logic;
    Read_from_mem: out std_logic;
    Wr_in_mem: out std_logic;
    Wr_Reg: out std_logic;
    mem_to_Reg: out std_logic
  );
  end Control_Unit;
  
  -----------------------------------------------------
  
  architecture Behaviour6 of Control_Unit is
  begin
  
    process(instruction)
      variable Opcode: std_logic_vector(5 downto 0);
      variable Funct: std_logic_vector(5 downto 0);
    begin
       Opcode:=instruction(31 downto 26);
       Funct:=instruction(5 downto 0);
      case Opcode is
        when "000000"=> --r-type 
            Rd<='1';
            Alu_Op<="000000";
            Reg_to_addr<='0';
            Alu_src<='0';
            Branch<='0';
            Read_from_mem<='0';
            Wr_in_mem<='0';
            Wr_Reg<='1';
            mem_to_Reg<='0';
         when "000010"=> ---jr
            Rd<='0'; 
            Alu_Op<="000010";
            Reg_to_addr<='1';
            Alu_src<='0';
            Branch<='1';
            Read_from_mem<='0';
            Wr_in_mem<='0';
            Wr_Reg<='0';
            mem_to_reg<='0';
             
        when "001000"=> --andi
          Rd<='0';
          Alu_Op<="001000";
          Reg_to_addr<='0';
          Alu_src<='1';
          Branch<='0';
          Read_from_mem<='0';
          Wr_in_mem<='0';
          Wr_Reg<='1';
          mem_to_reg<='0';
          
        when "000100"=> --beq
          Rd<='0'; 
          Alu_Op<="000100";
          Reg_to_addr<='0';
          Alu_src<='0';
          Branch<='1';
          Read_from_mem<='0';
          Wr_in_mem<='0';
          Wr_Reg<='0';
          mem_to_reg<='0'; 
          
        when "100011"=> --lw
          Rd<='0';
          Alu_Op<="100011";
          Reg_to_addr<='0';
          Alu_src<='1';
          Branch<='0';
          Read_from_mem<='1';
          Wr_in_mem<='0';
          Wr_Reg<='1';
          mem_to_reg<='1';
        
        when "101011"=> --sw
          Rd<='0'; 
          Alu_Op<="101011";
          Reg_to_addr<='0';
          Alu_src<='1';
          Branch<='0';
          Read_from_mem<='0';
          Wr_in_mem<='1';
          Wr_Reg<='0';
          mem_to_reg<='0'; 
        
        when "000011"=> --subi
          Rd<='0';
          Alu_Op<="000011";
          Reg_to_addr<='0';
          Alu_src<='1';
          Branch<='0';
          Read_from_mem<='0';
          Wr_in_mem<='0';
          Wr_Reg<='1';
          mem_to_reg<='0';
          
        when others=>
          
      end case;
    end process;
  
  end Behaviour6;
