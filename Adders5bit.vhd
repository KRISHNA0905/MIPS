library ieee; 
use ieee.std_logic_1164.all; 
entity fulladder_5bit is 
port(in1,in2: in std_logic_vector(5 downto 0); 
  cin : in std_logic; 
 sum : out std_logic_vector(5 downto 0); 
 cout: out std_logic); 
end fulladder_5bit; 
architecture str_fulladder_5bit of fulladder_5bit is 
signal s0,s1,s2 : std_logic; 
signal c : std_logic_vector(5 downto 0); 
component fulladder 
port(in1,in2, cin : in std_logic; 
 
 sum,cout: out std_logic); 
end component; 
begin 
f1: fulladder port map(in1(0),in2(0),cin,sum(0),c(0)); 
g1 : for i in 1 to 5 generate 
f2:fulladder port map(in1(i),in2(i),c(i-1),sum(i),c(i)); 
end generate; 
cout<=c(5); 
end str_fulladder_5bit; 