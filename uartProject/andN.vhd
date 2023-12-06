-- andN

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity andN is
generic (n : positive := 4);
port(
	inN : in std_logic_vector(n-1 downto 0);
	anded : out std_logic);
end andN;

architecture rtl of andN is

-- conmponents
--none

-- wires
signal one : std_logic_vector(n-1 downto 0);

begin
	one <= (others => '1');
	anded <= '1' when (inN = one) else '0';
end rtl;