module ws2812(
    i_clk,
    o_led
);
    input i_clk;
    output o_led;

    localparam TICKS_ON = 100;
    localparam TICKS_TOTAL = 100;

    localparam TICKS_OFF = TICKS_TOTAL - TICKS_ON;
    localparam ENABLE = TICKS_OFF - 1;
    localparam DISABLE = ENABLE + TICKS_ON;

    reg [$clog2(TICKS_ON + TICKS_OFF - 1):0] r_tick = 0;
    reg r_led = 1'b0;

    assign o_led = 1;

    always @(posedge i_clk) begin
        if (r_tick == DISABLE) begin
            r_led <= 0;
            r_tick <= 0;
        end else begin
            if (r_tick == ENABLE) begin
                r_led <= 1;
            end

            r_tick <= r_tick + 1;
        end
    end
endmodule