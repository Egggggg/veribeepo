// mocks src/gowin_prom/gowin_prom.v:progROM
module progROM(dout, clk, oce, ce, reset, ad);
    parameter BIT_WIDTH = 8;
    parameter ADDR_DEPTH = 4096;

    output [7:0] dout;
    input clk;
    input oce;
    input ce;
    input reset;
    input [11:0] ad;

    pROM prom_inst_0 (
        .DO(dout),
        .CLK(clk),
        .OCE(oce),
        .CE(ce),
        .RESET(reset),
        .AD(ad)
    );

    defparam prom_inst_0.BIT_WIDTH = BIT_WIDTH;
    defparam prom_inst_0.ADDR_DEPTH = ADDR_DEPTH;
endmodule //progROM

// mocks gowin pROM
module pROM(DO, CLK, OCE, CE, RESET, AD);
    parameter BIT_WIDTH  = 1;
    parameter ADDR_DEPTH = 256;
    parameter ADDR_WIDTH = $clog2(ADDR_DEPTH);
    parameter [(ADDR_WIDTH-1):0] INIT_RAM_00 = 256'h0;

    output wire [(BIT_WIDTH-1):0] DO;
    input wire [(ADDR_WIDTH-1):0] AD;
    input wire CLK, OCE, CE, RESET;

    reg [(ADDR_WIDTH-1):0] mem [(BIT_WIDTH-1):0];
    reg [(ADDR_WIDTH-1):0] rmem [(BIT_WIDTH-1):0];

    integer addr;

    always @(posedge CLK) begin
        if (RESET) begin
            for (addr = 0; addr < ADDR_DEPTH; addr = addr + 1) begin
                mem[addr] <= 0;
            end
        end
    end
endmodule // pROM