

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity tlc_clock_generator is
port(
	clk, global_reset : in std_logic;
	baud_sel : in std_logic_vector(2 downto 0);
	clk_baud, clk_baud_eighth, clk_1hz : out std_logic);
end tlc_clock_generator;

architecture rtl of tlc_clock_generator is

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


-- wires
signal clk_div_41_at_target, clk_div_256_at_target, clk_div_150_at_target, clk_div_8_at_target, clk_baud_temp : std_logic;
signal clk_baud_total : std_logic_vector(7 downto 0);

begin	
		
	clk_div_41 : nBit_counter_sync_clear
		generic map (6)
		port map(clk, '1', global_reset, clk_div_41_at_target, "101000", clk_div_41_at_target, open);
	
	
	-- CHANGE THIS -- clk SHOULD BE clk_div_41_at_target ----------
	clk_div_256 : nBit_counter_sync_clear
		generic map(8)
		port map(clk_div_41_at_target, '1', global_reset, clk_div_256_at_target, "11111111", clk_div_256_at_target, clk_baud_total);
	
	baud_mux : mux8 port map(clk_baud_total, baud_sel, clk_baud_temp);
	clk_baud_eighth <= clk_baud_temp;
	
	clk_div_8 : nBit_counter_sync_clear
		generic map(3)
		port map(clk_baud_temp, '1', global_reset, clk_div_8_at_target, "111", clk_div_8_at_target, open);
	clk_baud <= clk_div_8_at_target;
		
	
	
	-- CHANGE THIS -- 00001010 SHOULD BE 10010110 ----------
	-- CHANGE THIS -- clk_baud_total(0) SHOULD BE clk_baud_total(7) ----------
	clk_div_150 : nBit_counter_sync_clear
		generic map(8)
		port map(clk_baud_total(7), '1', global_reset, clk_div_150_at_target, "10010110", clk_div_150_at_target, open);
	
	clk_1hz <= clk_div_150_at_target;
	
end rtl;