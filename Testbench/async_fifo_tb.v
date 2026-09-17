`timescale 1ns/1ps

module async_fifo_tb;

    parameter DSIZE = 8;
    parameter ASIZE = 4;

    reg wclk;
    reg rclk;

    reg wrst_n;
    reg rrst_n;

    reg winc;
    reg rinc;

    reg [DSIZE-1:0] wdata;

    wire [DSIZE-1:0] rdata;

    wire wfull;
    wire rempty;

    // ------------------------------------------------------------------------
    // DUT
    // ------------------------------------------------------------------------

    async_fifo #(
        .DSIZE(DSIZE),
        .ASIZE(ASIZE)
    ) dut (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .winc(winc),
        .wdata(wdata),
        .wfull(wfull),

        .rclk(rclk),
        .rrst_n(rrst_n),
        .rinc(rinc),
        .rdata(rdata),
        .rempty(rempty)
    );

    // ------------------------------------------------------------------------
    // Write clock
    // 10 ns period
    // ------------------------------------------------------------------------

    initial begin
        wclk = 0;

        forever #5 wclk = ~wclk;
    end

    // ------------------------------------------------------------------------
    // Read clock
    // 14 ns period
    // ------------------------------------------------------------------------

    initial begin
        rclk = 0;

        forever #7 rclk = ~rclk;
    end

    // ------------------------------------------------------------------------
    // Waveform dump
    // ------------------------------------------------------------------------

    initial begin
        $dumpfile("waveform/async_fifo.vcd");
        $dumpvars(0, async_fifo_tb);
    end

    // ------------------------------------------------------------------------
    // Test
    // ------------------------------------------------------------------------

    initial begin

        wrst_n = 0;
        rrst_n = 0;

        winc  = 0;
        rinc  = 0;
        wdata = 0;

        #30;

        wrst_n = 1;
        rrst_n = 1;

        // ------------------------------------------------------------
        // Write data
        // ------------------------------------------------------------

        @(posedge wclk);

        winc  = 1;
        wdata = 8'hA1;

        @(posedge wclk);
        wdata = 8'hB2;

        @(posedge wclk);
        wdata = 8'hC3;

        @(posedge wclk);
        wdata = 8'hD4;

        @(posedge wclk);

        winc = 0;

        // Allow synchronization
        #50;

        // ------------------------------------------------------------
        // Read data
        // ------------------------------------------------------------

        @(posedge rclk);

        rinc = 1;

        repeat (4)
            @(posedge rclk);

        rinc = 0;

        #50;

        $finish;

    end

endmodule