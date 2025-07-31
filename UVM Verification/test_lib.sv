// File: test_lib.sv
// Description: Defines UVM test classes for verifying the memory module.
//              Includes base test and derived tests for various scenarios.

// Base test class for all memory tests
//=======================================================================

class mem_base_test extends uvm_test;
	mem_env env;                          // Environment instance
    `uvm_component_utils(mem_base_test)    // Register with UVM factory
    `NEW_COMP                             // Macro for constructor

    //----> Build phase: Create environment
    function void build();
        env = mem_env::type_id::create("env", this); // Factory creation of env
    endfunction

    //-----> End of elaboration phase: Print factory and topology
    function void end_of_elaboration();
        uvm_factory factory = uvm_factory::get(); // Get factory instance (UVM 1.2)
        factory.print();                      // Print factory overrides
        uvm_top.print_topology();             // Print UVM component hierarchy
    endfunction

    //-----> Report phase: Display test result
    function void report();
        $display("mem_n_wr_n_rd_seq test passed"); // Report test pass
    endfunction
  
endclass
//=====================================================================

//=====================================================================
//==== Macro to define test classes with associated sequences =========
`TEST_DEFINITION(mem_wr_rd_test, mem_wr_rd_seq)          // Write-read test
`TEST_DEFINITION(mem_n_wr_n_rd_test, mem_n_wr_n_rd_seq) // N write-read test

//=====================================================================

//=====================================================================
//----> Test for 5 write operations
class mem_5_wr_test extends mem_base_test;
    mem_5_wr_seq seq;                     // Sequence instance
    `uvm_component_utils(mem_5_wr_test)    // Register with UVM factory
    `NEW_COMP                             // Macro for constructor

    //----> Build phase: Create environment and sequence
    function void build();
        super.build();                    // Call parent build
        seq = new("seq");                 // Create sequence instance
    endfunction

    //----> Run phase: Execute sequence
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);      // Raise objection to keep phase active
        phase.phase_done.set_drain_time(this, 100); // Set drain time
        seq.start(env.agent.sqr);         // Start sequence on sequencer
        phase.drop_objection(this);       // Drop objection to end phase
    endtask
  
endclass
//=====================================================================

//=====================================================================
// Test for N write-read operations using configuration database
class mem_n_wr_n_rd_build_test extends mem_base_test;
    `uvm_component_utils(mem_n_wr_n_rd_build_test) // Register with UVM factory
    `NEW_COMP                             // Macro for constructor

    //----> Build phase: Set default sequence
    function void build();
        //----> Configure default sequence for sequencer’s run phase
        uvm_config_db#(uvm_object_wrapper)::set(
            this, "env.agent.sqr.run_phase",
            "default_sequence", mem_n_wr_n_rd_seq::get_type()
        );
    endfunction
  
endclass
//=====================================================================
