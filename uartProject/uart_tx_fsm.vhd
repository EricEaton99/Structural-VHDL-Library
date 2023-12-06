

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity uart_tx_fsm is
port(
	bus0 : in std_logic_vector(7 downto 0);
	bus_ready, clk, clk_baud, global_reset : in std_logic;
	tx : out std_logic;
	i_cnt : out std_logic_vector(3 downto 0);
	tdr : out std_logic_vector(6 downto 0);
	tsr : out std_logic_vector(9 downto 0);
	tdr_empty, state : out std_logic);
end uart_tx_fsm;

architecture rtl of uart_tx_fsm is

-- conmponents

component t_flipflop is
port(
	t, clk, en, preset, clear : in std_logic;
	q, q_not: out std_logic);
end component;

component nBit_PIPO_reg is
generic ( n : positive := 4 );
port(
	parallel_in : in std_logic_vector(n-1 downto 0);
	clk, en, preset, clear : in std_logic;
	q, q_not: out std_logic_vector(n-1 downto 0));
end component;

component nBit_PISO_reg is
generic ( n : positive := 4 );
port(
	parallel_in : in std_logic_vector(n-1 downto 0);		--preset, clear could be masks with preset = !clear
	serial_in, shift_load, clk, en, preset, clear : in std_logic;
	q, q_not: out std_logic_vector(n-1 downto 0));
end component;

component parity_8Bit is
port(
	in0 : in std_logic_vector(7 downto 0);
	even_odd_low : in std_logic;
	parity : out std_logic);
end component;

component nBit_counter_sync_clear is
generic ( n : positive := 4 );
port(
	clk, en, global_reset, clear_sync : in std_logic;
	target : in std_logic_vector(n-1 downto 0);
	at_target : out std_logic;
	total : out std_logic_vector(n-1 downto 0));
end component;

-- wires
signal tdr_out : std_logic_vector(6 downto 0);
signal tsr_in, tsr_out : std_logic_vector(9 downto 0);
signal tdr_empty_temp, tdr_to_empty, tdr_to_full, tdr_read : std_logic;
signal tsr_shift_or_load, tsr_enable : std_logic;
signal state_idle_stift, state_toggle, state_to_shift, state_to_idle : std_logic;
signal shift_counter_at_target, shift_counter_clear : std_logic;

begin	
	-- there are 2 concurrent processes: tdr and tsr
	-- tdr only does 2 things:
	--		1. if tdr is empty and the bus is ready, tdr becomes full (loaded and set to full)
	--		2. if tdr is full and is read, tdr becomes empty
	-- tsr has 2 states: idle and shift
	--		-1. stay in idle while tdr is empty
	--		2. go to shift when tdr is not empty. Enable the shift counter, reset the shift counter, and load tsr during this transition
	--		-3. stay in shift while the shift count is less than the target value. Enable the shift counter
	--		4. go to idle when the shift ccounter is at the target value. Disable the counter
	-- and  
	
	
	-- 	tdr
	--if(tdr_empty_temp and bus_ready) tdr_empty_temp <= '0';
	--if(not tdr_empty_temp and tdr_read) tdr_empty_temp <= '1';	
	tdr_to_empty <= not tdr_empty_temp and tdr_read;
	tdr_to_full <= tdr_empty_temp and bus_ready;
	tdr_empty_temp_ff : t_flipflop port map(tdr_to_empty or tdr_to_full, clk_baud, '1', global_reset, '0', tdr_empty_temp, open);
	
	tdr_reg : nBit_PIPO_reg generic map(7) port map(bus0(6 downto 0), clk_baud, tdr_to_full, global_reset, '0', tdr_out, open);	--preset on global reset

	
	-- 	tsr
	
	-- 	state
	--if(not state_idle_stift and not tdr_empty_temp) state_idle_stift <= '1'
	--if(state_idle_stift and shift_counter_at_target) state_idle_stift <= '0'
	tx_state : t_flipflop port map(state_to_shift or state_to_idle, clk_baud, '1', '0', global_reset, state_idle_stift, open);
	
	
	-- 	flags
	-- go to shift when tdr is not empty. Enable the shift counter, reset the shift counter, and load tsr during this transition
	state_to_idle <= state_idle_stift and shift_counter_at_target;
	state_to_shift <= not state_idle_stift and not tdr_empty_temp;
	
	tsr_enable <= state_idle_stift or state_to_shift;	
	shift_counter_clear <= state_to_shift;
	tsr_shift_or_load <= not state_idle_stift;
	tdr_read <= state_to_shift;
	
	-- tsr parallel input
	tsr_in(9) <= '1';		--stop bit
	p : parity_8Bit port map('0' & tdr_out, '0', tsr_in(8));	--parity bit, odd parity
	tsr_in(7 downto 1) <= tdr_out;		--data
	tsr_in(0) <= '0';		--start bit
	
	tsr_reg : nBit_PISO_reg generic map(10) port map(
				tsr_in, 
				'1', tsr_shift_or_load, clk_baud, tsr_enable, global_reset, '0', 
				tsr_out, open);	--preset on global reset
	shift_counter : nBit_counter_sync_clear generic map(4) port map(clk_baud, tsr_enable, global_reset, shift_counter_clear, "1001", shift_counter_at_target, i_cnt);	--1010 is 10 bits in tsr_out 
																					--  clk, 	  en, 		  global_reset, clear_sync, 			 target, at_target, 					 total
	
	tx <= tsr_out(0);
	--debugging
	tdr <= tdr_out;
	tsr <= tsr_out;
	tdr_empty <= tdr_empty_temp;
	state <= state_idle_stift;
end rtl;