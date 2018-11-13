`include "class_transaction.sv"
`include "class_gen.sv"
`include "class_drive.sv"

class enviroment;
    Generator ev_gen;
    Driver ev_driver;

    Operation ev_q[$];

    event gen_ended;

    virtual sif_i ev_i;

    function new(virtual sif_i ev_i);
        this.ev_i = ev_i;
        ev_gen = new(ev_q);
        ev_driver = new(ev_i, ev_q);
    endfunction

    task pre_test();
        ev_driver.reset();
    endtask

    task test();
        fork
            ev_gen.main();
            ev_driver.main();
        join_any
    endtask

    task post_test();
        wait(gen_ended.triggered);
        wait(ev_gen.repeat_count == ev_driver.nr_trans);
    endtask

    task run()
        pre_test();
        test();
        post_test();
        $finish;
    endtask
    
endclass //enviroment