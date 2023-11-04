`include "../src/multi7.v"
`timescale 100ns/10ns

module tb_mulit7;
    parameter DIGITS = 8;

    reg i_clk_10mhz = 0;
    reg [DIGITS*4-1:0] i_digits = 'h12345678;
    wire [6:0] o_segments_drive;
    wire [DIGITS-1:0] o_displays_neg;

    always #0.5 i_clk_10mhz <= !i_clk_10mhz;

    multi7 #(
        .DIGITS (DIGITS)  
    ) driver (
        .i_clk_10mhz (i_clk_10mhz),
        .i_digits(i_digits),
        .o_segments_drive (o_segments_drive),
        .o_displays_neg (o_displays_neg)
    );

    initial $dumpvars(0, tb_multi7);
    initial #1000 $finish;
endmodule
