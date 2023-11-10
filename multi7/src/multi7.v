// displays multiple BCD digits on multiplexed seven segment displays
module multi7 #(
    parameter DIGITS = 4
) (
    i_clk,
    i_digits,
    o_segments_drive,
    o_displays_neg
);
    localparam FREQ = 27_000_000;
    localparam DELAY_US = 1000;
    localparam integer DELAY = FREQ * (DELAY_US / 1_000_000.0);

    localparam d_0 = 7'b0111111;
    localparam d_1 = 7'b0000110;
    localparam d_2 = 7'b1011011;
    localparam d_3 = 7'b1001111;
    localparam d_4 = 7'b1100110;
    localparam d_5 = 7'b1101101;
    localparam d_6 = 7'b1111101;
    localparam d_7 = 7'b0000111;
    localparam d_8 = 7'b1111111;
    localparam d_9 = 7'b1101111;

    input i_clk;

    // the decimal value of each digit
    // 10-15 will output nothing
    input [(DIGITS*4-1):0] i_digits;

    // 6543210
    // gfedcba
    output [6:0] o_segments_drive;
    output [(DIGITS-1):0] o_displays_neg;

    reg [$clog2(DELAY):0] r_tick = 0;
    reg [(DIGITS*7-1):0] r_displays_state;
    reg [$clog2(DIGITS):0] r_display_select = 0;
    reg [(DIGITS-1):0] r_displays_neg = ~1;
    reg [6:0] r_display_output;

    assign o_segments_drive = r_display_output;
    assign o_displays_neg = r_displays_neg;
    
    always @(posedge i_clk) begin
        if (r_tick == DELAY - 1) begin
            r_tick <= 0;
            r_displays_neg <= (r_displays_neg << 1) | r_displays_neg[DIGITS-1];

            if (r_display_select == DIGITS - 1) begin
                r_display_select <= 0;
            end else begin
                r_display_select <= r_display_select + 1;
            end
        end else begin
            r_tick <= r_tick + 1;
        end
    end
    
    generate
        for (genvar i = 0; i < DIGITS; i = i + 1) begin
            localparam TOP = i * 4 + 4 - 1;
            localparam BOTTOM = i * 4;
            localparam G = i * 7 + 7 - 1;
            localparam A = i * 7;

            always @(i_digits[(TOP):(BOTTOM)]) begin
                case (i_digits[(TOP):(BOTTOM)])
                    4'd0: r_displays_state[G:A] <= d_0;
                    4'd1: r_displays_state[G:A] <= d_1;
                    4'd2: r_displays_state[G:A] <= d_2;
                    4'd3: r_displays_state[G:A] <= d_3;
                    4'd4: r_displays_state[G:A] <= d_4;
                    4'd5: r_displays_state[G:A] <= d_5;
                    4'd6: r_displays_state[G:A] <= d_6;
                    4'd7: r_displays_state[G:A] <= d_7;
                    4'd8: r_displays_state[G:A] <= d_8;
                    4'd9: r_displays_state[G:A] <= d_9;
                    default: r_displays_state[G:A] <= 0;
                endcase
            end
        end
    endgenerate

    always @(r_displays_state or r_display_select) begin
        r_display_output <= r_displays_state >> (r_display_select * 7);     
    end
endmodule
