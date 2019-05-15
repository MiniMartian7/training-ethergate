class nrst_seq extends uvm_sequence #(sequence_item);
    `uvm_object_utils(nrst_seq);
    
    sequence_item nrst_operation;

    function void new(string name = "nrst_seq");
        super.new(name);
    endfunction : new

    task body();
        nrst_operation = sequence_item::type_id::create("nrst_operation");

        start_item(nrst_operation);
        nrst_operation.oper = rst_op;
        finish_item(nrst_operation);
    endtask : body
endclass : nrst_seq