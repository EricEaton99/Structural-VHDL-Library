-- d_flipflop

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity d_flipflop is
port(
	d, clk, en, preset, clear : in std_logic;
	q, q_not: out std_logic);
end d_flipflop;

architecture rtl of d_flipflop is

-- conmponents
component jk_flipflop is
port(
	j, k, clk, en, preset, clear : in std_logic;
	q, q_not: out std_logic);
end component;

-- wires


begin
	jk : jk_flipflop port map(d, not d, clk, en, preset, clear, q, q_not);
end rtl;