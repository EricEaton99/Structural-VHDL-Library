library verilog;
use verilog.vl_types.all;
entity generalTest_vlg_check_tst is
    port(
        ascii_char      : in     vl_logic_vector(6 downto 0);
        ascii_chars     : in     vl_logic_vector(41 downto 0);
        buffer_empty    : in     vl_logic;
        clk_1hz         : in     vl_logic;
        clk_baud        : in     vl_logic;
        i_cnt           : in     vl_logic_vector(3 downto 0);
        state           : in     vl_logic;
        tdr             : in     vl_logic_vector(6 downto 0);
        tdr_empty       : in     vl_logic;
        tlc_state       : in     vl_logic_vector(1 downto 0);
        tlc_state_change: in     vl_logic;
        tlc_timer       : in     vl_logic_vector(3 downto 0);
        tsr             : in     vl_logic_vector(9 downto 0);
        tx              : in     vl_logic;
        tx_message      : in     vl_logic_vector(41 downto 0);
        sampler_rx      : in     vl_logic
    );
end generalTest_vlg_check_tst;
