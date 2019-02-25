import packet::*;

class Reference
    virtual sif_i ref_i;

    function new(virtual sif_i ref_i);
        this.ref_i = ref_i;
    endfunction

    /*a posibility to take each obj in the queue is to check each time the size of the queue
    or maybe to do a initial go trough the queue, make the expected value and after that in case of size change, redo this
    
    or take the whole queue and generate another queue with the expected read and writes value
    */

    task run();
        ref_i.expected();
    endtask

endclass : Reference