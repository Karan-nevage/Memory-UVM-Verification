// Module: tb
// Description: Testbench for the synchronous single-port RAM module.
//              Tests reset, write, and read operations with random data.

//=================================================================================

module tb;
    //----> Parameter definitions
    parameter WIDTH = 32;              // Data width (32 bits)
    parameter DEPTH = 16;              // Memory depth (16 locations)
    parameter ADDR_WIDTH = 4;          // Address width (4 bits for 16 locations)

    //----> Testbench signals
    reg clk_i;                         // Clock input
    reg rst_i;                         // Active-high reset input
    reg [ADDR_WIDTH-1:0] addr_i;       // Address input for read/write
    reg [WIDTH-1:0] wdata_i;           // Data input for write operations
    reg wr_rd_i;                       // Write/Read control (1: write, 0: read)
    reg valid_i;                       // Valid signal to initiate read/write
    wire [WIDTH-1:0] rdata_o;          // Data output from memory
    wire ready_o;                      // Ready signal from memory
    integer i;                         // Loop variable for stimulus generation

    //----> Instantiate the DUT (Design Under Test)
    memory dut (
        .clk_i(clk_i),                 // Connect clock
        .rst_i(rst_i),                 // Connect reset
        .addr_i(addr_i),               // Connect address
        .wdata_i(wdata_i),             // Connect write data
        .rdata_o(rdata_o),             // Connect read data
        .wr_rd_i(wr_rd_i),             // Connect write/read control
        .valid_i(valid_i),             // Connect valid signal
        .ready_o(ready_o)              // Connect ready signal
    );

    //-----> Override DUT parameters to match testbench
    defparam dut.WIDTH = WIDTH;             // Set DUT data width
    defparam dut.DEPTH = DEPTH;             // Set DUT memory depth
    defparam dut.ADDR_WIDTH = ADDR_WIDTH;   // Set DUT address width

                     //**************************//

    //----> Generate clock: 10ns period (5ns high, 5ns low)
    initial begin
        clk_i = 0;                     // Initialize clock to 0
        forever #5 clk_i = ~clk_i;     // Toggle clock every 5 time units
    end

                     //**************************//
    
    // Monitor signals for debugging
    initial begin
        $monitor("At time t=%0t \t || rst_i=%0b {} wr_rd_i=%b addr_i=%h {} wdata_i=%h {} valid_i=%b {} rdata_o=%h {} ready_o=%b",
                 $time, rst_i, wr_rd_i, addr_i, wdata_i, valid_i, rdata_o, ready_o);
    end

                     //**************************//

    // Apply stimulus: Reset, write to memory, and read from memory
    initial begin
        // Initialize signals and apply reset
        rst_i = 1;                     // Assert reset
        #20;                           // Hold reset for 20 time units
        rst_i = 0;                     // Deassert reset

        //------> Write stimulus: Write random data to all memory locations
        for (i = 0; i < DEPTH; i = i + 1) begin
            @(posedge clk_i);          // Wait for positive clock edge
            addr_i = i;                // Set address to current index
            wdata_i = $random;         // Generate random write data
            wr_rd_i = 1;               // Set to write mode
            valid_i = 1;               // Assert valid signal
            wait (ready_o == 1);       // Wait for ready signal from DUT
        end

        //-----> Transition to idle state
        @(posedge clk_i);
        addr_i = 0;                    // Reset address
        wdata_i = 0;                   // Clear write data
        wr_rd_i = 0;                   // Set to read mode
        valid_i = 0;                   // Deassert valid signal

        //------> Read stimulus: Read from all memory locations
        for (i = 0; i < DEPTH; i = i + 1) begin
            @(posedge clk_i);          // Wait for positive clock edge
            addr_i = i;                // Set address to current index
            wr_rd_i = 0;               // Set to read mode
            valid_i = 1;               // Assert valid signal
            wait (ready_o == 1);       // Wait for ready signal from DUT
        end

        //-----> Final idle state
        @(posedge clk_i);
        addr_i = 0;                    // Reset address
        wr_rd_i = 0;                   // Set to read mode
        valid_i = 0;                   // Deassert valid signal

        // End simulation after additional delay
        #30;
        $finish;                       // Terminate simulation
    end

            //****************************************//

    // Generate waveform dump for debugging
    initial begin
        $dumpfile("dump.vcd");         // Specify VCD file for waveform
        $dumpvars;                     // Dump all variables
    end
endmodule

//=================================================================================