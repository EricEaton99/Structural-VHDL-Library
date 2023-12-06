-- nBit_counter_sync_clear

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity nBit_counter_sync_clear is
generic ( n : positive := 4 );
port(
	clk, en, global_reset, clear_sync : in std_logic;
	target : in std_logic_vector(n-1 downto 0);
	at_target : out std_logic;
	total : out std_logic_vector(n-1 downto 0));
end nBit_counter_sync_clear;

architecture rtl of nBit_counter_sync_clear is

-- conmponents
component nBit_reg is
	generic ( n : positive := 4 );
	port(
		parallel_in, preset, clear : in std_logic_vector(n-1 downto 0);		--preset, clear could be masks with preset = !clear
		clk, en : in std_logic;
		q, q_not: out std_logic_vector(n-1 downto 0));
end  component;

component andN is
generic (n : positive := 4);
port(
	inN : in std_logic_vector(n-1 downto 0);
	anded : out std_logic);
end component;

-- wires
signal en_temp, at_target_temp, not_clear_sync : std_logic;
signal previous_bits_anded, parallel_in, q : std_logic_vector(n-1 downto 0);

begin
	en_temp <= en and (clear_sync or not at_target_temp);
	
	not_clear_sync <= not clear_sync;
	
	parallel_in(0) <= not_clear_sync and (not q(0));
	
	loop0: for i in 1 to n-1 generate
		andN_i : andN generic map(i) port map(q(i-1 downto 0), previous_bits_anded(i));
		parallel_in(i) <= not_clear_sync and (q(i) xor previous_bits_anded(i));
	end generate;
	
	counter_reg : nBit_reg 
		generic map(n)
		port map(parallel_in, (others => '0'), (others => global_reset), clk, en_temp, q, open);
		
	at_target_temp <= '1' when (q = target) else '0';	-- this is andn for all r(i) <= (q[i] xor not target[i]) 
	
	at_target <= at_target_temp;
	total <= q;
	
end rtl;