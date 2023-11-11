module Counter#(
    parameter DIGITS = 4,
    parameter FREQ = 27_000_000,
    parameter DELAY_MS = 300,
    parameter integer DELAY = FREQ * (DELAY_MS / 1000.0)
) (
    i_clk,
    i_down_button,
    i_up_button,
    o_number
);
    reg [(4*DIGITS-1):0] r_number = 0;
    reg [$clog2(DELAY):0] r_tick = 0;
    reg [3:0] r_inc = 0;
    reg [3:0] r_dec = 0;
    reg op = 0; // this is 0 for addition and 1 for subtraction
    reg [2:0] sub = 3'b000; // sub.0 gets flipped on button negedge, sub.1 gets flipped on posedge, sub.2 is (0 ^ 1)
    reg [2:0] add = 3'b000; // same as sub

    input i_clk;
    input i_down_button;
    input i_up_button;

    output [(4*DIGITS-1):0] o_number;

    assign o_number = r_number;

    always @(posedge i_clk)
        if (r_tick == DELAY) begin
            if (op == 0) r_number <= r_number + r_inc + 1;
            else if (op == 1) r_number <= r_number - (r_dec + 1);
            r_tick <= 0;
        end else begin
            r_tick <= r_tick + 1;
        end

    // numbers are hard
    always @(posedge i_clk) op <= sub[2] ^ add[2] == 1 ? sub[2] : op;
    always @(posedge i_clk) add[2] = add[0] ^ add[1];
    always @(posedge i_clk) sub[2] = sub[0] ^ sub[1];

    always @(posedge i_down_button)
        if (op == 0) begin
            sub[1] = ~sub[1];
            r_dec <= 0;
        end else if (r_dec < 15) r_dec = r_dec + 1;

    always @(negedge i_down_button) sub[0] <= ~sub[0];

    always @(posedge i_up_button)
        if (op == 1) begin
            add[1] = ~add[1];
            r_inc <= 0;
        end else if (r_inc < 15) r_inc = r_inc + 1;

    always @(negedge i_up_button) add[0] <= ~add[0];
endmodule