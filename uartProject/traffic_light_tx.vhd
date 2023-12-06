-- traffic_light_tx

-- take in clk, clk_baud, car_sensor, and global_reset 
-- output tx, 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity traffic_light_tx is
port(
	clk, clk_baud, clk_1hz, car_sensor, global_reset : in std_logic;
	tx : out std_logic;
	tlc_timer : out std_logic_vector(3 downto 0));
end traffic_light_tx;


architecture rtl of traffic_light_tx is

-- conmponents
component traffic_light_controller_fsm is
port(
	clk_1hz, global_reset, car_sensor : in std_logic;
	tlc_state : out std_logic_vector(1 downto 0);
	tlc_timer : out std_logic_vector(3 downto 0);
	tlc_state_change : out std_logic);
end component;

component pulse_length_trim is
port(
	clk, global_reset, pulse_long : in std_logic;
	pulse_trimmed : out std_logic);
end component;

component traffic_light_controller_tx_message_compiler is
port(
	 state : in std_logic_vector(1 downto 0);
	 tx_message : out std_logic_vector(7*6-1 downto 0));	--6 7-bit characters
end component;

component tlc_tx_message_buffer is
port(
	 tx_message : in std_logic_vector(7*6-1 downto 0);
	 load_message, global_reset, clk, next_char : in std_logic;
	 ascii_char : out std_logic_vector(6 downto 0);
	 buffer_empty : out std_logic;
	 ascii_chars : out std_logic_vector(7*6-1 downto 0));
end component;

component uart_tx_fsm is
port(
	bus0 : in std_logic_vector(7 downto 0);
	bus_ready, clk, clk_baud, global_reset : in std_logic;
	tx : out std_logic;
	i_cnt : out std_logic_vector(3 downto 0);
	tdr : out std_logic_vector(6 downto 0);
	tsr : out std_logic_vector(9 downto 0);
	tdr_empty, state : out std_logic);
end component;


-- wires
signal tlc_state : std_logic_vector(1 downto 0);
signal tlc_state_change, tlc_state_change_trimmed, clk_tlc, get_next_tx_char, buffer_empty, tdr_empty : std_logic;
signal tx_message : std_logic_vector(7*6-1 downto 0);
signal ascii_char : std_logic_vector(6 downto 0);
signal ascii_char_temp : std_logic_vector(7 downto 0);


begin
	--clk_tlc <=

	state_generator : traffic_light_controller_fsm
		port map(clk_1hz, global_reset, car_sensor, tlc_state, tlc_timer, tlc_state_change);
				-- clk_1hz, global_reset, car_sensor, tlc_state, tlc_timer, tlc_state_change
	
	--<= tlc_timer --to 7seg in uart_fsm
	
	state_change_trim : pulse_length_trim 
		port map(clk_baud, global_reset, tlc_state_change, tlc_state_change_trimmed);
	
	message_compiler : traffic_light_controller_tx_message_compiler
		port map(tlc_state, tx_message);
		
	get_next_tx_char <= tdr_empty;
	
	message_buffer : tlc_tx_message_buffer
	 port map(tx_message, tlc_state_change_trimmed, global_reset, clk_baud, get_next_tx_char, ascii_char, buffer_empty, open);
			--  tx_message, load_message, 	 			global_reset, clk, 		next_char, 		   ascii_char, buffer_empty, ascii_chars
			
	ascii_char_temp(6 downto 0) <= ascii_char;
		ascii_char_temp(7) <= '0';
	
	
	message_transmitter : uart_tx_fsm
		port map(ascii_char_temp, not buffer_empty, clk, clk_baud, global_reset, tx, open,  open, open, tdr_empty, open);
				-- bus0, 			  bus_ready, 		  clk, clk_baud, global_reset, tx, i_cnt, tdr,  tsr,  tdr_empty, state 
	
end rtl;