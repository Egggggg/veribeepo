`timescale 100ns/10ns
`include "../src/blonk.v"

module test;
    reg i_clock = 0;
    reg i_enable = 1'b1;
    reg i_speed = 1;
    reg r_led_drive = 0;

    wire w_led_drive;

    /*
                    |   used freq   |
        | i_speed   | fast  | slow  |
        | -------   | ----  | ----  |
        | 0         | 0     | 1     |
        | 1         | 1     | 0     |
    */

    initial begin
        $dumpvars(0, i_enable, r_led_drive);
        $dumpvars(0, boye.r_toggle_fast, boye.r_toggle_slow, boye.r_led_select, boye.r_led_drive, boye.o_led_drive);
    end

    initial begin
        // disable for the third quarter of first fast pulse
        #15000  i_enable <= 0;
        #2500   i_enable <= 1;
        #2500
        // disable for the third quarter of slow pulse
        #130000 i_enable <= 0;
        #25000  i_enable <= 1;
        #25000  #200000 $finish;
    end

    initial begin
        // switch to low frequency after the third fast pulse
        #50000 i_speed <= 0;
    end

    // timescale is set for 2.5MHz (posedge), clock toggles at 5MHz
    always #0.5 i_clock = !i_clock;

    blinky boye (
        .i_clock        (i_clock),
        .i_enable       (i_enable),
        .i_speed        (i_speed),
        .o_led_drive    (w_led_drive)
    );

    always @(w_led_drive)
        begin
            r_led_drive <= w_led_drive;
        end
endmodule