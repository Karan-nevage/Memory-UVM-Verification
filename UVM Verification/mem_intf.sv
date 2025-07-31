// File: mem_intf.sv
// Description: Defines the interface for connecting the memory DUT with the UVM testbench.
//              Includes clocking blocks for driver and monitor.

//=======================================================================
// Parameter definitions
`define WIDTH 16                          // Data width
`define DEPTH 256                         // Memory depth
`define ADDR_WIDTH 8                      // Address width
//=======================================================================

//=======================================================================
// Interface for memory module
interface mem_intf(input logic clk_i, rst_i);
    //----> Signal declarations
    logic [`ADDR_WIDTH-1:0] addr_i;       // Address input
    logic [`WIDTH-1:0] wdata_i;           // Write data input
    logic wr_rd_i, valid_i;               // Write/read and valid controls
    logic [`WIDTH-1:0] rdata_o;           // Read data output
    logic ready_o;                        // Ready output

    //-----> Driver clocking block
    clocking bfm_cb @(posedge clk_i);
        default input #0 output #1;       // Default input/output skews
        input rst_i;                      // Input reset
        output addr_i, wdata_i;           // Output address and write data
        output wr_rd_i, valid_i;          // Output control signals
        input rdata_o, ready_o;           // Input read data and ready
    endclocking

    //----> Monitor clocking block
    clocking mon_cb @(posedge clk_i);
        default input #1;                 // Default input skew
        input rst_i;                      // Input reset
        input addr_i, wdata_i, wr_rd_i, valid_i; // Input driver signals
        input rdata_o, ready_o;           // Input DUT outputs
    endclocking
  
endinterface

//=======================================================================