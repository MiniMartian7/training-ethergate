class agent extends uvm_agent;
    `uvm_component_utils(agent);
    
    agent_config agnt_config_hdlr; //agent configuration class handler

    /*components
        sif_driver drv_hdlr; //driver handler
        sif_monitor mon_hdlr; //monitor handler
    */
        sequencer agnt_seqr_hdlr; //sequencer handler
    

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(agent_config)::get(this, "", "config", agnt_config_hdlr))
            `uvm_fatal("[AGENT]", "Failed to get the config object of the agent");

        is_active = agnt_config_hdlr.get_is_active();
        
        if(get_is_active() == UVM_ACTIVE) begin : generate_stimulus
            agnt_seqr_hdlr = new("agnt_seqr_hdlr", this);
        end
    endfunction : build_phase

endclass : agent