// File: mem_env.sv
// Description: Defines the UVM environment class for the memory verification.
//              Integrates the agent and other components (e.g., reference model, if needed).

//====================================================================
class mem_env extends uvm_env;
    mem_agent agent;                      // Agent instance for driving and monitoring
    `uvm_component_utils(mem_env)         // Register with UVM factory

    //----> NEW Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);          // Call parent constructor
    endfunction

    //----> Build phase: Create agent
    function void build();
        agent = new("agent", this);       // Instantiate agent
    endfunction

endclass
//=====================================================================