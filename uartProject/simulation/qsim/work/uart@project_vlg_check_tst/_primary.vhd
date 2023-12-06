library verilog;
use verilog.vl_types.all;
entity uartProject_vlg_check_tst is
    port(
        clk_1hz         : in     vl_logic;
        clk_baud        : in     vl_logic;
        clk_baud_eighth : in     vl_logic;
        tlc_timer       : in     vl_logic_vector(3 downto 0);
        tx              : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end uartProject_vlg_check_tst;
