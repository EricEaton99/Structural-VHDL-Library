-- nBit_mux4

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity nBit_mux4 is
generic ( n : positive := 4 );
port(
	in3, in2, in1, in0 : in std_logic_vector(n-1 downto 0);
	sel1, sel0 : in std_logic;
	out0 : out std_logic_vector(n-1 downto 0));
end nBit_mux4;

architecture rtl of nBit_mux4 is

-- conmponents
component nBit_mux2 is
	generic ( n : positive := 4 );
	port(
		in1, in0 : in std_logic_vector(n-1 downto 0);
		sel0 : in std_logic;
		out0 : out std_logic_vector(n-1 downto 0));
end component;

-- wires
signal sel0_mask, sel1_mask, mux0, mux1 : std_logic_vector(n-1 downto 0);

begin
	mux2_0x : nBit_mux2 generic map(n) port map(in1, in0, sel0, mux0);
	mux2_1x : nBit_mux2 generic map(n) port map(in3, in2, sel0, mux1);
	mux2_x : nBit_mux2 generic map(n) port map(mux1, mux0, sel1, out0);

--	sel0_mask <= (others => sel0);
--	sel1_mask <= (others => sel1);
--	
--	out0 <= ((not sel1_mask) and (not sel0_mask) and in0)
--			or ((not sel1_mask) and sel0_mask and in1)
--			or (sel1_mask and (not sel0_mask) and in2)
--			or (sel1_mask and sel0_mask and in3);
end rtl;