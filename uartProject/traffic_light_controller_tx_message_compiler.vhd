-- Message compiler
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity traffic_light_controller_tx_message_compiler is
port(
	 state : in std_logic_vector(1 downto 0);
	 tx_message : out std_logic_vector(7*6-1 downto 0));	--6 7-bit characters
end traffic_light_controller_tx_message_compiler;

architecture rtl of traffic_light_controller_tx_message_compiler is

-- conmponents
component nBit_mux4 is
generic ( n : positive := 4 );
port(
	in3, in2, in1, in0 : in std_logic_vector(n-1 downto 0);
	sel1, sel0 : in std_logic;
	out0 : out std_logic_vector(n-1 downto 0));
end component;

-- wires
signal M, underscore, S, char_ret, r, y, g, b4, b1 : std_logic_vector(6 downto 0);

begin
	-- states	|	byte(5-0)
	-- 00			|	"Mg_Sr\r"
	-- 01			|	"My_Sr\r"
	-- 10			|	"Mr_Sg\r"
	-- 11			|	"Mr_Sy\r"
	
	
	M <= "1001101";
	S <= "1010011";
	underscore <= "1011111";
	char_ret <= "0001101";
	r <= "1110010";
	y <= "1111001";
	g <= "1100111";
	
	b4_mux : nBit_mux4 generic map(7) port map(r, r, y, g, state(1), state(0), b4);
	b2_mux : nBit_mux4 generic map(7) port map(y, g, r, r, state(1), state(0), b1);
	
	tx_message(7*6-1 downto 7*5) <= M;	
	tx_message(7*5-1 downto 7*4) <= b4;
	tx_message(7*4-1 downto 7*3) <= underscore;
	tx_message(7*3-1 downto 7*2) <= S;
	tx_message(7*2-1 downto 7) <= b1;
	tx_message(7-1 downto 0) <= char_ret;
end rtl;