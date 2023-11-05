module beepo(
    i_clk,
);
    input wire i_clk;
    
    wire [7:0] w_instr;
    wire [7:0] w_addr;

    progROM prom(
        .dout(w_instr), // output [7:0] dout
        .clk(i_clk),    // input clk
        .oce(0),    // input oce    (output clock enable, unused in bypass)
        .ce(1),     // input ce     (clock enable)
        .reset(0),  // input reset    (active high)
        .ad(w_addr) // input [7:0] ad
    );
endmodule // binkle