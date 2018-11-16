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

    clocking driver_cb @(posedge clk);
        output xa_addr, xa_data_wr;
        output xa_wr_s, xa_rd_s;
        output rst_n;
        input xa_data_rd;
    endclocking 

    modport X_MONITOR(
        clocking xmon_cb
    );

    modport W_MONITOR(
        clocking wmon_cb
    );

    modport DRIVER(
        clocking driver_cb
    );
endinterface /*sif_i*/