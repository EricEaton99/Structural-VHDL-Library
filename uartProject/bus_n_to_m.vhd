-- bus_n_to_m

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity bus_n_to_m is
generic ( n : positive := 6; m : positive := 7);
port(
	bus_in : in std_logic_vector(n-1 downto 0);
	fill : in std_logic;
	bus_out: out std_logic_vector(m-1 downto 0));
end bus_n_to_m;

architecture rtl of bus_n_to_m is

-- conmponents
--none

-- wires
signal fill_vector : std_logic_vector(m-n-1 downto 0);
	

begin	
	fill_vector <= (others => fill);
	bus_out(n-1 downto 0) <= bus_in;
	bus_out(m-1 downto n) <= fill_vector;
	
end rtl;