-- VHDL_mux4

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity mux4 is
port(
	in3, in2, in1, in0, sel1, 
	sel0 : in std_logic;
	out0 : out std_logic);
end mux4;

architecture rtl of mux4 is

-- conmponents
--none

-- wires
--none

begin
	out0 <= (in0 and not sel1 and not sel0) or (in1 and not sel1 and sel0) or (in2 and sel1 and not sel0) or (in3 and sel1 and sel0);
end rtl;