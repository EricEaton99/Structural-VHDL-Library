-- mux8

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity mux8 is
port(
	inputs : in std_logic_vector(7 downto 0); 
	sel : in std_logic_vector(2 downto 0);
	output : out std_logic);
end mux8;

architecture rtl of mux8 is

-- conmponents
component mux4 is
port(
	in3, in2, in1, in0, 
	sel1, sel0 : in std_logic;
	out0 : out std_logic);
end component;

component mux2 is
port(
	in0, in1, sel0 : in std_logic;
	out0 : out std_logic);
end component;

-- wires
signal out_low, out_high : std_logic;

begin
	mux4_low  : mux4 port map(inputs(3), inputs(2), inputs(1), inputs(0), sel(1), sel(0), out_low);
	mux4_high : mux4 port map(inputs(7), inputs(6), inputs(5), inputs(4), sel(1), sel(0), out_high);
	mux2_msb  : mux2 port map(out_low, out_high, sel(2), output);
end rtl;