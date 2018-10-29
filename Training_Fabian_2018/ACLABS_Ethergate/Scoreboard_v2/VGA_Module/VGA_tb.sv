`timescale 1ns/100ps
module vga_tb;

reg clk_tb, rst_tb;
reg [9:0] horizontal_x_tb, vertical_y_tb;
reg h_out_tb, v_out_tb;

/*parameter H_VIZ_TB = 10;
parameter H_PULSE_TB = 2;
parameter H_BP = 3;
parameter H_FP = 1;
parameter H_SYNC = 16;

parameter V_VIZ_TB = 10;
parameter V_PULSE_TB = 2;
parameter V_BP = 3;
parameter V_FP = 1;
parameter V_SYNC = 15;*/

parameter H_VIZ_TB = 640;
parameter H_PULSE_TB = 86;
parameter H_BP = 48;
parameter H_FP = 16;
parameter H_SYNC = 800;

parameter V_VIZ_TB = 480;
parameter V_PULSE_TB = 2;
parameter V_BP = 33;
parameter V_FP = 10;
parameter V_SYNC = 525;

initial begin
    clk_tb = 1'b0;
    forever begin
        #20
        clk_tb = !clk_tb;
    end
end

initial begin
    clk_tb = 1;
    rst_tb = 1;
    v_out_tb = 0;
    h_out_tb = 0;
    vertical_y_tb = 0;
    horizontal_x_tb = 0;
    #40    
    rst_tb = 0;
end

vga 
/*#(
    .H_VIZ(10),
    .H_PULSE(2),
    .H_BP(3),
    .H_FP(1),
    .H_SYNC(16),

    .V_VIZ(8),
    .V_PULSE(1),
    .V_BP(4),
    .V_FP(2),
    .V_SYNC(15)
)*/
DUT
(
    .clk_vga(clk_tb),
    .rst_vga(rst_tb),

    .h_out_vga(h_out_tb),
    .v_out_vga(v_out_tb),

    .horizontal_x_vga(horizontal_x_tb),
    .vertical_y_vga(vertical_y_tb)
);
endmodule