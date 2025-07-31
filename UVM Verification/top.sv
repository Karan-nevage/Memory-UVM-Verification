// Module: top
// Description: Top-level module for UVM verification of the memory module.
//              Instantiates the DUT, interface, and sets up clock, reset, and simulation.
//====================================================================

`include "uvm_pkg.sv"                     // Include UVM package
import uvm_pkg::*;                        // Import UVM package symbols

// Include all necessary UVM component files
`include "mem_common.sv"                  // Common definitions
`include "mem_tx.sv"                      // Transaction class
`include "mem_intf.sv"                    // Memory interface
`include "mem_drv.sv"                     // Driver component
`include "mem_sqr.sv"                     // Sequencer typedef
`include "mem_mon.sv"                     // Monitor component
`include "mem_cov.sv"                     // Coverage component
`include "mem_agent.sv"                   // Agent component
`include "mem_env.sv"                     // Environment component
`include "mem_seq_lib.sv"                 // Sequence library
`include "test_lib.sv"                    // Test library

module top;
    // ----> Signal declarations
    reg clk;                              // Clock signal
    reg rst;                              // Reset signal

    //-----> Instantiate memory interface
    mem_intf pif(clk, rst);               // Connect clock and reset to interface

  //======== Instantiate DUT (memory module) =========
    memory dut (
        .clk_i(pif.clk_i),                // Connect clock
        .rst_i(pif.rst_i),                // Connect reset
        .addr_i(pif.addr_i),              // Connect address input
        .wdata_i(pif.wdata_i),            // Connect write data input
        .rdata_o(pif.rdata_o),            // Connect read data output
        .wr_rd_i(pif.wr_rd_i),            // Connect write/read control
        .valid_i(pif.valid_i),            // Connect valid input
        .ready_o(pif.ready_o)             // Connect ready output
    );

    //-----> Clock generation: 10ns period (5ns high, 5ns low)
    initial begin
        clk = 0;                          // Initialize clock
        forever #5 clk = ~clk;            // Toggle clock every 5 time units
    end

    //----> Reset generation: Assert for 2 clock cycles
    initial begin
        rst = 1;                          // Assert reset
        repeat(2) @(posedge clk);         // Hold for 2 clock cycles
        rst = 0;                          // Deassert reset
    end

    //----> UVM test execution
    initial begin
        run_test("mem_n_wr_n_rd_test");   // Run the specified UVM test
    end

    //----> Waveform dump for debugging
    initial begin
        $dumpfile("1.vcd");               // Specify VCD file for waveform
        $dumpvars(0);                     // Dump all variables
    end
endmodule

//=======================================================================