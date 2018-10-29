interface sif_i(input bit clk);
    logic rst_n;
    logic xa_wr_s, xa_rd_s, wa_wr_s;
    logic [15:0] xa_addr, wa_addr, xa_data_rd, xa_data_wr, wa_data_wr;

    modport TB (
        input clk,
        input xa_data_rd, wa_addr, wa_data_wr,
        output rst_n,
        output xa_addr, xa_data_wr,
        output xa_wr_s, xa_rd_s, wa_wr_s/*enables*/
    );

    modport SIF_DUT (
        input clk, rst_n,
        input xa_addr, xa_data_wr,
        input xa_wr_s, xa_rd_s, wa_wr_s/*enables*/
        output xa_data_rd, wa_addr, wa_data_wr
    );

    modport X_MONITOR(
        input clk, rst_n,
        input xa_addr, xa_data_wr, xa_data_rd,
        input xa_wr_s, xa_rd_s/*enables*/
    );

    modport W_MONITOR(
        input clk, rst_n;
        input wa_addr, wa_data_wr;
        input wa_wr_s/*enables*/
    );
endinterface /*sif_i*/