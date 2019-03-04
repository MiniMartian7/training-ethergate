`ifndef GENERATOR
`define GENERATOR

import packet::*;
import lib::*;

/*the include on transaction class in enviroment should make available the class also to other classes in which it is used. This depends on the compiler. 
If not, include the class in all classes need and use ifndef and define to prevent multiple initialisations of the class*/

/*the difference between a task and a function is that a function does not use simulation time, which means no clock dependency*/

class Generator;
    integer nr_of_pak;

    parameter MIN_TRANS = 10;
    parameter MAX_TRANS = 20;

    function new();/*the number of transaction is randomized in the constructor of the gen in the build task*/
        nr_of_pak = $urandom_range(MIN_TRANS, MAX_TRANS);
    endfunction

    function void run();
        $display("--%t [GENERATOR] Main--\n", $time);

        repeat (nr_of_pak) begin
            op_pak = new(); 

            assert (op_pak.randomize()) else $fatal(0, "--%t [GENERATOR] Packet randomization failed--\n", $time);

            op_pak.display();
            op_q.push_back(op_pak); 
        end

        $display("--%t [GENERATOR] End Main--\n", $time);
    endfunction
endclass : Generator
`endif
