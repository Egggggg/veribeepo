`include "../src/top.v"
`timescale 100ns/10ns

module tb_ws2812;
    reg i_clk = 0;
    wire o_led;

    always #0.5 i_clk <= !i_clk;

    ws2812 led (
        .i_clk(i_clk),
        .o_led(o_led)
    );

    initial $dumpvars(0, tb_ws2812);
    initial #1000 $finish;
endmodule
