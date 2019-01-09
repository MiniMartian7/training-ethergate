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
      $display("--@%gns [TRANSACTION] Transaction Packet Number|Type|Data|Address :: %d|%b|%b|%b--\n", $time, nr_op, op, wr_data, addr);
    endfunction
endclass : Operation

class Monitor_Operation;
  bit [15:0] data, addr;

  function new();
  end

  function void display();
        $display("--@%gns [MONITOR] Info data|address :: %b|%b --\n", $time, data, addr);
    endfunction
endclass : Monitor_Operation
`endif
