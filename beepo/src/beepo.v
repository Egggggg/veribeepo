module beepo(
    i_clk,
    i_button_inc,
    i_button_dec,
    o_segments_drive,
    o_displays_neg
);
    parameter FREQ = 27_000_000;

    input i_clk;
    input i_button_inc;
    input i_button_dec;

    output [6:0] o_segments_drive;
    output [3:0] o_displays_neg;
    /*
        | 0     | startup               |
        | 1-2   | reading first byte    |
        | 3     | drawing               |
    */
    reg [2:0] r_state = 0;
    reg [7:0] r_instr = 8'h00;
    reg [11:0] r_addr = 12'h000;
    reg [15:0] r_number = 16'h0000;

    reg r_inc = 1'b0;
    reg r_dec = 1'b0;
    reg r_cycle = 1'b0;
    reg [11:0] r_new_addr = 12'h000;

    wire [7:0] w_instr;
    wire [11:0] w_addr = r_addr;
    wire [15:0] w_number = {r_addr[7:0], w_instr};

    progROM prom(
        .dout(w_instr), // output [7:0] dout
        .clk(i_clk),    // input clk
        .oce(0),    // input oce    (output clock enable, unused in bypass)
        .ce(1),     // input ce     (clock enable)
        .reset(0),  // input reset    (active high)
        .ad(w_addr) // input [11:0] ad
    );

    multi7 #(
        .DIGITS(4),
        .FREQ(FREQ)
    ) display (
        .i_clk(i_clk),
        .i_digits(w_number),
        .o_segments_drive(o_segments_drive),
        .o_displays_neg(o_displays_neg)
    );

    always @(posedge i_clk) begin
        if (r_cycle) r_state <= 0;
        
        if (r_state == 0) begin
            r_addr <= r_new_addr;
            r_number[15:8] <= r_addr[7:0];
        end

        if (r_state == 2) r_number[7:0] <= r_instr;
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
endmodule // beepo