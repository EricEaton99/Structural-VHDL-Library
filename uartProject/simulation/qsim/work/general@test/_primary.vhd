library verilog;
use verilog.vl_types.all;
entity generalTest is
    port(
        clk_1hz         : out    vl_logic;
        clk             : in     vl_logic;
        global_reset    : in     vl_logic;
        baud_target     : in     vl_logic_vector(2 downto 0);
        tlc_state_change: out    vl_logic;
        clk_baud        : out    vl_logic;
        car_sensor      : in     vl_logic;
        tx              : out    vl_logic;
        state           : out    vl_logic;
        tdr_empty       : out    vl_logic;
        buffer_empty    : out    vl_logic;
        ascii_char      : out    vl_logic_vector(6 downto 0);
        ascii_chars     : out    vl_logic_vector(41 downto 0);
        i_cnt           : out    vl_logic_vector(3 downto 0);
        tdr             : out    vl_logic_vector(6 downto 0);
        tlc_state       : out    vl_logic_vector(1 downto 0);
        tlc_timer       : out    vl_logic_vector(3 downto 0);
        tsr             : out    vl_logic_vector(9 downto 0);
        tx_message      : out    vl_logic_vector(41 downto 0)
    );
end generalTest;
