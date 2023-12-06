library verilog;
use verilog.vl_types.all;
entity rxTest is
    port(
        rdr_ready       : out    vl_logic;
        clk             : in     vl_logic;
        clk_buad_eighth : in     vl_logic;
        global_reset    : in     vl_logic;
        rx              : in     vl_logic;
        parity_error    : out    vl_logic;
        framing_error   : out    vl_logic;
        state_is_idle_OUT: out    vl_logic;
        state_is_start_OUT: out    vl_logic;
        state_is_read_OUT: out    vl_logic;
        rdr             : out    vl_logic_vector(6 downto 0);
        state_counter_total_OUT: out    vl_logic_vector(1 downto 0)
    );
end rxTest;
