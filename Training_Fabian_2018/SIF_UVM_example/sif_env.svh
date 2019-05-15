class enviroment extends uvm_env;
    `uvm_component_utils(enviroment);

    //Agent/s and Agent_Config/s handler/s
    agent xa_agnt_hdlr, wa_agnt_hdlr;
    agent_config xa_agnt_config_hdlr, wa_agnt_config_hdlr;

    //Virtual Sequencer/s Handle/s -- method 2
    virtual_sequencer v_seqr_hdlr;

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

        uvm_config_db#(agent_config)::set(this, "xa_agnt_hdlr.*", "config", xa_agent_config_hdlr);
        uvm_config_db#(agent_config)::set(this, "wa_agnt_hdlr.*", "config", wa_agent_config_hdlr);
        
        /*
        xa_agnt_hdlr = new("xa_agnt_hdlr", this);
        wa_agnt_hdlr = new("wa_agnt_hdlr", this);
        */
        xa_agnt_hdlr = agent::type_id::create("xa_agnt_hdlr");
        wa_agnt_hdlr = agent::type_id::create("wa_agnt_hdlr");

        v_seqr_hdlr = virtual_sequencer::type_id::create("v_seqr_hdlr"); //-- method 2 with v_seqr
    endfunction: build_phase 
    
    function void class_scope::connect_phase(uvm_phase phase);
        //super.connect_phase(phase);
        v_seqr_hdlr.p_sequencer = xa_agnt_hdlr.agnt_seqr_hdlr; //-- method 2 with v_seqr
        
    endfunction : connect_phase
    
endclass : enviroment