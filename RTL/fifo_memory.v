// ============================================================================
// Module: FIFO Memory
// Description: Dual-port memory used for asynchronous FIFO data storage
// ============================================================================

module fifomem #(
    parameter DSIZE = 8,
    parameter ASIZE = 4
)(
    output wire [DSIZE-1:0] rdata,
    input  wire [DSIZE-1:0] wdata,
    input  wire [ASIZE-1:0] waddr,
    input  wire [ASIZE-1:0] raddr,
    input  wire              wclken,
    input  wire              wclk
);

    localparam DEPTH = 1 << ASIZE;

    reg [DSIZE-1:0] mem [0:DEPTH-1];

    // Asynchronous read
    assign rdata = mem[raddr];

    // Synchronous write
    always @(posedge wclk) begin
        if (wclken)
            mem[waddr] <= wdata;
    end

endmodule