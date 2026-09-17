// ============================================================================
// Module: Write Pointer and Full Logic
// Description: Generates the write pointer and FIFO full flag.
// ============================================================================

module wptr_full #(
    parameter ASIZE = 4
)(
    output reg            wfull,
    output reg [ASIZE:0]  wptr,
    input  wire [ASIZE:0]  wq2_rptr,
    input  wire             winc,
    input  wire             wclk,
    input  wire             wrst_n
);

    reg [ASIZE:0] wbin;

    wire [ASIZE:0] wgraynext;
    wire [ASIZE:0] wbinnext;
    wire            wfull_val;

    // ------------------------------------------------------------------------
    // Write pointer registers
    // ------------------------------------------------------------------------

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wbin <= 0;
            wptr <= 0;
        end
        else begin
            wbin <= wbinnext;
            wptr <= wgraynext;
        end
    end

    // ------------------------------------------------------------------------
    // Binary write pointer
    // ------------------------------------------------------------------------

    assign wbinnext = wbin + (winc & ~wfull);

    // ------------------------------------------------------------------------
    // Binary to Gray conversion
    // ------------------------------------------------------------------------

    assign wgraynext = (wbinnext >> 1) ^ wbinnext;

    // ------------------------------------------------------------------------
    // FIFO full detection
    // ------------------------------------------------------------------------

    assign wfull_val =
        (wgraynext ==
        {~wq2_rptr[ASIZE:ASIZE-1],
          wq2_rptr[ASIZE-2:0]});

    // ------------------------------------------------------------------------
    // Full flag register
    // ------------------------------------------------------------------------

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)
            wfull <= 1'b0;
        else
            wfull <= wfull_val;
    end

endmodule