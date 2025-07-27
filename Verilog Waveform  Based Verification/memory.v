// Module: memory module(Design File)
// Description: A synchronous single-port RAM with read and write capabilities.
//              Supports reset to clear memory and output registers.
// Parameters:
//   WIDTH      - Data width of the memory (default: 16 bits)
//   DEPTH      - Number of memory locations (default: 256)
//   ADDR_WIDTH - Address width for memory indexing (default: 8 bits)


//==================================================================================================

module memory(clk_i, rst_i, addr_i, wdata_i, rdata_o, wr_rd_i, valid_i, ready_o);
  
    //----> Parameter definitions
    parameter WIDTH = 16;                 // Data width
    parameter DEPTH = 256;                // Memory depth
    parameter ADDR_WIDTH = 8;             // Address width

  	input clk_i;                          // Clock input
	input rst_i;                          // Active-high reset input
  	input [ADDR_WIDTH-1:0] addr_i;        // Address input for read/write operations
  	input [WIDTH-1:0] wdata_i;            // Data input for write operations
	input wr_rd_i;                        // Write/Read control (1: write, 0: read)
	input valid_i;                        // Valid signal to initiate read/write
  	output reg [WIDTH-1:0] rdata_o;       // Data output for read operations
	output reg ready_o;                   // Ready signal to indicate operation completion
  
    //----> Internal memory array
    reg [WIDTH-1:0] mem [DEPTH-1:0];      // Memory array to store data
    integer i;                            // Loop variable for memory initialization
	
  	//*************************************************************************************
  
    // Main process: Synchronous operations triggered on positive clock edge
    always @(posedge clk_i) begin
      
        //-----> Reset handling
        if (rst_i == 1) begin
            rdata_o = 0;                  // Clear read data output
            ready_o = 0;                  // Clear ready signal
            // Initialize all memory locations to zero
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] = 0;
            end
        end
      
	      			//*************************************
      
        //------> Normal operation when reset is not active
        else begin
            if (valid_i == 1) begin
                ready_o = 1;              // Assert ready signal when valid input is received
                // Write operation
                if (wr_rd_i == 1) begin
                    mem[addr_i] = wdata_i; // Write input data to memory at specified address
                end
                // Read operation
                else begin
                    rdata_o = mem[addr_i]; // Read data from memory at specified address
                end
            end
          
            //----> No valid input, deassert ready signal
            else begin
                ready_o = 0;
            end
        end
      
    end
endmodule

//==================================================================================================