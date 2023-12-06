-- uart_rx_fsm

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity uart_rx_fsm is
port(
	 clk, clk_buad_eighth, global_reset, rx : in std_logic;
	 rdr : out std_logic_vector(6 downto 0);
	 rdr_ready, parity_error, framing_error : out std_logic);
end uart_rx_fsm;


	 
--	state_to_start_OUT,
--	state_to_read_OUT,
--	state_to_idle_OUT,
--	read_counter_reset_OUT  : out std_logic;
--	read_counter_target_OUT : out std_logic_vector(2 downto 0);
--	rsr_shift_or_load_OUT,
--	rsr_enable_OUT,
--	start_bit_at_end_of_rsr_OUT : out std_logic);

architecture rtl of uart_rx_fsm is

-- conmponents

component d_flipflop is
port(
	d, clk, en, preset, clear : in std_logic;
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

component nBit_mux2 is
	generic ( n : positive := 4 );
	port(
		in1, in0 : in std_logic_vector(n-1 downto 0);
		sel0 : in std_logic;
		out0 : out std_logic_vector(n-1 downto 0));
end component;


-- wires
signal state_to_start, state_to_read, state_to_idle, state_inc, 
		state_is_start, state_is_read, state_is_idle,
		state_counter_at_target, start_bit_at_end_of_rsr, rsr_shift_or_load, rsr_enable,
		read_counter_reset, read_counter_at_target,
		parity_expected, parity_is_correct: std_logic;
signal read_counter_target : std_logic_vector(2 downto 0); 
signal state_counter_total : std_logic_vector(1 downto 0);
signal rsr_out : std_logic_vector(9 downto 0);

begin
	
	
	-- State Counter -------------------------------------------
	
	
	state_counter : nBit_counter_sync_clear
		generic map(2)
		port map(clk_buad_eighth, state_inc, global_reset, state_counter_at_target, "10", state_counter_at_target, state_counter_total);
				-- clk, 				  en, 	 	 global_reset, clear_sync, 					target, at_target, 				total

	state_is_idle <= not state_counter_total(1) and not state_counter_total(0);
	state_is_start <= not state_counter_total(1) and state_counter_total(0);
	state_is_read <= state_counter_total(1) and not state_counter_total(0);
	
	state_to_start <= state_is_idle and not rx;
	state_to_read <= state_is_start and read_counter_at_target;
	state_to_idle <= start_bit_at_end_of_rsr;
	state_inc <= state_to_start or state_to_read or state_to_idle;
	
	
	-- Read Counter -------------------------------------------
	
	
	read_counter_reset <= state_to_start or state_to_read or (state_is_read and read_counter_at_target);
	read_target_mux : nBit_mux2 generic map(3) port map("111","011", state_is_read, read_counter_target);
	
	read_counter : nBit_counter_sync_clear
		generic map(3)
		port map(clk_buad_eighth, state_is_start or state_is_read, global_reset, read_counter_reset, read_counter_target, read_counter_at_target, open);
				-- clk, 					en, 										global_reset, clear_sync, 			target, 					at_target, 					total

	
	-- Rx Shift Register -------------------------------------------
				
	
	rsr_shift_or_load <= state_is_idle;
	rsr_enable <= read_counter_at_target or state_to_start;
				
	rsr_reg : nBit_PISO_reg 
			generic map(10) 
			port map("1111111111", rx, 		 rsr_shift_or_load, clk_buad_eighth, rsr_enable, global_reset,	'0', rsr_out, open);	--preset on global reset
					-- parallel_in,  serial_in, shift_load, 	 		clk, 				 en, 			 preset, 		clear, q, 	  q_not
	
	
	-- Rx Data Register -------------------------------------------
	
	
	start_bit_at_end_of_rsr <= not rsr_out(0);
	
	rdr_reg : nBit_PIPO_reg 
		generic map(7) 
		port map(rsr_out(7 downto 1), clk_buad_eighth, start_bit_at_end_of_rsr, global_reset, '0', rdr, open);	--preset on global reset
				--parallel_in, 			clk, 		 			en, 								preset, 		clear, q, 		q_not
	
	
	-- Rx flags -------------------------------------------
	
	
	p : parity_8Bit port map('0' & rsr_out(7 downto 1), '0', parity_expected);	--parity bit, odd parity
	parity_is_correct <= parity_expected xor rsr_out(8);
	parity_error_ff : d_flipflop port map(parity_is_correct, clk_buad_eighth, start_bit_at_end_of_rsr, '0', global_reset, parity_error, open);

	framing_error_ff : d_flipflop port map(not rsr_out(9), clk_buad_eighth, start_bit_at_end_of_rsr, '0', global_reset, framing_error, open);

	rdr_ready_ff : d_flipflop port map(start_bit_at_end_of_rsr, clk_buad_eighth, '1', '0', global_reset, rdr_ready, open);

end rtl;