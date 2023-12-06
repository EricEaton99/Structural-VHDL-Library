

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity uart_fsm is
port(
	clk, global_reset, car_sensor : in std_logic;
	baud_sel : in std_logic_vector(2 downto 0);
	tx: out std_logic;
	tlc_cnt_1a, tlc_cnt_1b, tlc_cnt_1c, tlc_cnt_1d, tlc_cnt_1e, tlc_cnt_1f, tlc_cnt_1g, 
	tlc_cnt_2a, tlc_cnt_2b, tlc_cnt_2c, tlc_cnt_2d, tlc_cnt_2e, tlc_cnt_2f, tlc_cnt_2g : out std_logic);
end uart_fsm;

architecture rtl of uart_fsm is

-- conmponents
component nBit_counter_sync_clear is
generic ( n : positive := 4 );
port(
	clk, en, global_reset, clear_sync : in std_logic;
	target : in std_logic_vector(n-1 downto 0);
	at_target : out std_logic;
	total : out std_logic_vector(n-1 downto 0));
end component;

component mux8 is
port(
	inputs : in std_logic_vector(7 downto 0); 
	sel : in std_logic_vector(2 downto 0);
	output : out std_logic);
end component;

component traffic_light_tx is
port(
	clk, clk_baud, clk_1hz, car_sensor, global_reset : in std_logic;
	tx : out std_logic;
	tlc_timer : out std_logic_vector(3 downto 0));
end component;

component debouncer IS
	PORT(
		i_raw			: in	std_logic;
		i_clock			: in	std_logic;
		o_clean			: out	std_logic);
end component;

component byte_to_bcd is
port(
	bin: in  std_logic_vector (7 downto 0);
	bcd: out std_logic_vector (11 downto 0));
end component;

component dec_7seg IS
	PORT(i_hexDigit	: in std_logic_vector(3 downto 0);
	     o_segment_a, o_segment_b, o_segment_c, o_segment_d, o_segment_e, 
	     o_segment_f, o_segment_g : out std_logic);
end component;


-- wires
signal clk_div_41_at_target, clk_div_256_at_target, clk_div_150_at_target, clk_baud, clk_1hz, 
	car_sensor_debounced, tx_temp : std_logic;
signal clk_baud_total, tlc_timer_to_bcd : std_logic_vector(7 downto 0);
signal tlc_timer_bcd : std_logic_vector(11 downto 0);
signal tlc_timer : std_logic_vector(3 downto 0);

begin	
	
	-- Clocks ------------------------------------------------------------------
	
	clk_div_41 : nBit_counter_sync_clear
		generic map (6)
		port map(clk, '1', global_reset, clk_div_41_at_target, "101000", clk_div_41_at_target, open);
	
	
	-- CHANGE THIS -- clk SHOULD BE clk_div_41_at_target ----------
	clk_div_256 : nBit_counter_sync_clear
		generic map(8)
		port map(clk, '1', global_reset, clk_div_256_at_target, "11111111", clk_div_256_at_target, clk_baud_total);
		
	baud_mux : mux8 port map(clk_baud_total, baud_sel, clk_baud);
	
	
	-- CHANGE THIS -- 00001010 SHOULD BE 10010110 ----------
	clk_div_150 : nBit_counter_sync_clear
		generic map(8)
		port map(clk_baud_total(7), '1', global_reset, clk_div_150_at_target, "00001010", clk_div_150_at_target, open);
	
	clk_1hz <= clk_div_150_at_target;
	
	
	-- Stoplight ------------------------------------------------------------
	
	-- <= clk_baud;
	-- <= clk_1hz;
	
	sensor_debounce : debouncer port map(car_sensor, clk, car_sensor_debounced);
	
	-- CHANGE THIS -- car_sensor SHOULD BE car_sensor_debounced ----------
	-- CHANGE THIS -- car_sensor clk 2 BE clk_baud ----------
	-- CHANGE THIS -- car_sensor clk 3 BE clk_1hz ----------
	tlc : traffic_light_tx port map(clk, clk_baud, clk_1hz, car_sensor, global_reset, tx_temp, tlc_timer);
	tx <= tx_temp;
	
	
	-- Format stoplight timer as 7 seg ------------------------------------------------------------
	
	tlc_timer_to_bcd(3 downto 0) <= tlc_timer;
	tlc_timer_to_bcd(7 downto 4) <= "0000";
	
	bcd_format : byte_to_bcd port map(tlc_timer_to_bcd, tlc_timer_bcd);
	
	digit1 : dec_7seg port map (tlc_timer_bcd(3 downto 0), 
		tlc_cnt_1a, tlc_cnt_1b, tlc_cnt_1c, tlc_cnt_1d, tlc_cnt_1e, tlc_cnt_1f, tlc_cnt_1g);
	
	digit2 : dec_7seg port map (tlc_timer_bcd(7 downto 4), 
		tlc_cnt_2a, tlc_cnt_2b, tlc_cnt_2c, tlc_cnt_2d, tlc_cnt_2e, tlc_cnt_2f, tlc_cnt_2g);
	
	
end rtl;