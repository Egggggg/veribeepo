module blinky (
    i_clock,
    i_enable,
    i_speed,
    o_led_drive
);
    input i_clock;
    input i_enable;
    input i_speed;
    output o_led_drive;

    /*
                    |  used clock   |
        | i_speed   | fast  | slow  |
        | -------   | ----  | ----  |
        | 0         | 0     | 1     |
        | 1         | 1     | 0     |
    */

    parameter c_count_fast = 1000;    // fast mode ticks per toggle
    parameter c_count_slow = 100000;  // slow mode ticks per toggle
    
    reg [10:0] r_count_fast = 0;
    reg [17:0] r_count_slow = 0;

    reg r_toggle_fast = 1'b0;
    reg r_toggle_slow = 1'b0;

    reg r_led_select;
    reg r_led_drive;
    
    always @(posedge i_clock)
        begin
            if (r_count_fast == c_count_fast - 1)
                begin
                    r_toggle_fast <= !r_toggle_fast;
                    r_count_fast <= 0;
                end
            else
                r_count_fast <= r_count_fast + 1;
        end


    always @(posedge i_clock)
        begin
            if (r_count_slow == c_count_slow - 1)
                begin
                    r_toggle_slow <= !r_toggle_slow;
                    r_count_slow <= 0;
                end
            else
                r_count_slow <= r_count_slow + 1;
        end

    always @(*) 
        begin
            case (i_speed)
                1'b0: r_led_select = r_toggle_slow;
                1'b1: r_led_select = r_toggle_fast;
            endcase
        end

    assign o_led_drive = r_led_select & i_enable;
endmodule