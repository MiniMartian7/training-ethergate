`define D_I v_i.DRIVER.driver_cb 

class driver;
    virtual sif_i v_i;
    Queue_line gen2driver;

    function new(virtual sif_i ev_v_i, Queue_line ev_gen2driver);
        this.v_i = ev_v_i;
        this.gen2driver = ev_gen2driver;
    endfunction //new()

    task reset;
        wait(v_i.reset);

        $display("---------[Driver] Reset Started----------");

        `D_I.xa_addr <= 0;
        `D_I.xa_data_wr <= 0;
        `D_I.xa_data_rd <= 0;
        `D_I.xa_wr_s <= 0;
        `D_I.xa_rd_s <= 0;

        wait(!v_i.reset);

        $display("---------[Driver] Reset Ended----------");
    endtask

    task drive;
        Operation trans;

        `D_I.xa_wr_s <= 1;
        `D_I.xa_rd_s <= 1;

        gen2driver.get_front(trans);
    endtask

endclass