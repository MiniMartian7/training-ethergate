interface sif_i(input bit clk);
    logic rst_n;
    logic xa_wr_s, xa_rd_s, wa_wr_s;
    logic [15:0] xa_addr, wa_addr, xa_data_rd, xa_data_wr, wa_data_wr;

    clocking c_infa @(posedge clk);
        input xa_wr_s, xa_rd_s;
        input xa_addr, xa_data_wr;
        output xa_data_rd;
        output wa_addr, wa_data_wr;
        output wa_wr_s;
    endclocking;
//daca sunt deifinite in clocking directiile semnalelor, nu mai este nevoie si in modporturi definite?
    modport SIF_DUT (
        clocking c_infa
    );

    modport XW_MONITOR(
        clocking c_infa
    );
endinterface /*sif_i*/