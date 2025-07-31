// File: mem_seq_lib.sv
// Description: Defines sequence classes for memory verification.
//              Includes base sequence and specific sequences for various test scenarios.
//=======================================================================

// Base sequence class for memory transactions
class mem_base_seq extends uvm_sequence#(mem_tx);
    mem_tx tx, tx_t;                      // Transaction instances
    mem_tx txQ[$];                        // Queue for storing transactions
    uvm_phase phase;                      // Phase reference
    `uvm_object_utils(mem_base_seq)       // Register with UVM factory
    `NEW_OBJ                              // Macro for constructor

    //----> Pre-body task: Manage objections
    task pre_body();
        phase = get_starting_phase();     // Get run phase of sequencer
        if (phase != null) begin
            phase.raise_objection(this);  // Raise objection
            phase.phase_done.set_drain_time(this, 100); // Set drain time
        end
    endtask

    //----> Post-body task: Drop objections
    task post_body();
        if (phase != null) phase.drop_objection(this); // Drop objection
    endtask
  
endclass
//======================================================================

//======================================================================
// Sequence for single write followed by read
class mem_wr_rd_seq extends mem_base_seq;
    `uvm_object_utils(mem_wr_rd_seq)      // Register with UVM factory
    `NEW_OBJ                              // Macro for constructor

    // Body task: Perform write then read
    task body();
        `uvm_do_with(req, {req.wr_rd==1'b1;}) // Write transaction
        tx_t = new req;                   // Copy transaction
        `uvm_do_with(req, {req.wr_rd==1'b0; req.addr==tx_t.addr;}) // Read from same address
    endtask
  
endclass
//======================================================================

//======================================================================
// Sequence for N writes followed by N reads
class mem_n_wr_n_rd_seq extends mem_base_seq;
    `uvm_object_utils(mem_n_wr_n_rd_seq)  // Register with UVM factory
    `NEW_OBJ                              // Macro for constructor

    //----> Body task: Perform 5 writes then 5 reads
    task body();
        repeat(5) begin
            `uvm_do_with(req, {req.wr_rd==1'b1;}) // Write transaction
            tx_t = new req;               // Copy transaction
            txQ.push_back(tx_t);          // Store in queue
        end
        repeat(5) begin
            tx_t = txQ.pop_front();       // Retrieve transaction
            `uvm_do_with(req, {req.wr_rd==1'b0; req.addr==tx_t.addr;}) // Read from same address
        end
    endtask
endclass
//=======================================================================

//=======================================================================
// Sequence for 5 write operations
class mem_5_wr_seq extends mem_base_seq;
    `uvm_object_utils(mem_5_wr_seq)       // Register with UVM factory
    `NEW_OBJ                              // Macro for constructor

    //----> Body task: Perform 5 writes
    task body();
        repeat(5) begin
            `uvm_do_with(req, {req.wr_rd==1'b1;}) // Write transaction
            tx_t = new req;               // Copy transaction
            txQ.push_back(tx_t);          // Store in queue
        end
    endtask
  
endclass
//=======================================================================

//=======================================================================
// Sequence for reset operation
class mem_reset_seq extends mem_base_seq;
    `uvm_object_utils(mem_reset_seq)      // Register with UVM factory
    `NEW_OBJ                              // Macro for constructor

    //----> Body task: Display reset message
    task body();
        $display("mem_reset_seq running in reset_phase"); // Indicate reset sequence
    endtask
  
endclass

//=======================================================================