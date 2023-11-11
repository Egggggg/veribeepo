module top(
    i_clk,
    // i_down_button,
    // i_up_button,
    o_segments_drive,
    o_displays_neg
);
    parameter DISPLAYS = 4;
    parameter FREQ = 27_000_000;
    parameter DELAY_MS = 300;
    parameter integer DELAY = FREQ * (DELAY_MS / 1000.0);
    parameter DIGITS = 18;
    parameter SCROLL = 1;

    parameter NUMBER_TOP = 4 * DISPLAYS - 1;
    parameter FULL_TOP = 4 * DIGITS - 1;

    input i_clk;
    // input i_down_button;
    // input i_up_button;

    output [6:0] o_segments_drive;
    output [(DISPLAYS-1):0] o_displays_neg;

    reg [$clog2(DELAY):0] r_tick = 0;
    reg [FULL_TOP:0] r_number = 'hbea04ca55e123e4444;
//    reg [FULL_TOP:0] r_number = 'hbea0;

    wire [(NUMBER_TOP):0] w_number = r_number[FULL_TOP:FULL_TOP-NUMBER_TOP];

    // counter #(
    //     .DIGITS(DISPLAYS),
    //     .FREQ(FREQ)
    // ) count (
    //     .i_clk(i_clk),
    //     .i_down_button(i_down_button),
    //     .i_up_button(i_up_button),
    //     .o_number(w_number)
    // );

    multi7 #(
        .DIGITS(DISPLAYS),
        .FREQ(FREQ)
    ) display (
        .i_clk(i_clk),
        .i_digits(w_number),
        .o_segments_drive(o_segments_drive),
        .o_displays_neg(o_displays_neg)
    );

    if (SCROLL)
        always @(posedge i_clk) begin
            if (r_tick == DELAY) begin
                r_number <= (r_number << 4) | (r_number[FULL_TOP:FULL_TOP-3]);
                r_tick <= 0;
            end else r_tick <= r_tick + 1;
        end
endmodule