module top(
    i_clk,
    o_segments_drive,
    o_displays_neg
);
    parameter NUMBER = 'h5947;
    parameter DIGITS = 4;
    
    output [6:0] o_segments_drive;
    output [(DIGITS-1):0] o_displays_neg;

    input i_clk;
    
    multi7 #(
        .DIGITS(DIGITS)
    ) display (
        .i_clk(i_clk),
        .i_digits(NUMBER),
        .o_segments_drive(o_segments_drive),
        .o_displays_neg(o_displays_neg)
    );
endmodule