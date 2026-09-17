# Asynchronous-FIFO-CDC
Parameterized Asynchronous FIFO design using Gray-code pointer synchronization and CDC techniques in Verilog

Modern System-on-Chips (SoCs) are rarely driven by a single clock. You usually have a high-speed processor talking to a slower peripheral, or vice versa. When you try to pass multi-bit binary data directly between two independent clock domains, you inevitably hit metastability—signals get sampled mid-transition, resulting in garbage data and catastrophic system failure.

I built this Asynchronous FIFO to solve that exact problem. It acts as an elastic buffer, safely swallowing data from a fast transmitter and holding it until a slow receiver is ready to read it, ensuring 100% data integrity across clock boundaries.

This repository documents my end-to-end VLSI design flow: from RTL architecture and Verilog coding, to race-condition-free Verification, and finally, Physical Implementation and Timing Closure on a Xilinx FPGA.

**HDL**: Verilog (IEEE 1364-2001)

# Architecture & RTL Design

I structured the RTL to be highly modular, breaking it down into five distinct blocks (as seen in the RTL Schematic):

* Dual-Port RAM (fifomem): The core memory buffer with independent read and write ports.

* Write Pointer & Full Logic (wptr_full): Tracks the write address and asserts the wfull flag to prevent overflow.

* Read Pointer & Empty Logic (rptr_empty): Tracks the read address and asserts the rempty flag to prevent underflow.

* Read-to-Write Synchronizer (sync_r2w): 2-stage flip-flop synchronizer.

* Write-to-Read Synchronizer (sync_w2r): 2-stage flip-flop synchronizer.
