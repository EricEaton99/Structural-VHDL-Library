
-- nBit_PISO_reg

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity nBit_PISO_reg is
generic ( n : positive := 4 );
port(
	parallel_in : in std_logic_vector(n-1 downto 0);
	serial_in, shift_load, clk, en, preset, clear : in std_logic;
	q, q_not: out std_logic_vector(n-1 downto 0));
end nBit_PISO_reg;

architecture rtl of nBit_PISO_reg is

-- conmponents
component mux2 is
port(
	in0, in1 ,sel0 : in std_logic;
	out0 : out std_logic);
end component;

component d_flipflop is
port(
	d, clk, en, preset, clear : in std_logic;
	q, q_not: out std_logic);
end component;

-- wires
signal d_left, mux_out : std_logic_vector(n-1 downto 0);
	

begin		
	mux_in0 : mux2 port map(serial_in, parallel_in(n-1), shift_load, mux_out(n-1));
	dff0: d_flipflop port map (
		mux_out(n-1), clk, en, preset, clear, 
		d_left(n-1), q_not(n-1));
			
	loop0: for i in 0 to n-2 generate
		mux_inI : mux2 port map(d_left(i+1), parallel_in(i), shift_load, mux_out(i));
		dffI: d_flipflop port map (
			mux_out(i), clk, en, preset, clear, 
			d_left(i), q_not(i));
	end generate;
	
	q <= d_left;
end rtl;