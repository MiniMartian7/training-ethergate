`ifndef DRIVER
`define DRIVER

`include "class_generator.sv"

class Driver;
    virtual sif_i driver_i;
    Packet ev_q[$];

    function new(virtual sif_i driver_i, ref Packet ev_q[$]);
	this.driver_i = driver_i;
	this.ev_q = ev_q;
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
    task run;
        $display("--@%gns [DRIVER] Run Task--\n", $time);

        driver_i.reset();/*initial reset*/

        foreach(ev_q[i]) begin
	    Packet buffer_q;
	    buffer_q = new();
            buffer_q = ev_q[i];
          
            driver_i.send(buffer_q.addr, buffer_q.data, buffer_q.op);
        end

        /*creat the idle state*/

        $display("--@%gns [DRIVER] End Run Task--\n", $time);
    endtask
endclass : Driver
`endif


/*wait-urile se intampla deobicei in monitoare. Waitul se face ventual doar pe clocking block*/
/*ar fi okay as aiba si driverul resetul lui in run si dupa vine efectuarea tranzactiilor*/
