`timescale 1us/1us

/*timescale [time unit]/[time accuracy]*/
/*1Hz = 1 s | 1kHz = 1ms | 1MHz = 1us | 1GHz = 1ns | 1THz = 1ps*/

module sif_top;
    reg clk_top;

    parameter CLK_FREQ = 50;/*KHz*/
    parameter CLK_PERIOD = 1000 / CLK_FREQ;/*uS*/
    parameter CLK_HALF_PERIOD = CLK_PERIOD / 2;/*uS*/

    initial begin
	    clk_top = 1'b0;
        forever begin
            #CLK_HALF_PERIOD
	        clk_top = ~clk_top;/*50KHz clk*/
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
