`timescale 1ns/1ns

module sif_top;
    reg clk_top;

    initial begin
	clk_top = 1'b0;
        forever begin
            #5ns
	    clk_top = ~clk_top;
        end
    end

    sif_i TOP_i (
        .clk(clk_top)
    );

    sif DUT(
        .clk(clk_top),
        .rst_b(TOP_i.rst_n),
        .xa_wr_s(TOP_i.dut_cb.xa_wr_s),
        .xa_rd_s(TOP_i.dut_cb.xa_rd_s),
        .xa_addr(TOP_i.dut_cb.xa_addr),
        .xa_data_rd(TOP_i.dut_cb.xa_data_rd),
        .xa_data_wr(TOP_i.dut_cb.xa_data_wr),

        .wa_addr(TOP_i.dut_cb.wa_addr),
        .wa_data_wr(TOP_i.dut_cb.wa_data_wr),
        .wa_wr_s(TOP_i.dut_cb.wa_wr_s)
    );

    sif_test TB(TOP_i);

    /*sif DUT(
        .DUT_i(TOP_i.DUT)
    );*/
endmodule : sif_top
