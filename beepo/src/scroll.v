module Scroll #(
    parameter DISPLAYS = 4,
    parameter DIGITS = 4,
    parameter FREQ = 27_000_000,
    parameter DELAY_MS = 300,
    parameter integer DELAY = FREQ * (DELAY_MS / 1000.0),
    parameter ENABLE_HEX = 1,
    parameter ENABLE_CUSTOM = 0
) (
    i_clk,
    i_full,     // full display data input
    i_shift,    // pull high to shift in new display data
    i_enable,   // whether scrolling should be enabled
    i_mode,     // if hex and custom are both enabled, 0 for hex and 1 for custom
    o_shown_hex,    // the hex display data currently in view
    o_shown_custom  // the custom display data currently in view
);
    localparam HEX_SHOWN_TOP = ENABLE_HEX ? 4 * DISPLAYS - 1 : 0;
    localparam HEX_FULL_TOP = ENABLE_HEX ? 4 * DIGITS - 1 : 0;
    localparam CUSTOM_SHOWN_TOP = ENABLE_CUSTOM ? 7 * DISPLAYS - 1 : 0;
    localparam CUSTOM_FULL_TOP = ENABLE_CUSTOM ? 7 * DIGITS - 1 : 0;
    localparam FULL_TOP = HEX_FULL_TOP > CUSTOM_FULL_TOP ? HEX_FULL_TOP : CUSTOM_FULL_TOP;

    input i_clk, i_shift, i_enable, i_mode;
    input [FULL_TOP:0] i_full;

    output [HEX_SHOWN_TOP:0] o_shown_hex;
    output [CUSTOM_SHOWN_TOP:0] o_shown_custom;

    reg [$clog2(DELAY):0] r_tick = 0;
    reg [HEX_FULL_TOP:0] r_full_hex;
    reg [CUSTOM_FULL_TOP:0] r_full_custom;
    reg r_shifted = 1'b0;
    reg r_mode_old = 1'b0;

    assign o_shown_hex = r_full_hex[HEX_FULL_TOP:HEX_FULL_TOP-HEX_SHOWN_TOP];
    assign o_shown_custom = r_full_custom[CUSTOM_FULL_TOP:CUSTOM_FULL_TOP-CUSTOM_SHOWN_TOP];

    always @(posedge i_clk) begin
        if (i_shift) begin
            if (!r_shifted) begin
                if (ENABLE_HEX && ENABLE_CUSTOM) begin
                    if (i_mode == 0) r_full_hex <= i_full[HEX_FULL_TOP:0];
                    else r_full_custom <= i_full[CUSTOM_FULL_TOP:0];
                end else if (ENABLE_HEX) r_full_hex <= i_full;
                    else if (ENABLE_CUSTOM) r_full_custom <= i_full;

                r_tick <= 0;
                r_shifted <= 1;
            end
        end else r_shifted <= 0;

        if (i_enable && r_tick == DELAY) begin
            if (ENABLE_HEX && ENABLE_CUSTOM) begin
                if (i_mode == 0) r_full_hex <= (r_full_hex << 4) | r_full_hex[HEX_FULL_TOP:HEX_FULL_TOP-3];
                else r_full_custom <= (r_full_custom << 7) | r_full_custom[CUSTOM_FULL_TOP:CUSTOM_FULL_TOP-6];
            end else if (ENABLE_HEX) r_full_hex <= (r_full_hex << 4) | r_full_hex[HEX_FULL_TOP:HEX_FULL_TOP-3];
                else if (ENABLE_CUSTOM) r_full_custom <= (r_full_custom << 7) | r_full_custom[CUSTOM_FULL_TOP:CUSTOM_FULL_TOP-6];

            r_tick <= 0;
        end else r_tick <= r_tick + 1;

        // reset the timer on mode switch
        if (i_mode != r_mode_old) begin
            r_mode_old <= i_mode;
            r_tick <= 0;
        end
    end
endmodule