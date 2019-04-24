//  Class: sif_test
//
class sif_test extends uvm_test;
    `uvm_component_utils(sif_test);

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    sif_env env_hdlr;

    function void build_phase(uvm_phase phase);
        /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
        /*  For more information see UVM Cookbook v1800.2 p.503  */
        //super.build_phase(phase);
        
        virtual sif_i test_i;

        if(!uvm_config_db #(virtual sif_i) :: get(this, "", "sif_i", test_i))
            `uvm_fatal("[SIF_TEST]", "Failed to get sif interface");

        env_hdlr = env :: type_if :: create("env_hdlr", this);
    endfunction: build_phase
endclass : sif_test
