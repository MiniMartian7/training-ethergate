`ifndef ENVIROMENT
`define ENVIROMENT

/*the include on transaction class in enviroment should make available the class also to other classes in which it is used. This depends on the compiler. 
If not, include the class in all classes need and use ifndef and define to prevent multiple initializations of the class*/

import generator::*;
import driver::*;
import monitor::*;

class Enviroment;
 

    /*static Packet ev_q[$];defined as static to belong to the class type and be only one
    static Packet ev_xa_mon_q[$], ev_wa_mon_q[$];*/

    virtual sif_i ev_i;

    function new(virtual sif_i ev_i);
        this.ev_i = ev_i;
    endfunction

    
    /*in enviroment class a function/task of build is needed to provide al the object constructors*/
    function void build();
        $display("--@%gns [ENVIROMENT] Build Task--\n", $time);

        ev_gen = new();/*the generation of random transaction number is done in the constructor of the generator*/
        ev_driver = new(ev_i);
	ev_xa_mon = new(ev_i);
	ev_wa_mon = new(ev_i);
	
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
	fork
		ev_driver.run();
		ev_xa_mon.xa_run();
	join
	
        /*create a idle situation to be responsive to specific externela stimulus*/
        $display("--@%gns [ENVIROMENT] End Run Task--\n", $time);
    endtask
endclass : Enviroment

`endif
