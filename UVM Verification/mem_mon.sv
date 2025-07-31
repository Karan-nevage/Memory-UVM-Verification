// File: mem_mon.sv
// Description: Defines the UVM monitor for observing memory transactions.
// Monitor class for memory transactions
//======================================================================

class mem_mon extends uvm_monitor;
    uvm_analysis_port#(mem_tx) ap_port;   // Analysis port for transactions
    virtual mem_intf vif;                 // Virtual interface to DUT
    mem_tx tx;                            // Transaction instance
    `uvm_component_utils(mem_mon)         // Register with UVM factory

    //-----> NEW Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);          // Call parent constructor
    endfunction

    //----> Build phase: Create analysis port
    function void build();
        ap_port = new("ap_port", this);   // Create analysis port
    endfunction

    //---> Run task: Monitor transactions
    task run();
        vif = top.pif;                    // Get interface from top module
        forever begin
            @(vif.mon_cb);                // Wait for clock edge
            //----> Check for valid transaction
            if (vif.mon_cb.valid_i && vif.mon_cb.ready_o) begin
                tx = new();               // Create new transaction
                tx.addr = vif.mon_cb.addr_i; // Capture address
                //---> Capture data based on write/read
                tx.data = vif.mon_cb.wr_rd_i ? vif.mon_cb.wdata_i : vif.mon_cb.rdata_o;
                tx.wr_rd = vif.mon_cb.wr_rd_i; // Capture write/read control
                tx.print();               // Print transaction
                ap_port.write(tx);        // Send to coverage via analysis port
            end
        end
    endtask
endclass

//======================================================================