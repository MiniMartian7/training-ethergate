`timescale 1ns/10ps
module sif_tb;

sif_i tb_ports;
/*
modport TB (
        input clk,
        input xa_data_rd, wa_addr, wa_data_wr,
        output rst_n,
        output xa_addr, xa_data_wr,
        output xa_wr_s, xa_rd_s, wa_wr_s//enables
    );
*/

reg clk_tb, rst_n_tb, xa_wr_s_tb, xa_rd_s_tb, wa_wr_s_tb;
reg [15:0] xa_addr_tb, wa_addr_tb, xa_data_rd_tb, xa_data_wr_tb, wa_data_wr_tb;

initial begin
    clk_tb = 1'b0;
    forever begin
        #5
        clk_tb = ~clk_tb;
    end
end

initial begin
    rst_n_tb = 1'b1;
    wa_wr_s_tb = 1'b0;
    xa_rd_s_tb = 1'b0;
    wa_wr_S_tb = 1'b0;
    xa_addr_tb = 15'b0;
    wa_addr_tb = 15'b0;
    xa_data_rd = 15'b0;
    xa_data_wr_tb = 15'b0;
    wa_data_wr_tb = 15'b0;

    #20

    rst_n_tb = 1'b0;
end

always @(posedge tb_ports.clk) begin

end
endmodule