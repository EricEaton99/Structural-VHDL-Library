-- parity_8Bit

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity parity_8Bit is
port(
	in0 : in std_logic_vector(7 downto 0);
	even_odd_low : in std_logic;
	parity : out std_logic);
end parity_8Bit;

architecture rtl of parity_8Bit is

-- conmponents
--none

-- wires
signal parity_odd : std_logic;

begin
	parity_odd <= ( ((in0(0) xor in0(1)) xor (in0(2) xor in0(3))) ) xor ( ((in0(4) xor in0(5)) xor (in0(6) xor in0(7))) );	--cost: 7*xor_cost a bit much
	parity <= parity_odd xor even_odd_low;
end rtl;