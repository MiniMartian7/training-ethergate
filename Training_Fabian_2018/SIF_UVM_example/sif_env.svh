class sif_env extends uvm_env;
    `uvm_component_utils(sif_env);

    sif_agent xa_agnt_hdlr, wa_agnt_hdlr;
    sif_agent_config xa_agnt_config_hdlr, wa_agnt_config_hdlr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
    
    function void build_phase(uvm_phase phase);
        /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
        /*  For more information see UVM Cookbook v1800.2 p.503  */
        //super.build_phase(phase);
    
        virtual sif_i env_i;
        //sif_env_config env_config_hdlr;

        if(!uvm_config_db#(virtual sif_i)::get(this, "", "sif_i", env_i)
            `uvm_fatal("[ENVIROMENT]", "Failed to get CLASS BFM");

        //obiectele de configurare pentru agenti sunt aici create prin constructor pt ca nu fac parte din factory. Pot fi include in factory si sa fie create prin factory?
        xa_agent_config_hdlr = new(env_i, UVM_ACTIVE);
        wa_agent_config_hdlr = new(env_i, UVM_PASSIVE);

        uvm_config_db#(sif_agent_config)::set(this, "xa_agnt_hdlr.*", "config", xa_agent_config_hdlr);
        uvm_config_db#(sif_agent_config)::set(this, "wa_agnt_hdlr.*", "config", wa_agent_config_hdlr);
        
        xa_agnt_hdlr = new("xa_agnt_hdlr", this);
        wa_agnt_hdlr = new("wa_agnt_hdlr", this);

    endfunction: build_phase
endclass : sif_env