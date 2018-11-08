interface sif_i(input bit clk);
    logic rst_n;
    logic xa_wr_s, xa_rd_s, wa_wr_s;
    logic [15:0] xa_addr, wa_addr, xa_data_rd, xa_data_wr, wa_data_wr;

    clocking cb_x @(posedge clk);
        input xa_addr, xa_data_wr,
        input xa_data_rd
    endclocking

    clocking cb_w @(posedge clk);
        input wa_addr, wa_data_wr
    endclocking

    modport SIF_DUT (
        input xa_wr_s, xa_rd_s,/*enable flags*/
        input xa_addr, xa_data_wr,
        output xa_data_rd,
        output wa_addr, wa_data_wr,
        output wa_wr_s
    );

    modport X_MONITOR(
        clocking cb_x
    );

    modport W_MONITOR(
        clocking cb_w
    );
endinterface /*sif_i*/