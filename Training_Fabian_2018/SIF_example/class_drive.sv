`define D_I v_i.DRIVER.driver_cb 
`define M_I v_i.X_MONITOR.xmon_cb

class driver;
    virtual sif_i v_i;
    Operation gen2driver[$];

    int nr_trans = 0;

    function new(virtual sif_i ev_v_i, Operation ev_gen2driver[$]);
        v_i = ev_v_i;
        gen2driver = ev_gen2driver;
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
        forever begin
        Operation trans;

        `D_I.xa_wr_s <= 0;
        `D_I.xa_rd_s <= 0;
        $display("@%gns-------------------[DRIVER]Transaction number: %d-------------", $time, nr_trans);
        gen2driver.get_front(trans);

        `D_I.xa_data_wr = trans.wr_data;
        `D_I.xa_addr = trans.addr;

        `M_I.xa_data_rd = `D_I.xa_data_rd;
        `M_I.xa_data_wr = trans.wr_data;
        `M_I.xa_addr = trans.xa_addr;
        $display("--------------[DRIVER]End Transaction-------------");

        nr_trans++;

        end
    endtask



endclass