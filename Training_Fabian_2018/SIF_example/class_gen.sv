`ifndef GENERATOR
`define GENERATOR

/*the include on transaction class in enviroment should make available the class also to other classes in which it is used. This depends on the compiler. 
If not, include the class in all classes need and use ifndef and define to prevent multiple initialisations of the class*/

/*the difference between a task and a function is that a function does not use simulation time, which means no clock dependency*/

class Generator;
    Operation trans;

    /*event generation_ended;*/

    /*function new(ref Operation ev_q[$]);/*cum se trimite un q
        gen2driver = ev_q;
    endfunction*/

    function run(int nr_of_transactions, ref Operation ev_q[$]);/*nu utilizeaza timp de simulare, adica nu utilizeaza un clock*/
        $display("--@%gns [GENERATOR] Main Task--\n", $time);

        repeat (nr_of_transactions) begin/*is there a posibility to generate all the transaction in paralel(fork...join_none)*/
            trans = new();

            assert (trans.randomize()) else $fatal(0, "--@%gns [GENERATOR] Transaction Packet :: randomize failed--\n", $time);

            trans.display();
            ev_q.push_back(trans); 
        end

        $display("--@%gns [GENERATOR] End Main Task--\n", $time);
        /*-> generation_ended;*/
    endfunction
endclass : Generator

`endif
