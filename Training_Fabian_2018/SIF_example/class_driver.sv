`ifndef DRIVER
`define DRIVER

`define DUT_CB driver_i.dut_cb

`include "class_gen.sv"

/*the include on transaction class in enviroment should make available the class also to other classes in which it is used. This depends on the compiler. 
If not, include the class in all classes need and use ifndef and define to prevent multiple initialisations of the class*/

class Driver;
    Operation buffer_q;

    virtual sif_i driver_i;

    task reset();
        $display("--@%gns [DRIVER] Reset Task--\n");

        /*wait-urile se intampla deobicei in monitoare. Waitul se face ventual doar pe clocking block*/
        /*ar fi okay as aiba si driverul resetul lui in run si dupa vine efectuarea tranzactiilor*/

        /*`DRIVER_CB.xa_addr <= 0;
        `DRIVER_CB.xa_data_wr <= 0;
        `DRIVER_CB.xa_data_rd <= 0;
        `DRIVER_CB.xa_wr_s <= 0;
        `DRIVER_CB.xa_rd_s <= 0;*/

        `DUT_CB.rst_n <= 0;

        repeat (2) @(posedge `DRIVER_CB);
        
        `DUT_CB.rst_n <= 1;
        $display("--@%gns [DRIVER] End Reset Task--\n");
    endtask

    task run(int nr_of_transactions, ref Operation ev_q[$]);
        $display("--@%gns [DRIVER] Run Task--\n", $time);

        while (nr_of_transactions) begin
            buffer_q = ev_q.pop_front();
            ev_q.delete(nr_of_transactions - 1);
            nr_of_transactions--;

            driver_i.send(buffer.addr, buffer.data, buffer.op);
        end

        $display("--@%gns [DRIVER] End Run Task--\n", $time);
    endtask
endclass : Driver

`endif
