library verilog;
use verilog.vl_types.all;
entity uartProject_vlg_sample_tst is
    port(
        baud_target     : in     vl_logic_vector(2 downto 0);
        car_sensor      : in     vl_logic;
        clk             : in     vl_logic;
        global_reset    : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end uartProject_vlg_sample_tst;
