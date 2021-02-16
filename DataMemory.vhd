library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity DataMemory is
    Port (  clk: in std_logic;
             read_from_memory :in std_logic; --1 bit read function
             write_in_memory :in std_logic; --1 bit write function
             write_data: in std_logic_Vector(31 downto 0); --32 bit data from rd2 to WR data port(for Store)
             ALU_RESULT_Address: in std_logic_Vector(31 downto 0); -- 32 bit address
             read_data: out std_logic_Vector(31 downto 0)); -- Used for LOAD instruction
end DataMemory;

architecture Behavioral of DataMemory is
	signal b : std_logic_vector(31 downto 0);
		type RAM_16_x_32 is array(0 to 15) of std_logic_vector(31 downto 0);
		
		signal DM : RAM_16_x_32  := 	(x"00000000", 
												 x"00000001",
												 x"00000002",
												 x"00000003",
												 x"00000004",
												 x"00000005",
												 x"00000006",
												 x"00000007",
												 x"00000008",
												 x"00000009",
												 x"0000000A",
												 x"0000000B",
												 x"0000000C",
												 x"0000000D",
												 x"0000000E",
												 x"0000000F"
						);
									
begin
     process(clk) -- pulse on write
	begin
          b <= ALU_RESULT_Address(31 downto 0);
          if (rising_edge(clk)) then
	    if ( write_in_memory = '1') then
		DM( to_integer(unsigned(ALU_RESULT_Address))/4 ) <= write_data;
	    end if;
	
	    if( read_from_memory = '1') then
	
	      read_data <= DM ( to_integer(unsigned(ALU_RESULT_Address))/4 );
            end if;
          end if;
     end process;

end Behavioral;











