-- t_flipflop

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity t_flipflop is
port(
	t, clk, en, preset, clear : in std_logic;
	q, q_not: out std_logic);
end t_flipflop;

architecture rtl of t_flipflop is

-- conmponents
component jk_flipflop is
port(
	j, k, clk, en, preset, clear : in std_logic;
	q, q_not: out std_logic);
end component;

-- wires


begin
	jk : jk_flipflop port map(t, t, clk, en, preset, clear, q, q_not);
end rtl;