`ifndef ENVIROMENT
`define ENVIROMENT

/*the include on transaction class in enviroment should make available the class also to other classes in which it is used. This depends on the compiler. 
If not, include the class in all classes need and use ifndef and define to prevent multiple initializations of the class*/

`include "class_packet.sv"
`include "class_generator.sv"
`include "class_driver.sv"
`include "class_monitor.sv"

class Enviroment;
    Generator ev_gen;
    Driver ev_driver;
    Monitor ev_xa_mon, ev_wa_mon;

    Packet ev_q[$];
    Packet ev_xa_mon_q[$];

    virtual sif_i ev_i;

    function new(virtual sif_i ev_i);
        this.ev_i = ev_i;
    endfunction

    
    /*in enviroment class a function/task of build is needed to provide al the object constructors*/
    function void build();
        $display("--@%gns [ENVIROMENT] Build Task--\n", $time);

        ev_gen = new(ev_q);/*the generation of random transaction number is done in the constructor of the generator*/
        ev_driver = new(ev_i, ev_q);
        ev_xa_mon = new(ev_i, ev_xa_mon_q);
        ev_wa_mon = new(ev_i, ev_xa_mon_q);

        $display("--@%gns [ENVIROMENT] End Build Task--\n", $time);
    endfunction

    task init();
        $display("--@%gns [ENVIROMENT] Init Task--\n", $time);

        ev_gen.run();
      
        $display("--@%gns [ENVIROMENT] End Init Task--\n", $time);
    endtask

    task run();
        $display("--@%gns [ENVIROMENT] Run Task--\n", $time);

        /*the monitor and driver are parallel threads, fork...join_any*/
        ev_driver.run();
        /*create a idle situation to be responsive to specific externela stimulus*/
        $display("--@%gns [ENVIROMENT] End Run Task--\n", $time);
    endtask
endclass : Enviroment

`endif
