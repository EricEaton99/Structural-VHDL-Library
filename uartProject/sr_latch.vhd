-- sr_latch

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity sr_latch is
port(
	s, r : in std_logic;
	q, q_not: out std_logic);
end sr_latch;

architecture rtl of sr_latch is

-- conmponents
--none

-- wires
signal q_temp, q_not_temp : std_logic;


begin
	q_temp <= s nand q_not_temp;
	q_not_temp <= r nand q_temp;
	
	q <= q_temp;
	q_not <= q_not_temp;
end rtl;