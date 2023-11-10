module blinky (
    i_clock,
    i_enable,
    i_speed,
    o_led_drive
);
    input i_clock;  // system clock, pin 4
    input i_enable; // button 2, pin 87
    input i_speed;  // button 1, pin 88
    output o_led_drive; // LED 0, pin 15

    /*
                    |  used clock   |
        | i_speed   | fast  | slow  |
        | -------   | ----  | ----  |
        | 0         | 0     | 1     |
        | 1         | 1     | 0     |
    */

    parameter c_freq = 27_000_000;  // ticks per second
    parameter c_ms_fast = 300;  // fast mode ms per toggle
    parameter c_ms_slow = 1000; // slow mode ms per toggle
    parameter integer c_count_fast = c_freq * (c_ms_fast / 1000.0);
    parameter integer c_count_slow = c_freq * (c_ms_slow / 1000.0);
    
    reg [$clog2(c_count_fast):0] r_count_fast = 0;
    reg [$clog2(c_count_slow):0] r_count_slow = 0;

    reg r_toggle_fast = 1'b0;
    reg r_toggle_slow = 1'b0;

    reg r_led_select;
    reg r_led_drive;
    reg r_led_enable = 1'b1;
    reg r_speed = 1'b0;
    
    always @(posedge i_clock) begin
        if (r_count_fast == c_count_fast - 1)
            begin
                r_toggle_fast <= !r_toggle_fast;
                r_count_fast <= 0;
            end
        else
            r_count_fast <= r_count_fast + 1;
    end


    always @(posedge i_clock) begin
        if (r_count_slow == c_count_slow - 1)
            begin
                r_toggle_slow <= !r_toggle_slow;
                r_count_slow <= 0;
            end
        else
            r_count_slow <= r_count_slow + 1;
    end

    always @(posedge i_enable) begin
        r_led_enable <= !r_led_enable;
    end

    always @(posedge i_speed) begin
        r_speed <= !r_speed;
    end

    always @(*) begin
        case (r_speed)
            1'b0: r_led_select = r_toggle_slow;
            1'b1: r_led_select = r_toggle_fast;
        endcase
    end

    assign o_led_drive = !(r_led_select & r_led_enable);
endmodule