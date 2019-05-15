//  Class: sequence_item
//
class sequence_item extends uvm_sequence_item;
    `uvm_object_utils(sequence_item);

    //  Group: Variables
    rand [15:0] data, addr;
    rand sif_op oper;

    constraint c_oper {oper dist {wr_op :=35, rd_op := 35, idle_op := 10, rst_op := 10, ilegal_op := 10};}/*WRITE and READ have a probability of 25% and the rest 10%*/

    //  Group: Functions

    //  Constructor: new
    function new(string name = "sequence_item");
        super.new(name);
    endfunction: new

    //  Function: do_copy
    // extern function void do_copy(uvm_object rhs);
    //  Function: do_compare
    // extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    //  Function: convert2string
    // extern function string convert2string();
    //  Function: do_print
    // extern function void do_print(uvm_printer printer);
    //  Function: do_record
    // extern function void do_record(uvm_recorder recorder);
    //  Function: do_pack
    // extern function void do_pack();
    //  Function: do_unpack
    // extern function void do_unpack();

    
endclass : sequence_item
