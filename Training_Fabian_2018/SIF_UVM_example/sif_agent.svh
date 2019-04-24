class sif_agent extends uvm_agent;
    `uvm_component_utils(sif_agent);
    
    sif_agent_config agnt_config_hdlr; //agent configuration class handler

    /*components
        sif_driver drv_hdlr; //driver handler
        sif_monitor mon_hdlr; //monitor handler
        sif_sequencer seq_hdlr; //sequencer handler
    */

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(sif_agent_config)::get(this, "", "config", agnt_config_hdlr))
            `uvm_fatal("[AGENT]", "Failed to get the config object of the agent");

        is_active = agnt_config_hdlr.get_is_active();
        
    endfunction : build_phase

endclass : sif_agent