// ============================================================================
// Module: Asynchronous FIFO
// Description: Top-level asynchronous FIFO connecting two independent
//              clock domains.
// ============================================================================

module async_fifo #(
    parameter DSIZE = 8,
    parameter ASIZE = 4
)(
    input  wire             wclk,
    input  wire             wrst_n,
    input  wire             winc,
    input  wire [DSIZE-1:0] wdata,
    output wire             wfull,

    input  wire             rclk,
    input  wire             rrst_n,
    input  wire             rinc,
    output wire [DSIZE-1:0] rdata,
    output wire             rempty
);

    // ------------------------------------------------------------------------
    // Internal pointers
    // ------------------------------------------------------------------------

    wire [ASIZE:0] wptr;
    wire [ASIZE:0] rptr;

    wire [ASIZE:0] wq2_rptr;
    wire [ASIZE:0] rq2_wptr;

    // ------------------------------------------------------------------------
    // Read pointer -> Write clock domain synchronizer
    // ------------------------------------------------------------------------

    sync_r2w #(
        .ASIZE(ASIZE)
    ) sync_r2w_inst (
        .wq2_rptr(wq2_rptr),
        .rptr(rptr),
        .wclk(wclk),
        .wrst_n(wrst_n)
    );

    // ------------------------------------------------------------------------
    // Write pointer -> Read clock domain synchronizer
    // ------------------------------------------------------------------------

    sync_w2r #(
        .ASIZE(ASIZE)
    ) sync_w2r_inst (
        .rq2_wptr(rq2_wptr),
        .wptr(wptr),
        .rclk(rclk),
        .rrst_n(rrst_n)
    );

    // ------------------------------------------------------------------------
    // FIFO memory
    // ------------------------------------------------------------------------

    fifomem #(
        .DSIZE(DSIZE),
        .ASIZE(ASIZE)
    ) fifomem_inst (
        .rdata(rdata),
        .wdata(wdata),
        .waddr(wptr[ASIZE-1:0]),
        .raddr(rptr[ASIZE-1:0]),
        .wclken(winc & ~wfull),
        .wclk(wclk)
    );

    // ------------------------------------------------------------------------
    // Read pointer and empty logic
    // ------------------------------------------------------------------------

    rptr_empty #(
        .ASIZE(ASIZE)
    ) rptr_empty_inst (
        .rempty(rempty),
        .rptr(rptr),
        .rq2_wptr(rq2_wptr),
        .rinc(rinc),
        .rclk(rclk),
        .rrst_n(rrst_n)
    );

    // ------------------------------------------------------------------------
    // Write pointer and full logic
    // ------------------------------------------------------------------------

    wptr_full #(
        .ASIZE(ASIZE)
    ) wptr_full_inst (
        .wfull(wfull),
        .wptr(wptr),
        .wq2_rptr(wq2_rptr),
        .winc(winc),
        .wclk(wclk),
        .wrst_n(wrst_n)
    );

endmodule