`ifndef GENERATOR
`define GENERATOR

`include "class_transaction.sv"

/*the include on transaction class in enviroment should make available the class also to other classes in which it is used. This depends on the compiler. 
If not, include the class in all classes need and use ifndef and define to prevent multiple initialisations of the class*/

/*the difference between a task and a function is that a function does not use simulation time, which means no clock dependency*/

class Generator;
    Operation trans;
    integer nr_of_transactions;

    parameter MIN_TRANS = 10;
    parameter MAX_TRANS = 20;

    function new();/*the number of transaction is randomized in the constructor of the gen in the build task*/
        nr_of_transactions = $urandom_range(MIN_TRANS, MAX_TRANS);
    endfunction

    function void run(ref Operation ev_q[$]);
        $display("--@%gns [GENERATOR] Main Task--\n", $time);

        repeat (nr_of_transactions) begin
            trans = new();

            assert (trans.randomize()) else $fatal(0, "--@%gns [GENERATOR] Transaction Packet :: randomize failed--\n", $time);

            trans.display();
            ev_q.push_back(trans); 
        end

        $display("--@%gns [GENERATOR] End Main Task--\n", $time);
    endfunction
endclass : Generator
`endif
