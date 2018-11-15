`include "class_transaction.sv"

`define D_I driver_i.DRIVER.driver_cb 
`define M_I driver_i.X_MONITOR.xmon_cb

class driver;
    virtual sif_i driver_i;
    Operation gen2driver[$];

    int nr_trans = 0;

    function new(virtual sif_i ev_i, Operation ev_q[$]);
        driver_i = ev_i;
        gen2driver = ev_q;
    endfunction /*new()*/

    task reset;
        $display("--@%gns [DRIVER] Reset Task--\n");
        /*aici trebuie sa acceses resetul tot prin clocking block?*/
        wait(!driver_i.rst_n);

        `D_I.xa_addr <= 0;
        `D_I.xa_data_wr <= 0;
        `D_I.xa_data_rd <= 0;
        `D_I.xa_wr_s <= 0;
        `D_I.xa_rd_s <= 0;

        wait(driver_i.rst_n);

        $display("--@%gns [DRIVER] End Reset Task--\n");
    endtask

    task drive;
        $display("--@%gns [DRIVER] Drive Task--\n", $time);

        forever begin
            /* am nevoie tot timpul sa fac un nou handle? get_front nu imi updateaza cu noua tranzactie daca declar handle-ul pe clasa?*/
            Operation trans;

            /*aici nu ar fi bine sa controlez en_flags in functie de operatia generata, prin if/assert-uri?*/

            `D_I.xa_wr_s <= 0;
            `D_I.xa_rd_s <= 0;

            $display("--@%gns [DRIVER] Transaction Packet Count :: %d--\n", $time, count_trans);

            gen2driver.get_front(trans);

            `D_I.xa_data_wr = trans.wr_data;
            `D_I.xa_addr = trans.addr;

            `M_I.xa_data_rd = `D_I.xa_data_rd;
            `M_I.xa_data_wr = trans.wr_data;
            `M_I.xa_addr = trans.xa_addr;

            nr_trans++;
        end

        $display("--@%gns [DRIVER] End Drive Task--\n", $time);
    endtask
endclass