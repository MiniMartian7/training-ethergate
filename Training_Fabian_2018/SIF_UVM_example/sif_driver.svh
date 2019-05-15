class driver extends uvm_driver #(sequence_item);
    `uvm_component_utils(driver);
    
    virtual sif_i drv_i;

    function void new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void class_scope::build_phase(uvm_phase phase);
        /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
        /*  For more information see UVM Cookbook v1800.2 p.503  */
        //super.build_phase(phase);
    
        if(!uvm_config_db#(virtual sif_i)::get(null, "*", "sif_i", drv_i))
            `uvm_fatal("[DRIVER]", "Failed to get the interface");
    endfunction: build_phase

    //  Function: run_phase
    task run_phase(uvm_phase phase);
        sequence_item op;

        forever begin : loop
            seq_item_port.get_next_item(op);
            drv_i.send(op.addr, op.data, op.oper);
            seq_item_port.item_done(op);
        end : loop
    endtask : run_phase
endclass : driver