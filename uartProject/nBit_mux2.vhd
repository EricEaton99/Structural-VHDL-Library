-- nBitMux2

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity nBit_mux2 is
	generic ( n : positive := 4 );
	port(
		in1, in0 : in std_logic_vector(n-1 downto 0);
		sel0 : in std_logic;
		out0 : out std_logic_vector(n-1 downto 0));
end nBit_mux2;

architecture rtl of nBit_mux2 is

-- conmponents
--none

-- wires
signal sel_mask : std_logic_vector(n-1 downto 0);

begin
	sel_mask <= (others => sel0);
	out0 <= (in0 and not sel_mask) or (in1 and sel_mask);
end rtl;