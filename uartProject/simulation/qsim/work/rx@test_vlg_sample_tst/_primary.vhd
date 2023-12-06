library verilog;
use verilog.vl_types.all;
entity rxTest_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        clk_buad_eighth : in     vl_logic;
        global_reset    : in     vl_logic;
        rx              : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end rxTest_vlg_sample_tst;
