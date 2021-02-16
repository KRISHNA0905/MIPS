library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY InstructionMemory is
    PORT(
        address: IN std_logic_vector(7 downto 0);
        instruction: OUT std_logic_vector(31 downto 0)
    );
END ENTITY;

ARCHITECTURE arch1 of InstructionMemory is

--memory should have 4 times less words than bytes (1 word = 4 bytes);
--for a 2^8 bits address memory we have 256 byte addresses and 64 word addresses.
-- In reality, this memory is not byte addressable

TYPE MEM is array(0 to 255) of std_logic_vector(31 downto 0);

CONSTANT rom_arr: MEM := (
										0=>"00000000011000100000100000100000", ---add $t2,$t1,$t0
									        1=>"00000000110001010010000000100010", ---sub $t5,$t4,$t3
										2=>"00000001001010000011100000100100", ---and $t8,$t7,$t6
										3=>"00000001111011100110100000100111", ---xor $t14,$t13,$t12
										4=>"00100010001100000000000100010000", ---andi $t16,15,1111
									 	5=>"00001110011100100000000000000101", ---subi $t18,$t17,0x5555											 x"018b6825",
										6=>"10001110101000000000000000000101", ---lw $t20,$rz,0x0005
										7=>"10101110110000000000000000000110", ---sw $t21,$rz,0x0006									
										8=>"00010011000110010000000000000001", ---beq $t23,$t24,0x0001
										9=>"00001000000000000000000000000001", ---jr $t9										
									
													
OTHERS=>"00000000000000000000000000000000");

BEGIN
    PROCESS(address)
    VARIABLE addr_int: INTEGER RANGE 0 TO 255;
    BEGIN
        addr_int:=CONV_INTEGER(address(7 downto 2));  ----we are adding 4 to program counter  
        instruction<=rom_arr(addr_int);
    END PROCESS;

END arch1;
