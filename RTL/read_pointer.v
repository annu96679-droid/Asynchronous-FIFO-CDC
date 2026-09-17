

// ============================================================================
// Module: Read Pointer and Empty Logic
// Description: Generates the read pointer and FIFO empty flag.
// ============================================================================

module rptr_empty #(
    parameter ASIZE = 4
)(
    output reg            rempty,
    output reg [ASIZE:0]  rptr,
    input  wire [ASIZE:0]  rq2_wptr,
    input  wire             rinc,
    input  wire             rclk,
    input  wire             rrst_n
);

    reg [ASIZE:0] rbin;

    wire [ASIZE:0] rgraynext;
    wire [ASIZE:0] rbinnext;
    wire            rempty_val;

    // ------------------------------------------------------------------------
    // Read pointer registers
    // ------------------------------------------------------------------------

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rbin <= 0;
            rptr <= 0;
        end
        else begin
            rbin <= rbinnext;
            rptr <= rgraynext;
        end
    end

    // ------------------------------------------------------------------------
    // Binary read pointer
    // ------------------------------------------------------------------------

    assign rbinnext = rbin + (rinc & ~rempty);

    // ------------------------------------------------------------------------
    // Binary to Gray conversion
    // ------------------------------------------------------------------------

    assign rgraynext = (rbinnext >> 1) ^ rbinnext;

    // ------------------------------------------------------------------------
    // FIFO is empty when next read pointer equals synchronized write pointer
    // ------------------------------------------------------------------------

    assign rempty_val = (rgraynext == rq2_wptr);

    // ------------------------------------------------------------------------
    // Empty flag register
    // ------------------------------------------------------------------------

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            rempty <= 1'b1;
        else
            rempty <= rempty_val;
    end

endmodule