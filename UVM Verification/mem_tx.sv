// File: mem_tx.sv
// Description: Defines the transaction class for memory operations.
// Transaction class for memory operations
//=======================================================================
class mem_tx extends uvm_sequence_item;
    rand bit [7:0] addr;                  // Random address (8 bits)
    rand bit [31:0] data;                 // Random data (32 bits)
    rand bit wr_rd;                       // Random write/read control

    //----> Register fields with UVM factory
    `uvm_object_utils_begin(mem_tx)
        `uvm_field_int(addr, UVM_ALL_ON)  // Register address field
        `uvm_field_int(data, UVM_ALL_ON)  // Register data field
        `uvm_field_int(wr_rd, UVM_ALL_ON) // Register write/read field
    `uvm_object_utils_end

    //---> New Constructor
    function new(string name="");
        super.new(name);                  // Call parent constructor
    endfunction
  
endclass

//=======================================================================