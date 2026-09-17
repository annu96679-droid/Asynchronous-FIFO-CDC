// ============================================================================
// Module: CDC Synchronizers
// Description: Two-stage synchronizers for transferring Gray-code pointers
//              between asynchronous clock domains.
// ============================================================================

// ----------------------------------------------------------------------------
// Read Pointer -> Write Clock Domain
// ----------------------------------------------------------------------------

module sync_r2w #(
    parameter ASIZE = 4
)(
    output reg  [ASIZE:0] wq2_rptr,
    input  wire [ASIZE:0] rptr,
    input  wire            wclk,
    input  wire            wrst_n
);

    reg [ASIZE:0] wq1_rptr;

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wq1_rptr <= 0;
            wq2_rptr <= 0;
        end
        else begin
            wq1_rptr <= rptr;
            wq2_rptr <= wq1_rptr;
        end
    end

endmodule


// ----------------------------------------------------------------------------
// Write Pointer -> Read Clock Domain
// ----------------------------------------------------------------------------

module sync_w2r #(
    parameter ASIZE = 4
)(
    output reg  [ASIZE:0] rq2_wptr,
    input  wire [ASIZE:0] wptr,
    input  wire            rclk,
    input  wire            rrst_n
);

    reg [ASIZE:0] rq1_wptr;

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rq1_wptr <= 0;
            rq2_wptr <= 0;
        end
        else begin
            rq1_wptr <= wptr;
            rq2_wptr <= rq1_wptr;
        end
    end

endmodule