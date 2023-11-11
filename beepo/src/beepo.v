module Beepo(
    i_clk,
    i_button_inc,
    i_button_dec,
    o_segments_drive,
    o_displays_neg
);
    parameter DISPLAYS = 4;
    parameter DIGITS = 9;
    parameter FREQ = 27_000_000;
//    parameter FULL_HEX = 'hdeadbeef5;
//    parameter FULL_CUSTOM = {7'b1100011, 7'b0011110, 7'b0111100, 7'b1100011, 7'b0011110, 7'b0111100, 7'b1100011, 7'b0011110, 7'b0111100};

    input i_clk;
    input i_button_inc;
    input i_button_dec;

    output [6:0] o_segments_drive;
    output [3:0] o_displays_neg;

    /*
        | 0     | startup       |
        | 1-2   | reading byte  |
        | 3     | drawing       |
    */
     reg [2:0] r_state = 0;
     reg [7:0] r_instr = 8'h00;
     reg [11:0] r_addr = 12'h000;

     reg r_inc = 1'b0;
     reg r_dec = 1'b0;
     reg r_cycle = 1'b0;
     reg [11:0] r_new_addr = 12'h000;

    reg r_mode = 1'b0;
    reg [1:0] r_state = 2'b00;
    reg r_shift = 1'b1;
    reg r_switched = 1'b0;

    wire [7:0] w_instr;
    wire [11:0] w_addr = r_addr;
//    wire [(4*DISPLAYS-1):0] w_hex;
//    wire [(7*DISPLAYS-1):0] w_custom;
//    wire w_mode = r_mode;
//    wire w_shift = r_shift;
//    wire [(7*DIGITS-1):0] w_full = r_mode ? FULL_CUSTOM : FULL_HEX;
    wire [(4*DISPLAYS-1):0] w_full = {w_addr[7:0], r_instr[7:0]};

    progROM prom(
        .dout(w_instr), // output [7:0] dout
        .clk(i_clk),    // input clk
        .oce(0),    // input oce    (output clock enable, unused in bypass)
        .ce(1),     // input ce     (clock enable)
        .reset(0),  // input reset    (active high)
        .ad(w_addr) // input [11:0] ad
    );

//    Scroll #(
//        .DISPLAYS(DISPLAYS),
//        .DIGITS(DIGITS),
//        .FREQ(FREQ),
//        .DELAY_MS(300),
//        .ENABLE_HEX(1),
//        .ENABLE_CUSTOM(1)
//    ) controller (
//        .i_clk(i_clk),
//        .i_full(w_full),
//        .i_shift(w_shift),
//        .i_enable(1'b1),
//        .i_mode(w_mode),
//        .o_shown_hex(w_hex),
//        .o_shown_custom(w_custom)
//    );

    Multi7 #(
        .DISPLAYS(DISPLAYS),
        .FREQ(FREQ),
        .ENABLE_HEX(1)
//        .ENABLE_CUSTOM(1)
    ) display (
        .i_clk(i_clk),
        .i_hex(w_full),
//        .i_custom(w_custom),
//        .i_mode(w_mode),
        .o_segments_drive(o_segments_drive),
        .o_displays_neg(o_displays_neg)
    );

//    always @(posedge i_clk) begin
//        case (r_state)
//            0: begin
//                r_mode <= 0;
//                r_shift <= 0;
//                r_state <= 1;
//            end
//            1: begin
//                r_mode <= 1;
//                r_shift <= 1;
//                r_state <= 2;
//            end
//        endcase

//        if (i_button_inc) begin
//            if (!r_switched) begin
//                r_mode <= !r_mode;
//                r_switched <= 1;
//            end
//        end else r_switched <= 0;
//    end

    always @(posedge i_clk) begin
        if (r_cycle) r_state <= 0;
        
        if (r_state == 0) begin
            r_addr <= r_new_addr;
        end

//        if (r_state == 2) [7:0] <= r_number[7:0] <= r_instr;
        if (r_state < 3) r_state <= r_state + 1;
    end

    always @(posedge i_clk) begin
        if (r_cycle) r_cycle <= 0;

        if (i_button_inc && !r_inc) begin
            r_new_addr <= r_addr + 1;
            r_inc <= 1;
            r_cycle <= 1;
        end else if (!i_button_inc && r_inc) begin
            r_inc <= 0;
        end
        
        if (i_button_dec && !r_dec) begin
            r_new_addr <= r_addr - 1;
            r_dec <= 1;
            r_cycle <= 1;
        end else if (!i_button_dec && r_dec) begin
            r_dec <= 0;
        end
    end

    always @(w_instr) r_instr <= w_instr;
endmodule // Beepo