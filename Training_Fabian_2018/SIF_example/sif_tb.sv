`include "sif_interface.sv"

module sif_top;
    bit clk_top;

    initial begin
        forever begin
            #5 clk_top = ~clk_top;
        end
    end

    program automatic ev_test;
        Enviroment tb_ev;
        tb_ev = new();
        tb_ev.run();
    endprogram

    sif_i INTERFACE (
        .clk(clk_top)
    );

    sif DUT(
        .clk(clk_top),
        .rst_b(INTERFACE.rst_n),
        .xa_wr_s(INTERFACE.DUT.dut_cb.xa_wr_s),
        .xa_rd_s(INTERFACE.DUT.dut_cb.xa_rd_s),
        .xa_addr(INTERFACE.DUT.dut_cb.xa_addr),
        .xa_data_rd(INTERFACE.DUT.dut_cb.xa_data_rd),
        .xa_data_wr(INTERFACE.DUT.dut_cb.xa_data_wr),

        .wa_addr(INTERFACE.DUT.dut_cb.wa_addr),
        .wa_data_wr(INTERFACE.DUT.dut_cb.wa_data_wr),
        .wa_wr_s(INTERFACE.DUT.dut_cb.wa_wr_s)
    );

    /*sif DUT(
        .DUT_i(INTERFACE.DUT)
    );*/
endmodule : top