-- traffic_light_controller_fsm

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity traffic_light_controller_fsm is
port(
	clk_1hz, global_reset, car_sensor : in std_logic;
	tlc_state : out std_logic_vector(1 downto 0);
	tlc_timer : out std_logic_vector(3 downto 0);
	tlc_state_change : out std_logic);
end traffic_light_controller_fsm;

architecture rtl of traffic_light_controller_fsm is


-- conmponents
component counter_4bits_sync_clear is
port(
	clk, en, global_reset, clear_sync : in std_logic;
	target : in std_logic_vector(3 downto 0);
	at_target : out std_logic;
	total : out std_logic_vector(3 downto 0));
end component;

component nBit_mux4 is
generic ( n : positive := 4 );
port(
	in3, in2, in1, in0 : in std_logic_vector(n-1 downto 0);
	sel1, sel0 : in std_logic;
	out0 : out std_logic_vector(n-1 downto 0));
end component;


-- wires
signal state_cntr_en, state_cntr_clear, state_cntr_at_target, 
		timer_cntr_en, timer_cntr_clear, timer_cntr_at_target : std_logic;
signal state_cntr_total : std_logic_vector(3 downto 0);
signal timer_cntr_target : std_logic_vector(3 downto 0);


begin
	--state_reg : nBit_reg generic map(2) port map(<<parallel_in>>, '0', global_reset, clk_1hz, '1', <<q>>, open);
	state_cntr_en <= (timer_cntr_at_target and (state_cntr_total(1) or state_cntr_total(0))) 
							or (timer_cntr_at_target and (state_cntr_total(1) nor state_cntr_total(0)) and car_sensor);
	state_cntr_clear <= state_cntr_en and state_cntr_at_target;
	
	state_cntr : counter_4bits_sync_clear port map(clk_1hz, state_cntr_en, global_reset, state_cntr_clear, "0011", state_cntr_at_target, state_cntr_total);
															  -- clk,	  en, 			  global_reset, clear_sync, 		 target, at_target, 				total	

	tlc_state_change <= state_cntr_en;
	tlc_state <= state_cntr_total(1 downto 0);
	
	
	--change this
	timer_target_mux : nBit_mux4 generic map(4) port map("0011", "1111", "0010", "1000", state_cntr_total(1), state_cntr_total(0), timer_cntr_target);
	
	timer_cntr_en <= '1';
	timer_cntr_clear <= state_cntr_en;
	
	timer_cntr : counter_4bits_sync_clear port map(clk_1hz, timer_cntr_en, global_reset, timer_cntr_clear, timer_cntr_target, timer_cntr_at_target, tlc_timer);
															  -- clk, 	  en,				  global_reset, clear_sync, target, at_target, 		  total	
end rtl;