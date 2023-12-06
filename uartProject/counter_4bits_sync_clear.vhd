-- counter_4bits_sync_clear

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity counter_4bits_sync_clear is
port(
	clk, en, global_reset, clear_sync : in std_logic;
	target : in std_logic_vector(3 downto 0);
	at_target : out std_logic;
	total : out std_logic_vector(3 downto 0));
end counter_4bits_sync_clear;

architecture rtl of counter_4bits_sync_clear is

-- conmponents
component nBit_reg is
	generic ( n : positive := 4 );
	port(
		parallel_in, preset, clear : in std_logic_vector(n-1 downto 0);		--preset, clear could be masks with preset = !clear
		clk, en : in std_logic;
		q, q_not: out std_logic_vector(n-1 downto 0));
end  component;

-- wires
signal en_temp, at_target_temp, not_clear_sync : std_logic;
signal parallel_in, q : std_logic_vector(3 downto 0);

begin
	en_temp <= en and (clear_sync or not at_target_temp);
	
	not_clear_sync <= not clear_sync;
	
	parallel_in(0) <= not_clear_sync and (not q(0));
	parallel_in(1) <= not_clear_sync and (q(1) xor q(0));
	parallel_in(2) <= not_clear_sync and (q(2) xor (q(1) and q(0)));
	parallel_in(3) <= not_clear_sync and (q(3) xor (q(2) and q(1) and q(0)));
	
	counter_reg : nBit_reg 
		generic map(4)
		port map(parallel_in, "0000", (others => global_reset), clk, en_temp, q, open);
		
	at_target_temp <= '1' when (q = target) else '0';	-- this is andn for all r(i) <= (q[i] xor not target[i]) 
	
	at_target <= at_target_temp;
	total <= q;
	
end rtl;