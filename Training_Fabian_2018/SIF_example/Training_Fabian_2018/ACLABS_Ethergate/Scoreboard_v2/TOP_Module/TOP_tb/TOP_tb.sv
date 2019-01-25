`timescale 1ns/10ps
module top_tb;

/*---------------------------------------------------------------TestBench*/
reg clk_tb, rst_tb;
/*---------------------------------------------------------------TOP*/
reg h_out_tb, v_out_tb;
/*---------------------------------------------------------------CLK_25*/

reg clk_25_tb;

/*---------------------------------------------------------------VGA*/
reg [9:0] horizontal_x_tb, vertical_y_tb;
/*---------------------------------------------------------------TIMING*/
reg [3:0] sec_digit_tb, min_digit_tb;
reg[2:0] dec_digit_tb;
/*---------------------------------------------------------------SEL*/
reg [1:0] sel_digit_tb;
reg sel_en_mem_tb;

reg [4:0] sel_line_tb;
reg sel_pixel_out_tb;
/*---------------------------------------------------------------MUX*/
reg [3:0] digit_out_tb;
/*----------------------------------------------------------------MEM*/
reg [31:0] mem_line_out_tb;
/*----------------------------------------------------------------OUT*/
reg [7:0] display_out_tb;


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
        #10
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


    #120   
    rst_tb = 0;
end

clk DUT_CLK(
    .clk_clk(clk_tb),
    .rst_clk(rst_tb),

    .clk_25(clk_25_tb)
);
vga 
/*#(
    .H_VIZ(400),
    .H_PULSE(2),
    .H_BP(3),
    .H_FP(1),
    .H_SYNC(406),

    .V_VIZ(50),
    .V_PULSE(1),
    .V_BP(4),
    .V_FP(2),
    .V_SYNC(57)
)*/
DUT_VGA
(
    .clk_vga(clk_25_tb),
    .rst_vga(rst_tb),

    .h_out_vga(h_out_tb),
    .v_out_vga(v_out_tb),

    .horizontal_x_vga(horizontal_x_tb),
    .vertical_y_vga(vertical_y_tb)
);

timing
#(
    .ONE_SEC(420000)
)
 DUT_TM(
    .clk_tm(clk_25_tb),
    .rst_tm(rst_tb),

    .sec_digit(sec_digit_tb),
    .dec_digit(dec_digit_tb),
    .min_digit(min_digit_tb)
);

sel DUT_SEL(
    .clk_sel(clk_25_tb),
    .rst_sel(rst_tb),

    .h_index(horizontal_x_tb),
    .v_index(vertical_y_tb),

    .digit_sel(sel_digit_tb),
    .en_mem(sel_en_mem_tb),
    .line_sel(sel_line_tb),

    .pixel_out(sel_pixel_out_tb),

    .line_buffer(mem_line_out_tb)
);

mux DUT_MUX(
    .clk_mux(clk_25_tb),
    .rst_mux(rst_tb),

    .sec_digit_in(sec_digit_tb),
    .dec_digit_in(dec_digit_tb),
    .min_digit_in(min_digit_tb),

    .sel_in(sel_digit_tb),
    .digit_out(digit_out_tb)
);

mem DUT_MEM(
    .clk_mem(clk_25_tb),
    .rst_mem(rst_tb),

    .digit_in(digit_out_tb),

    .en_in(sel_en_mem_tb),
    .line_in(sel_line_tb),

    .line_out(mem_line_out_tb)
);

out DUT_OUT(
    .clk_u(clk_25_tb),
    .rst_u(rst_tb),

    .pixel_in(sel_pixel_out_tb),

    .color_out(display_out_tb)
);
endmodule