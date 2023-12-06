-- simplified_traffic_light_controller_fsm

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity simplified_traffic_light_controller_fsm is
port(
	clk, global_reset, clear_sync : in std_logic;
	timer_total : out std_logic_vector(3 downto 0));
end simplified_traffic_light_controller_fsm;

architecture rtl of simplified_traffic_light_controller_fsm is

-- conmponents
component nBit_up_ripple_counter_sync_clear is
generic (
    n : positive := 4  -- Specify the number of bits
);
port(
	clk, preset, clear_sync, clear_async, en, stop_loop_high : in std_logic;
	target : in std_logic_vector(n-1 downto 0);
	at_target : out std_logic;
	total : out std_logic_vector(n-1 downto 0));
end component;

-- wires
signal at_target : std_logic;

begin
	timer : nBit_up_ripple_counter_sync_clear generic map(4) 
		port map(clk, '0',	clear_sync, global_reset, '1', '1',				"1100", at_target, timer_total);
				-- clk, preset, clear_sync, clear_async, en, stop_loop_high, target, at_target, total
end rtl;