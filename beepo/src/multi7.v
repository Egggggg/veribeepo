// displays multiple BCD digits on multiplexed seven segment displays
module Multi7 #(
    parameter DISPLAYS = 4,
    parameter FREQ = 27_000_000,
    parameter DELAY_US = 5000,
    parameter integer DELAY = FREQ * (DELAY_US / 1_000_000.0),
    parameter ENABLE_HEX = 1,
    parameter ENABLE_CUSTOM = 0
) (
    i_clk,
    i_hex,
    i_custom,
    i_mode,     // if hex and custom are both enabled, 0 selects hex mode and 1 selects custom
    o_segments_drive,
    o_displays_neg
);

    localparam d_0 = 7'b1111110;
    localparam d_1 = 7'b0110000;
    localparam d_2 = 7'b1101101;
    localparam d_3 = 7'b1111001;
    localparam d_4 = 7'b0110011;
    localparam d_5 = 7'b1011011;
    localparam d_6 = 7'b1011111;
    localparam d_7 = 7'b1110000;
    localparam d_8 = 7'b1111111;
    localparam d_9 = 7'b1111011;
    localparam d_a = 7'b1110111;
    localparam d_b = 7'b0011111;
    localparam d_c = 7'b1001110;
    localparam d_d = 7'b0111101;
    localparam d_e = 7'b1001111;
    localparam d_f = 7'b1000111;

    input i_clk, i_mode;
    input [(ENABLE_HEX * (DISPLAYS*4-1)):0] i_hex;
    input [(ENABLE_CUSTOM * (DISPLAYS*7-1)):0] i_custom;

    // 6543210
    // gfedcba
    output [6:0] o_segments_drive;
    output [(DISPLAYS-1):0] o_displays_neg;

    reg [$clog2(DELAY):0] r_tick = 0;
    reg [(DISPLAYS*7-1):0] r_hex_state;
    reg [$clog2(DISPLAYS):0] r_display_select = 0;
    reg [(DISPLAYS-1):0] r_displays_neg = ~1;
    reg [6:0] r_display_output;

    assign o_segments_drive = r_display_output;
    assign o_displays_neg = r_displays_neg;
    
    always @(posedge i_clk) begin
        if (r_tick == DELAY - 1) begin
            r_tick <= 0;
            r_displays_neg <= (r_displays_neg << 1) | r_displays_neg[DISPLAYS-1];

            if (r_display_select == DISPLAYS - 1) begin
                r_display_select <= 0;
            end else begin
                r_display_select <= r_display_select + 1;
            end
        end else begin
            r_tick <= r_tick + 1;
        end
    end
    
    generate
        if (ENABLE_HEX) begin
            for (genvar i = 0; i < DISPLAYS; i = i + 1) begin
                localparam TOP = i * 4 + 4 - 1;
                localparam BOTTOM = i * 4;
                localparam G = i * 7 + 7 - 1;
                localparam A = i * 7;

                always @(i_hex[(TOP):(BOTTOM)]) begin
                    case (i_hex[(TOP):(BOTTOM)])
                        4'h0: r_hex_state[G:A] <= d_0;
                        4'h1: r_hex_state[G:A] <= d_1;
                        4'h2: r_hex_state[G:A] <= d_2;
                        4'h3: r_hex_state[G:A] <= d_3;
                        4'h4: r_hex_state[G:A] <= d_4;
                        4'h5: r_hex_state[G:A] <= d_5;
                        4'h6: r_hex_state[G:A] <= d_6;
                        4'h7: r_hex_state[G:A] <= d_7;
                        4'h8: r_hex_state[G:A] <= d_8;
                        4'h9: r_hex_state[G:A] <= d_9;
                        4'hA: r_hex_state[G:A] <= d_a;
                        4'hB: r_hex_state[G:A] <= d_b;
                        4'hC: r_hex_state[G:A] <= d_c;
                        4'hD: r_hex_state[G:A] <= d_d;
                        4'hE: r_hex_state[G:A] <= d_e;
                        4'hF: r_hex_state[G:A] <= d_f;
                    endcase
                end
            end
        end
    endgenerate

    generate
        if (ENABLE_HEX && ENABLE_CUSTOM) begin
            always @(r_hex_state or i_custom or i_mode or r_display_select)
                r_display_output <= (i_mode ? i_custom : r_hex_state) >> (r_display_select * 7);
        end else if (ENABLE_HEX) begin
            always @(r_hex_state or r_display_select)
                r_display_output <= r_hex_state >> (r_display_select * 7);
        end else if (ENABLE_CUSTOM) begin
            always @(i_custom or r_display_select)
                r_display_output <= i_custom >> (r_display_select * 7);
        end
    endgenerate
endmodule
