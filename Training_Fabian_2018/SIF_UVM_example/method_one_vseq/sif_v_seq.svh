class v_sequence extends uvm_sequence #(uvm_sequence_item);//method one of integrating a virtual sequence
    `uvm_object_utils(base_v_seq);
    
//Handlers to the agent/s sequencer/s
    sequencer p_sequence;

//Senquence Handler/s
    nrst_seq reset;
    operation_seq opes;

//Constructor
    function void new(string name = "base_v_seq");
        super.new(name);
    endfunction: new
    
    task body();
        reset = sequence_item::type_id::create("reset");
        opes = sequence_item::type_id::create("opes");

        reset.start(p_sequence);
        opes.start(p_sequence);
    endtask : body

endclass : v_sequence