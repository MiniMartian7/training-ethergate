//  Module: sif_top
//
module top;
    sif_i TOP_i;

    sif DUT(
        .rst_b(TOP_i.nrst_i),
        .clk(TOP_i.clk_i),
        .xa_wr_s(TOP_i.xa_wr_s_i),
        .xa_rd_s(TOP_i.xa_rf_s_i),
        .xa_addr(TOP_i.xa_addr_i),
        .xa_data_wr(TOP_i.xa_data_wr_i),
        .xa_data_rd(TOP_i.xa_data_rd_i),

        .wa_wr_s(TOP_i.wa_wr_s_i),
        .wa_addr(TOP_i.wa_addr_i),
        .wa_data_wr(TOP_i.wa_data_wr)
    );

    initial begin
        uvm_config_db#(virtual sif_i)::set(null, "*", "sif_i", TOP_i);
    end
endmodule: sif_top
