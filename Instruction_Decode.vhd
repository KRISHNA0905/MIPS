library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Instruction_Decode is
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
end Instruction_Decode;
  
  architecture Behaviour3 of Instruction_Decode is
----component declaration   
----component-register file----
    component Register_File is
      port(
   	 clk : in std_logic;
   	 Wr_Enable: in std_logic;
   	 Wr_address : in std_logic_vector(4 downto 0);
    	Wr_data: in std_logic_vector(31 downto 0);
    	Read_reg_add_0 : in std_logic_vector(4 downto 0);
    	Read_reg_add_1 : in std_logic_vector(4 downto 0);
    	Reg_data0 : out std_logic_vector(31 downto 0);
    	Reg_data1 : out std_logic_vector(31 downto 0));
     end component;
      
      ----component-sign extension----
      component Sign_Extender is
       port ( Sign_Extender_in: in STD_LOGIC_VECTOR(15 downto 0);
	      Sign_Extender_out: out STD_LOGIC_VECTOR(31 downto 0)
	      );
        end component;
        
        ----IM_stage_2----
        component Intermediate_stage_2 is
          port(
  		clock: in std_logic;
  		pc_in: in std_logic_vector(7 downto 0);
  		Rt_data1_in: in std_logic_vector(31 downto 0);
  		Rd_data2_in: in std_logic_vector(31 downto 0);
  		extended_data_in : in std_logic_vector(31 downto 0);
  		Rt_in : in std_logic_vector(4 downto 0);
  		Rd_in : in std_logic_vector(4 downto 0);
  
  		pc_out: out std_logic_vector(7 downto 0);
  		Rt_data1_out: out std_logic_vector(31 downto 0);
  		Rd_data2_out: out std_logic_vector(31 downto 0);
  		extended_data_out : out std_logic_vector(31 downto 0);
  		Rt_out : out std_logic_vector(4 downto 0);
  		Rd_out : out std_logic_vector(4 downto 0)
);
  end component;
          
          ----Intermediate Signals----
          signal Sign_Ext_Decode : std_logic_vector(31 downto 0);
          signal data_1,data_2: std_logic_vector(31 downto 0);
          
begin
            
D_dec_reg : Register_File port map(D_clk,Wr_enable,Wr_addr,Wr_data,Reg_add_0,Reg_add_1,data_1,data_2);--rdata1,rdata2);
D_dec_sign_ext : Sign_Extender port map(Sign_Ext_in,Sign_Ext_Decode);
D_dec_IM_stage_2 : Intermediate_stage_2 port map(D_clk,pc_in,data_1,data_2,Sign_Ext_Decode,Rt_in,Rd_in,PC_out,Reg_data_0,Reg_data_1,Sign_Ext_out,Rt_out,Rd_out);
              
              
end Behaviour3;

