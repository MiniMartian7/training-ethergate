interface sif_i(input bit clk);
    logic rst_n;
    logic xa_wr_s, xa_rd_s, wa_wr_s;
    logic [15:0] xa_addr, wa_addr, xa_data_rd, xa_data_wr, wa_data_wr;

    clocking xmon_cb @(posedge clk);
        input xa_addr, xa_data_wr;
        input xa_data_rd;
    endclocking

    clocking wmon_cb @(posedge clk);
        input wa_addr, wa_data_wr;
        input wa_wr_s;
    endclocking

    /*clocking driver_cb @(posedge clk);
        output xa_addr, xa_data_wr;
        output xa_wr_s, xa_rd_s;
        output rst_n;
    endclocking */

    clocking dut_cb @(posedge clk)
        input clk, rst_n;

        input xa_addr, xa_data_wr;
        input xa_wr_s, xa_rd_s;

        output xa_data_rd;
        output wa_addr, wa_data_wr, wa_wr_s;
    endclocking

    clocking tb_cb @(posedge clk)
        output xa_addr, xa_data_wr;
        output xa_wr_s, xa_rd_s;
    endclocking

    task reset();
        dut_cb.rst_n <= 0;

        repeat (2) @(driver_cb);

        dut_cb.rst_n <= 1;
    endtask

    task send(input logic [15:0] sent_addr, sent_data, input logic [2:0] flags);
        @(dut_cb) begin
            dut_cb.xa_addr <= sent_addr;
            dut_cb.xa_data_wr <= sent_data;
            {dut_cb.rst_n, dut_cb.xa_wr_s, dut_cb.xa_rd_s} <= flags;
        end
    endtask
/*----------------------------------------------the read function is called from monitor
    task read(input logic [15:0] rx_data, input logic [2:0] flags);
        @(driver_cb) begin
            driver_cb.xa_data_rd <= rx_data;
            {driver_cv.rst_n, driver_cb.xa_wr_s, driver_cb.xa_rd_s} <= flags;
        end
    endtask*/

/*----------------------------------------------modports which seem useles in the presence of the clocking blocks
    modport X_MONITOR(
        clocking xmon_cb
    );

    modport W_MONITOR(
        clocking wmon_cb
    );

    modport DRIVER(
        clocking driver_cb
    );

    modport DUT(
        clocking dut_cb
    );

    modport TB(
        clocking tb_cb;
    );*/

endinterface : sif_i
