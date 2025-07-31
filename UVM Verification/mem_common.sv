// File: mem_common.sv
// Description: Defines common macros and a utility class for the UVM testbench.
//              Includes macros for test tasks and a class for shared resources.
//==================================================================
//================= Macro for run phase task =======================
`define TEST_RUN_TASK \
    task run_phase(uvm_phase phase); \
        phase.raise_objection(this); \
        phase.phase_done.set_drain_time(this, 100); \
        seq.start(env.agent.sqr); \
        phase.drop_objection(this); \
    endtask
//==================================================================

//==================================================================
//=============== Macro for build phase function ===================
`define TEST_BUILD_FUNCTION \
    function void build(); \
        super.build(); \
        seq = new("seq"); \
    endfunction
//==================================================================

//==================================================================
//================ Macro for component constructor =================
`define NEW_COMP \
    function new(string name, uvm_component parent); \
        super.new(name, parent); \
    endfunction
//==================================================================

//==================================================================
//================= Macro for object constructor ===================
`define NEW_OBJ \
    function new(string name=""); \
        super.new(name); \
    endfunction
//==================================================================

//==================================================================
// ================== Macro for test class definition ==============
`define TEST_DEFINITION(TEST, SEQ) \
    class TEST extends mem_base_test; \
        SEQ seq; \
        `uvm_component_utils(TEST) \
        `NEW_COMP \
        `TEST_BUILD_FUNCTION \
        `TEST_RUN_TASK \
    endclass
//==================================================================

//==================================================================
//================ Utility class for shared resources ==============
class mem_common;
    static mailbox gen2bfm_mb = new();    // Mailbox for generator to BFM
    static mailbox mon2cov_mb = new();    // Mailbox for monitor to coverage
    static mailbox mon2ref_mb = new();    // Mailbox for monitor to reference model
    static string testname;               // Test name storage
    static virtual mem_intf vif;          // Virtual interface reference
endclass
//==================================================================