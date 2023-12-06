-- mux2

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity mux2 is
port(
	in0, in1, sel0 : in std_logic;
	out0 : out std_logic);
end mux2;

architecture rtl of mux2 is

-- conmponents
--none

-- wires
--none

begin
	out0 <= (in0 and not sel0) or (in1 and sel0);
end rtl;