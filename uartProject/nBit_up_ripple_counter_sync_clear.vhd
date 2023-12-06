-- nBit_up_ripple_counter_sync_clear

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity nBit_up_ripple_counter_sync_clear is
generic (
    n : positive := 4  -- Specify the number of bits
);
port(
	clk, preset, clear_sync, clear_async, en, stop_loop_high : in std_logic;
	target : in std_logic_vector(n-1 downto 0);
	at_target, ENOUT, CLEAR_SYNC_COUT : out std_logic;
	total : out std_logic_vector(n-1 downto 0));
end nBit_up_ripple_counter_sync_clear;

architecture rtl of nBit_up_ripple_counter_sync_clear is

-- conmponents
component d_flipflop is
port(
	d, clk, en, preset, clear : in std_logic;
	q, q_not : out std_logic);
end component;

-- wires
signal en_temp, at_target_temp, clear_sync_with_loop : std_logic;
signal q, q_not : std_logic_vector(n-1 downto 0);

begin
	
	en_temp <= en and (not at_target_temp or (at_target_temp and stop_loop_high) or clear_sync);
	clear_sync_with_loop <= clear_sync or (at_target_temp and stop_loop_high);
	
	dff : d_flipflop port map (
		q_not(0) and not clear_sync_with_loop, clk, en_temp, preset, clear_async, 
		q(0), q_not(0));
	
	loop1: for i in 1 to n-1 generate
	
		dff : d_flipflop port map (
			q_not(i) and not clear_sync_with_loop, (q_not(i-1) and not clear_sync_with_loop) or (clk and clear_sync_with_loop), en_temp, preset, clear_async, 
			q(i), q_not(i));
			
	end generate;
	
	at_target_temp <= '1' when (q = target) else '0';	-- this is andn for all r(i) <= (q[i] xor not target[i])
	
	at_target <= at_target_temp;
	total <= q;
	
	ENOUT <= en_temp;
	CLEAR_SYNC_COUT <= clear_sync_with_loop;
end rtl;