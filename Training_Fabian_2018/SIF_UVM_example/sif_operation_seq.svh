class operation_seq extends uvm_sequence #(sequence_item);
    `uvm_object_utils(operation_seq);

    sequence_item operation;

    function void new(string name = "operation_seq");
        super.new(name);
    endfunction : new

    task body();
        operation = sequence_item::type_id::create("operation");

        repeat(20) begin
            start_item(operation);
            assert(operation.randomize());
            finish_item(operation);
        end
    endtask : body
    
endclass : operation_seq