library verilog;
use verilog.vl_types.all;
entity rxTest_vlg_check_tst is
    port(
        framing_error   : in     vl_logic;
        parity_error    : in     vl_logic;
        rdr             : in     vl_logic_vector(6 downto 0);
        rdr_ready       : in     vl_logic;
        state_counter_total_OUT: in     vl_logic_vector(1 downto 0);
        state_is_idle_OUT: in     vl_logic;
        state_is_read_OUT: in     vl_logic;
        state_is_start_OUT: in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end rxTest_vlg_check_tst;
