`ifndef DRIVER
`define DRIVER

import packet::*;

class Driver;
    virtual sif_i driver_i;

    function new(virtual sif_i driver_i);
	this.driver_i = driver_i;
    endfunction
/*
    task reset();
        $display("--@%gns [DRIVER] Reset Task--\n", $time);

        driver_i.rst_n <= 0;

        repeat (2) @(posedge driver_i.clk);
        
        driver_i.rst_n <= 1;

        $display("--@%gns [DRIVER] End Reset Task--\n", $time);
    endtask
*/
    task run();
        $display("--@%gns [DRIVER] Run Task--\n", $time);

        driver_i.reset();/*initial reset*/

     	foreach(op_q[i]) driver_i.send(op_q[i].data, op_q[i].addr, op_q[i].op);

        /*creat the idle state*/

        $display("--@%gns [DRIVER] End Run Task--\n", $time);
    endtask
endclass : Driver
`endif


/*wait-urile se intampla deobicei in monitoare. Waitul se face ventual doar pe clocking block*/
/*ar fi okay as aiba si driverul resetul lui in run si dupa vine efectuarea tranzactiilor*/
