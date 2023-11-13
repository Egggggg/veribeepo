module Beepo(
    i_clk,
    i_button1,
    i_button2,
    o_segments_drive,
    o_displays_neg
);
    parameter DISPLAYS = 4;
    parameter FREQ = 27_000_000;

    localparam STATE_FETCHING   = 'bzz1;
    localparam STATE_NEEDS_ARG  = 'bz1z;
    localparam STATE_EXECUTING  = 'b1zz;

    localparam INSTR_NO_ARG = 8'bzzz00000;

    input i_clk;
    input i_button1;
    input i_button2;

    output [6:0] o_segments_drive;
    output [3:0] o_displays_neg;

    reg [1:0] r_fetching    = 0;
    reg [1:0] r_needs_arg   = 0;
    reg [1:0] r_executing   = 0;
    reg [2:0] r_state;

    always @(*) begin
        r_state <= {
            r_executing[1] ^ r_executing[0],
            r_needs_arg[1] ^ r_needs_arg[0],
            r_fetching[1]  ^ r_fetching[0]
        };
    end

    reg [7:0] r_instr = 8'h00;
    reg [8:0] r_arg = 8'h00;
    reg [11:0] r_pc = 12'h000;
    reg [11:0] r_prom_addr = 12'h000;
    reg [(4*DISPLAYS-1):0] r_shown;

    wire [7:0] w_prom_rx;
    wire [11:0] w_prom_addr = r_prom_addr;
    wire [(4*DISPLAYS-1):0] w_shown = r_shown;

    always @(posedge i_clk) begin
        if (r_state == STATE_NEEDS_ARG) begin
            
        end
    end

    always @(w_prom_rx) begin
        if (r_state == STATE_NEEDS_ARG) begin
            r_arg <= w_prom_rx;
            r_needs_arg[0] <= ~r_needs_arg[0]; 
            r_pc <= r_pc + 1;
        end else if (r_state == STATE_FETCHING) begin
            r_instr <= w_prom_rx;
            r_pc <= r_pc + 1;
        end
    end

    always @(r_instr) begin
        if (r_instr != INSTR_NO_ARG) begin
            r_needs_arg[1] <= ~r_needs_arg[1];
        end
    end

    always @(negedge r_needs_arg)

    progROM prom(
        .dout(w_prom_rx), // output [7:0] dout
        .clk(i_clk),    // input clk
        .oce(0),    // input oce    (output clock enable, unused in bypass)
        .ce(1),     // input ce     (clock enable)
        .reset(0),  // input reset  (active high)
        .ad(w_prom_addr)   // input [11:0] ad
    );

    Multi7 #(
        .DISPLAYS(DISPLAYS),
        .FREQ(FREQ),
        .ENABLE_HEX(1),
        .ENABLE_CUSTOM(0)
    ) display (
        .i_clk(i_clk),
        .i_hex(w_shown),
        .o_segments_drive(o_segments_drive),
        .o_displays_neg(o_displays_neg)
    );
endmodule // Beepo