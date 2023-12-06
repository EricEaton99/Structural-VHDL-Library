-- pulse_length_trim
-- this is an fsm to trim long pulses to be no longer than the provided clock pulse
-- useful is you are working with multiple clock rates as in baud

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity pulse_length_trim is
port(
	clk, global_reset, pulse_long : in std_logic;
	pulse_trimmed : out std_logic);
end pulse_length_trim;

architecture rtl of pulse_length_trim is

-- conmponents
component d_flipflop is
port(
	d, clk, en, preset, clear : in std_logic;
	q, q_not: out std_logic);
end component;

-- wires
signal x, d0, d1, d0_not, d1_not : std_logic;

begin
	-- d1d0/pulse_trimmed   -pulse_long->   d1d0(next)
	--
	-- 00/0  -0-> 00, -1-> 01
	-- 01/1  -0-> 00, -1-> 10
	-- 10/0  -0-> 00, -1-> 10
	-- 11/x 
	
	x <= pulse_long;
	
	d0_ff : d_flipflop port map((x and d0_not and d1_not), clk, '1', '0', global_reset, d0, d0_not);
	d1_ff : d_flipflop port map((x and d0) or (x and d1), clk, '1', '0', global_reset, d1, d1_not);
	
	pulse_trimmed <= d1_not and d0;
end rtl;