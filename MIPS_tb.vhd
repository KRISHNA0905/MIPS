LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MIPS_tb IS
END MIPS_tb;
 
ARCHITECTURE behavior OF MIPS_tB IS
   
    COMPONENT MIPS
    PORT(
     Mips_clock: in std_logic; 
     Pc_clear: in std_logic:='0'; 

     Mips_out_R0: out std_logic_vector(31 downto 0);	---read_0
     Mips_out_R1: out std_logic_vector(31 downto 0);	---read_1
     Mips_Alu_Output: out std_logic_vector(31 downto 0);
     Mips_R_data: out std_logic_vector(31 downto 0)	
 
        );
    END COMPONENT;
   
   signal Mips_clock: std_logic := '0';
   signal pc_clear : std_logic := '0';
   
   signal Mips_out_R0 : std_logic_vector(31 downto 0);
   signal Mips_out_R1 : std_logic_vector(31 downto 0);
   signal Mips_Alu_Output : std_logic_vector(31 downto 0);
   signal Mips_R_data : std_logic_vector(31 downto 0);
   constant clk_period : time :=  100 ns;
BEGIN
 
   uut: MIPS PORT MAP (
          Mips_clock => Mips_clock,
          pc_clear => pc_clear,
          Mips_out_R0 => Mips_out_R0,
          Mips_out_R1 => Mips_out_R1,
          Mips_Alu_Output => Mips_Alu_Output,
          Mips_R_data => Mips_R_data
        );

   -- Clock process definitions
   clk_process :process
   begin
  	Mips_clock <= '0';
  	wait for clk_period/2;
  	Mips_clock <= '1';
  	wait for clk_period/2;
   end process;
   -- Stimulus process
   stim_proc: process
   begin  
      pc_clear <= '0';
      wait for 100ns ;
      pc_clear <= '1';
      -- insert stimulus here
      wait;
   end process;

END;
