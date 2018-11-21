`ifndef OPERATION
`define OPERATION

import lib_pack::E_Operation;

class Operation;
    rand E_Operation op;
    rand bit [15:0] wr_data, addr;

    constraint c_op {
      wr_data dist = {[WRITE:READ] :/ 50, [IDLE:RESET:ILLEGAL] :/ 50};
      /*WRITE and READ have a probability of 25% and the rest 10%*/
    }

    static int nr_op = 0;

    function new();
      nr_op++;
    endfunction

    function void display();
      $display("--@%gns [OPERATION] Transaction Packet Number|Data|Address :: %d|%b|%b--\n", $time, nr_op, data, addr);
    endfunction
endclass : Operation

`endif
