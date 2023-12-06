-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"

-- DATE "11/21/2023 16:38:48"

-- 
-- Device: Altera EP4CGX15BF14C6 Package FBGA169
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY CYCLONEIV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIV.CYCLONEIV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	uartProject IS
    PORT (
	q : OUT std_logic;
	j : IN std_logic;
	k : IN std_logic;
	clk : IN std_logic;
	en : IN std_logic;
	preset : IN std_logic;
	clear : IN std_logic;
	q_not : OUT std_logic
	);
END uartProject;

-- Design Ports Information
-- q	=>  Location: PIN_L4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- q_not	=>  Location: PIN_M4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- preset	=>  Location: PIN_L5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clear	=>  Location: PIN_N4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- j	=>  Location: PIN_N6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- k	=>  Location: PIN_M6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- en	=>  Location: PIN_N8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_L7,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF uartProject IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_q : std_logic;
SIGNAL ww_j : std_logic;
SIGNAL ww_k : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_en : std_logic;
SIGNAL ww_preset : std_logic;
SIGNAL ww_clear : std_logic;
SIGNAL ww_q_not : std_logic;
SIGNAL \q~output_o\ : std_logic;
SIGNAL \q_not~output_o\ : std_logic;
SIGNAL \preset~input_o\ : std_logic;
SIGNAL \clear~input_o\ : std_logic;
SIGNAL \inst|t_q~1_combout\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \en~input_o\ : std_logic;
SIGNAL \k~input_o\ : std_logic;
SIGNAL \j~input_o\ : std_logic;
SIGNAL \inst|t_q~5_combout\ : std_logic;
SIGNAL \inst|t_q~3_combout\ : std_logic;
SIGNAL \inst|t_q~0_combout\ : std_logic;
SIGNAL \inst|t_q~_emulated_q\ : std_logic;
SIGNAL \inst|t_q~2_combout\ : std_logic;
SIGNAL \inst|ALT_INV_t_q~0_combout\ : std_logic;
SIGNAL \inst|ALT_INV_t_q~2_combout\ : std_logic;

BEGIN

q <= ww_q;
ww_j <= j;
ww_k <= k;
ww_clk <= clk;
ww_en <= en;
ww_preset <= preset;
ww_clear <= clear;
q_not <= ww_q_not;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\inst|ALT_INV_t_q~0_combout\ <= NOT \inst|t_q~0_combout\;
\inst|ALT_INV_t_q~2_combout\ <= NOT \inst|t_q~2_combout\;

-- Location: IOOBUF_X8_Y0_N9
\q~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|t_q~2_combout\,
	devoe => ww_devoe,
	o => \q~output_o\);

-- Location: IOOBUF_X8_Y0_N2
\q_not~output\ : cycloneiv_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst|ALT_INV_t_q~2_combout\,
	devoe => ww_devoe,
	o => \q_not~output_o\);

-- Location: IOIBUF_X14_Y0_N8
\preset~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_preset,
	o => \preset~input_o\);

-- Location: IOIBUF_X10_Y0_N8
\clear~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clear,
	o => \clear~input_o\);

-- Location: LCCOMB_X13_Y1_N24
\inst|t_q~1\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|t_q~1_combout\ = (!\clear~input_o\ & ((\preset~input_o\) # (\inst|t_q~1_combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111100001010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \preset~input_o\,
	datac => \clear~input_o\,
	datad => \inst|t_q~1_combout\,
	combout => \inst|t_q~1_combout\);

-- Location: IOIBUF_X14_Y0_N1
\clk~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: IOIBUF_X20_Y0_N8
\en~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_en,
	o => \en~input_o\);

-- Location: IOIBUF_X12_Y0_N8
\k~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_k,
	o => \k~input_o\);

-- Location: IOIBUF_X12_Y0_N1
\j~input\ : cycloneiv_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_j,
	o => \j~input_o\);

-- Location: LCCOMB_X13_Y1_N28
\inst|t_q~5\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|t_q~5_combout\ = (\inst|t_q~2_combout\ & (!\k~input_o\)) # (!\inst|t_q~2_combout\ & ((\j~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101010111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \k~input_o\,
	datac => \j~input_o\,
	datad => \inst|t_q~2_combout\,
	combout => \inst|t_q~5_combout\);

-- Location: LCCOMB_X13_Y1_N12
\inst|t_q~3\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|t_q~3_combout\ = \inst|t_q~1_combout\ $ (((\en~input_o\ & ((\inst|t_q~5_combout\))) # (!\en~input_o\ & (\inst|t_q~2_combout\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011011010011100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \en~input_o\,
	datab => \inst|t_q~1_combout\,
	datac => \inst|t_q~2_combout\,
	datad => \inst|t_q~5_combout\,
	combout => \inst|t_q~3_combout\);

-- Location: LCCOMB_X13_Y1_N30
\inst|t_q~0\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|t_q~0_combout\ = (\clear~input_o\) # (\preset~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \clear~input_o\,
	datad => \preset~input_o\,
	combout => \inst|t_q~0_combout\);

-- Location: FF_X13_Y1_N13
\inst|t_q~_emulated\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \inst|t_q~3_combout\,
	clrn => \inst|ALT_INV_t_q~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|t_q~_emulated_q\);

-- Location: LCCOMB_X13_Y1_N2
\inst|t_q~2\ : cycloneiv_lcell_comb
-- Equation(s):
-- \inst|t_q~2_combout\ = (!\clear~input_o\ & ((\preset~input_o\) # (\inst|t_q~1_combout\ $ (\inst|t_q~_emulated_q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000101100001110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \preset~input_o\,
	datab => \inst|t_q~1_combout\,
	datac => \clear~input_o\,
	datad => \inst|t_q~_emulated_q\,
	combout => \inst|t_q~2_combout\);

ww_q <= \q~output_o\;

ww_q_not <= \q_not~output_o\;
END structure;


