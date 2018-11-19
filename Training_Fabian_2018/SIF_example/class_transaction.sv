`include "library_pack.sv"

import library_pack::E_Operation;

class Operation;
    rand E_Operation op;
    rand bit [15:0] wr_data, addr;

    static int nr_op = 0;

    function new();
      nr_op++;
    endfunction

    function display();
      $display("--@%gns [OPERATION] Transaction Packet Number|Data|Address :: %d|%b|%b--\n", $time, nr_op, data, addr);
    endfunction
endclass /*operation*/
