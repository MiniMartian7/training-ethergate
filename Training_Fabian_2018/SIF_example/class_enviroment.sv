`ifndef ENVIROMENT
`define ENVIROMENT

/*the include on transaction class in enviroment should make available the class also to other classes in which it is used. This depends on the compiler. 
If not, include the class in all classes need and use ifndef and define to prevent multiple initializations of the class*/

`include "class_transaction.sv"
`include "class_gen.sv"
`include "class_driver.sv"
`include "class_monitor.sv"

class Enviroment;
    Generator ev_gen;
    Driver ev_driver;
    Monitor ev_xa_mon, ev_wa_mon;

    Operation ev_q[$];
    Monitor_Operation ev_q_xa_mon2scb[$], ev_q_wa_mon2scb[$];

    virtual sif_i ev_i;

    function new(virtual sif_i ev_i);
        this.ev_i = ev_i;
    endfunction/*new*/

    
    /*in enviroment class a function/task of build is needed to provide al the object constructors*/
    function void build();
        $display("--@%gns [ENVIROMENT] Build Task--\n", $time);

        ev_gen = new();/*the generation of random transaction number is done in the constructor of the generator*/
        ev_driver = new(ev_i);
        ev_xa_mon = new();
        ev_wa_mon = new();

        $display("--@%gns [ENVIROMENT] End Build Task--\n", $time);
    endfunction

    /*task pre_test();
    endtask*/

    task init();
        $display("--@%gns [ENVIROMENT] Init Task--\n", $time);

        ev_gen.run(ev_q);
      
        $display("--@%gns [ENVIROMENT] End Init Task--\n", $time);
    endtask

    task run();
        $display("--@%gns [ENVIROMENT] Run Task--\n", $time);

        /*the monitor and driver are parallel threads, fork...join_any*/
        fork
            ev_driver.run(ev_q);
            
            ev_xa_mon.run(ev_i.xa_data_rd, ev_i.xa_addr, ev_q_xa_mon2scb);
            ev_wa_mon.run(ev_i.wa_data_rd, ev_i.wa_addr, ev_q_wa_mon2scb);
        join_any

        /*create a idle situation to be responsive to specific externela stimulus*/
        $display("--@%gns [ENVIROMENT] End Run Task--\n", $time);
    endtask
endclass : Enviroment

`endif




 /*task drive_and_monitor();
        $display("--[ENVIROMENT] Drive and Monitor Task--\n");

        the monitor and driver are parallel threads, fork...join_any*/
        /*fork
        ev_driver.run(ev_q);
        /*process to monitors*/
        /*join_none

        $display("--[ENVIROMENT] End Drive and Monitor Task--\n");
    endtask
    /*task post_test();
    endtask*/
