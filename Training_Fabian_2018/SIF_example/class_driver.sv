`ifndef DRIVER
`define DRIVER

import packet::*;
import lib::*;

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

        forever begin
            $display("--%t [DRIVER] Run Task--\n", $time);

            driver_i.reset();/*initial reset*/
		
		    driver_i.send();
		    $display("--%t [DRIVER] Drive Packets done--\n", $time);
            $display("--%t [DRIVER] IDLE--\n", $time);

            while(1) begin
                driver_i.idle();
            end
        end
        
        $display("--%t [DRIVER] End Run Task--\n", $time);
    endtask
endclass : Driver
`endif


/*wait-urile se intampla deobicei in monitoare. Waitul se face ventual doar pe clocking block*/
/*ar fi okay as aiba si driverul resetul lui in run si dupa vine efectuarea tranzactiilor*/
