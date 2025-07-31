// File: mem_cov.sv
// Description: Defines the UVM coverage subscriber for collecting functional coverage.
//              Samples address and write/read control signals from transactions.

//====================================================================
class mem_cov extends uvm_subscriber#(mem_tx);
    mem_tx tx;                            // Transaction instance
    `uvm_component_utils(mem_cov)         // Register with UVM factory

    //-----> Covergroup for memory transactions
    covergroup mem_cg;                    // Define covergroup
        //----> Coverpoint for address with auto-binning
        coverpoint tx.addr {
            option.auto_bin_max = 8;      // Max 8 bins for address
        }
        //----> Coverpoint for write/read control
        coverpoint tx.wr_rd {
            bins WRITE = {1'b1};          // Bin for write operations
            bins READ = {1'b0};           // Bin for read operations
        }
    endgroup

    //----> NEW Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);          // Call parent constructor
        mem_cg = new();                   // Instantiate covergroup
    endfunction

    //-----> Write method: Sample coverage
    function void write(mem_tx t);
        $cast(tx, t);                     // Cast input transaction to local tx
        mem_cg.sample();                  // Sample covergroup
    endfunction
  
endclass
//======================================================================