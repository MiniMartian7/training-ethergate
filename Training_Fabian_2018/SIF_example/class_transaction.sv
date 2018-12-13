`ifndef OPERATION
`define OPERATION

import lib_pack::*;

class Operation;
    rand E_Operation op;
    rand bit [15:0] wr_data, addr;

    constraint c_op {wr_data dist {WRITE :=35, READ := 35, IDLE := 10, RESET := 10, ILLEGAL := 10};}
      /*WRITE and READ have a probability of 25% and the rest 10%*/

    static integer nr_op = 0;

    function new();
      nr_op ++;
    endfunction

    function void display();
      $display("--@%gns [OPERATION] Transaction Packet Number|Data|Address :: %d|%b|%b|%b--\n", $time, nr_op, op, wr_data, addr);
    endfunction
endclass : Operation

`endif
