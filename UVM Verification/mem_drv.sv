// File: mem_drv.sv
// Description: Defines the UVM driver class for the memory verification.
//              Drives transactions from the sequencer to the DUT via the memory interface.

//====================================================================
class mem_drv extends uvm_driver#(mem_tx);
    virtual mem_intf vif;                 // Virtual interface to connect to DUT
    `uvm_component_utils(mem_drv)         // Register with UVM factory

    //---> NEW Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);          // Call parent constructor
    endfunction

    //----> Run task: Main driver loop
    task run();
        vif = top.pif;                    // Map virtual interface to physical interface in top module
        forever begin
            //-----> Get transaction from sequencer
            seq_item_port.get_next_item(req); // Request next transaction
            drive_tx(req);                // Drive transaction to DUT
            seq_item_port.item_done();    // Signal completion of transaction
        end
    endtask

  					//***********************
  
    //-----> Drive transaction task: Drives transaction signals to DUT
    task drive_tx(mem_tx tx);
        //----> Synchronize with driver clocking block
        @(vif.bfm_cb);
        //-----> Set interface signals based on transaction
        vif.bfm_cb.addr_i <= tx.addr;     // Drive address
        if (tx.wr_rd == 1) 
            vif.bfm_cb.wdata_i <= tx.data; // Drive write data for write operation
        vif.bfm_cb.wr_rd_i <= tx.wr_rd;   // Drive write/read control
        vif.bfm_cb.valid_i <= 1;          // Assert valid signal
        //----> Wait for DUT to acknowledge with ready
        wait (vif.bfm_cb.ready_o == 1);
        // Synchronize with next clock edge
        @(vif.bfm_cb);
        //----> Capture read data for read operation
        if (tx.wr_rd == 0) 
            tx.data = vif.bfm_cb.rdata_o; // Update transaction with read data
      
        //----> Clear interface signals
        vif.bfm_cb.addr_i <= 0;           // Reset address
        vif.bfm_cb.wdata_i <= 0;          // Reset write data
        vif.bfm_cb.wr_rd_i <= 0;          // Reset write/read control
        vif.bfm_cb.valid_i <= 0;          // Deassert valid signal
    endtask
  
endclass
//==================================================================