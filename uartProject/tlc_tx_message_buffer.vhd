-- tlc_tx_message_buffer

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


entity tlc_tx_message_buffer is
port(
	 tx_message : in std_logic_vector(7*6-1 downto 0);
	 load_message, global_reset, clk, next_char : in std_logic;
	 ascii_char : out std_logic_vector(6 downto 0);
	 buffer_empty : out std_logic;
	 ascii_chars : out std_logic_vector(7*6-1 downto 0));
end tlc_tx_message_buffer;

architecture rtl of tlc_tx_message_buffer is

-- conmponents
component nChar_acsii7_shift_reg is
generic ( n : positive := 6 );
port(
	parallel_in : in std_logic_vector(n*7-1 downto 0);		--preset, clear could be masks with preset = !clear
	char_in : in std_logic_vector(6 downto 0);		--preset, clear could be masks with preset = !clear
	global_reset, clk, en, shift_load_high : in std_logic;
	parallel_out : out std_logic_vector(n*7-1 downto 0);
	char_out: out std_logic_vector(6 downto 0));
end component;

-- wires
signal ascii_reg_en, buffer_empty_temp : std_logic;
signal null_char, ascii_char_temp : std_logic_vector(6 downto 0);
signal ascii_chars_temp : std_logic_vector(6*7-1 downto 0);

begin
	null_char <= "0000000";
	ascii_reg_en <= (load_message and buffer_empty_temp) or (next_char and not buffer_empty_temp);
	
	ascii_reg : nChar_acsii7_shift_reg
		generic map(6)
		port map(tx_message, null_char, global_reset, clk, ascii_reg_en, buffer_empty_temp, ascii_chars_temp,  ascii_char_temp);
		--			parallel_in, char_in,  global_reset, clk, en, 				shift_load_high, parallel_out, char_out
		
	
	buffer_empty_temp <= '1' when (ascii_char_temp = null_char) else '0';
	
	buffer_empty <= buffer_empty_temp;
	ascii_chars <= ascii_chars_temp;
	ascii_char <= ascii_chars_temp(6 downto 0);
	
end rtl;