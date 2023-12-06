-- nBit_reg

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity nBit_reg is
generic ( n : positive := 4 );
port(
	parallel_in, preset, clear : in std_logic_vector(n-1 downto 0);		--preset, clear could be masks with preset = !clear
	clk, en : in std_logic;
	q, q_not: out std_logic_vector(n-1 downto 0));
end nBit_reg;

architecture rtl of nBit_reg is

-- s1, s0	clk /^ action
-- 0,  0		same
-- 0,  1		parallel_in
-- 1,  0		sl
-- 1,  1 	sr

-- conmponents
component d_flipflop is
port(
	d, clk, en, preset, clear : in std_logic;
	q, q_not: out std_logic);
end component;

-- wires
--none
	

begin	
	--bits 1->n-2
	loop0: for i in 0 to n-1 generate
		dff: d_flipflop port map (
			parallel_in(i), clk, en, preset(i), clear(i), 
			q(i), q_not(i));
	end generate;
end rtl;