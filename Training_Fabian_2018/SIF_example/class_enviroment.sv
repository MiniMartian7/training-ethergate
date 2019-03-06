`ifndef ENVIROMENT
`define ENVIROMENT

/*the include on transaction class in enviroment should make available the class also to other classes in which it is used. This depends on the compiler. 
If not, include the class in all classes need and use ifndef and define to prevent multiple initializations of the class*/

import packet::*;
import lib::*;

import generator::*;
import driver::*;
import monitor::*;
import reference::*;
import compare::*;

class Enviroment;
    virtual sif_i ev_i;

    function new(virtual sif_i ev_i);
        this.ev_i = ev_i;
    endfunction

    
    /*in enviroment class a function/task of build is needed to provide al the object constructors*/
    function void build();
        $display("--%t [ENVIROMENT] Build Task--\n", $time);

        ev_gen = new();/*the generation of random transaction number is done in the constructor of the generator*/

        ev_driver = new(ev_i);

	ev_xa_mon = new(ev_i);
	ev_wa_mon = new(ev_i);

	ev_ref = new(ev_i);

	ev_xa_comp = new(ev_i);
	ev_wa_comp = new(ev_i);	
	
        $display("--%t [ENVIROMENT] End Build Task--\n", $time);
    endfunction

    task init();
        $display("--%t [ENVIROMENT] Init Task--\n", $time);

        ev_gen.run();
      
        $display("--%t [ENVIROMENT] End Init Task--\n", $time);
    endtask

    task run();
        $display("--%t [ENVIROMENT] Run Task--\n", $time);

        /*the monitor and driver are parallel threads, fork...join_any*/

	fork	
		ev_xa_mon.run();
		ev_wa_mon.run();
	join_none

	ev_driver.run();

	ev_ref.run();

	ev_xa_comp.run(xa_ref_q, xa_mon_rd_q);
	ev_wa_comp.run(wa_ref_q, wa_mon_q);

	CHECK_CHECK_SUM : assert(check_sum == (xa_ref_q.size() + wa_ref_q.size())) $display("--%t [ENVIROMENT] Check sum passed-- \n", $time);//check sum must be equal to the sum of reference values		
	else $error("--%t [ENVIROMENT] Check sum error-- \n", $time);

	foreach(ref_mem[key]) $display("--%t [ENVIROMENT] Ref Mem poz: %d -> %h--\n", $time, key, ref_mem[key]);
	foreach(actual_mem[key]) $display("--%t [ENVIROMENT] Actual Mem poz: %d -> %h--\n", $time, key, ref_mem[key]);
	
        /*create a idle situation to be responsive to specific externela stimulus*/
        $display("--%t [ENVIROMENT] End Run Task--\n", $time);
    endtask
endclass : Enviroment

`endif
