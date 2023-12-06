library verilog;
use verilog.vl_types.all;
entity uartProject is
    port(
        clk_1hz         : out    vl_logic;
        clk             : in     vl_logic;
        global_reset    : in     vl_logic;
        baud_target     : in     vl_logic_vector(2 downto 0);
        clk_baud        : out    vl_logic;
        clk_baud_eighth : out    vl_logic;
        tx              : out    vl_logic;
        car_sensor      : in     vl_logic;
        tlc_timer       : out    vl_logic_vector(3 downto 0)
    );
end uartProject;
