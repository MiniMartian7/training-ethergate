`ifndef ENVIROMENT
`define ENVIROMENT

`include "class_transaction.sv"
`include "class_gen.sv"
`include "class_driver.sv"

class enviroment;
    Generator ev_gen;
    Driver ev_driver;
    Operation ev_q[$];

    virtual sif_i ev_i;

    function new(virtual sif_i ev_interface);
        ev_i = ev_interface;
        ev_gen = new(ev_q);
        ev_driver = new(ev_interface, ev_q);
    endfunction/*new*/

    task pre_test();
        $display("--[ENVIROMENT] Reset Task--\n");

        ev_driver.reset();

        $display("--[ENVIROMENT] End Reset Task--\n");
    endtask

    task test();
        $display("--[ENVIROMENT] Fork Task--\n");

        fork
            ev_gen.generation();
            ev_driver.drive();
        join_any

        $display("--[ENVIROMENT] End Fork Task--\n");
    endtask

    task post_test();
        $display("--[ENVIROMENT] Wait Task--\n");

        wait(ev_gen.repeat_count == ev_driver.nr_trans);

        $display("--[ENVIROMENT] Afte Wait Task--\n");
    endtask

    task run();
        $display("--[ENVIROMENT] Run Task--\n");

        pre_test();
        test();
        post_test();
        $finish;

        $display("--[ENVIROMENT] End Run Task--\n");
    endtask
endclass /*enviroment*/

`endif
