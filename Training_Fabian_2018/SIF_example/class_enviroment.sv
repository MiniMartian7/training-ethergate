`ifndef ENVIROMENT
`define ENVIROMENT

/*the include on transaction class in enviroment should make available the class also to other classes in which it is used. This depends on the compiler. 
If not, include the class in all classes need and use ifndef and define to prevent multiple initializations of the class*/

`include "class_transaction.sv"
`include "class_gen.sv"
`include "class_driver.sv"

class Enviroment;
    Generator ev_gen;
    Driver ev_driver;
    Operation ev_q[$];

    int nr_of_transactions = 10;
    virtual sif_i ev_i;

    function new(virtual sif_i ev_interface);
        ev_i = ev_interface;
    endfunction/*new*/

    /*in enviroment class a function/task of build is needed to provide al the object contructors, then the build is called in the run of the enviroment*/

    function void build();
        $display("--[ENVIROMENT] Build Task--\n");

        ev_gen = new();
        ev_driver = new();

        $display("--[ENVIROMENT] End Build Task--\n");
    endfunction

    /*task pre_test();
    endtask*/

    task init();
        $display("--[ENVIROMENT] Init Task--\n");

        
        ev_gen.run(nr_of_transactions, ev_q);
        /*the monitor and driver are parallel threads, fork...join_any*/
        ev_driver.run(ev_q.size(), ev_q);

        $display("--[ENVIROMENT] End Init Task--\n");
    endtask

    /*task post_test();
    endtask*/

    task run();
        $display("--[ENVIROMENT] Run Task--\n");
        /*fiecare clasa are un task run si este chemat in ev dupa ultima operatie sa se seteze pe idle*/
    
        build();
        init();


        $finish;

        $display("--[ENVIROMENT] End Run Task--\n");
    endtask
endclass : Enviroment

`endif
