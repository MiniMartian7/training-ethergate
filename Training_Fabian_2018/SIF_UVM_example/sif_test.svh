//  Class: sif_test
//
class test extends uvm_test;
    `uvm_component_utils(test);

    enviroment env_hdlr;
    v_sequence v_seq_hdlr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
        /*  For more information see UVM Cookbook v1800.2 p.503  */
        //super.build_phase(phase);
        
        virtual sif_i test_i;

        if(!uvm_config_db #(virtual sif_i) :: get(this, "", "sif_i", test_i))
            `uvm_fatal("[SIF_TEST]", "Failed to get sif interface");

        env_hdlr = enviroment::type_id::create("env_hdlr", this);
    endfunction: build_phase

    /*method one of integrating a virtual sequence
    function void vseq_connect(base_v_seq vseq);
        v_sequence.p_sequence = this.env_hdlr.xa_agnt_hdlr.agnt_seqr_hdlr;
    endfunction : vseq_connect*/

    //method two of integrating virtual seqeunce, that starts on a enviroment base virtual sequencer
    //  Function: run_phase
    task run_phase(uvm_phase phase);
        v_seq_hdlr = v_sequence::type_id::create("v_seq_hdlr");

        phase.raise_objection(this);

        v_seq_hdlr.start(env_hdlr.v_seqr_hdlr);
        
        phase.drop_objection(this);
    endtask : run_phase
    
endclass : test
