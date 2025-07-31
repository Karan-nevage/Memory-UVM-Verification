// File: mem_agent.sv
// Description: Defines the UVM agent class for the memory verification.
//              Integrates driver, sequencer, monitor, and coverage components.

//======================================================================
class mem_agent extends uvm_agent;
    mem_drv drv;                          // Driver instance for driving transactions
    mem_sqr sqr;                          // Sequencer instance for sequence control
    mem_mon mon;                          // Monitor instance for observing transactions
    mem_cov cov;                          // Coverage instance for functional coverage
    `uvm_component_utils(mem_agent)       // Register with UVM factory

    //----> NEW Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);          // Call parent constructor
    endfunction

    //----> Build phase: Create components
    function void build();
        drv = mem_drv::type_id::create("drv", this); // Create driver
        sqr = mem_sqr::type_id::create("sqr", this); // Create sequencer
        cov = mem_cov::type_id::create("cov", this); // Create coverage subscriber
        mon = mem_mon::type_id::create("mon", this); // Create monitor
    endfunction

    //-----> Connect phase: Connect component ports
    function void connect();
        // Connect driver’s sequence item port to sequencer’s export
        drv.seq_item_port.connect(sqr.seq_item_export);
        // Connect monitor’s analysis port to coverage subscriber’s export
        mon.ap_port.connect(cov.analysis_export);
    endfunction
  
endclass
//======================================================================