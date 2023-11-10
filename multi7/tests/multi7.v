`include "../src/multi7.v"
`timescale 100ns/10ns

module tb_multi7;
    parameter DIGITS = 4;

    reg i_clk = 0;
    reg [DIGITS*4-1:0] i_digits = 'h1234;
    wire [6:0] o_segments_drive;
    wire [DIGITS-1:0] o_displays_neg;

    always #0.5 i_clk <= !i_clk;

    multi7 #(
        .DIGITS (DIGITS)  
    ) driver (
        .i_clk (i_clk),
        .i_digits(i_digits),
        .o_segments_drive (o_segments_drive),
        .o_displays_neg (o_displays_neg)
    );

    initial $dumpvars(0, tb_multi7);
    initial #1000 $finish;
endmodule
