module Top(
    clk_top,
    rst_top,
    
    v_out,
    h_out,

    display_out
);

/*-----------------------------------------------------I/O*/

input clk_top, rst_top;
output v_out, h_out;
output [7:0] display_out;

/*--------------------------------------------------CLK_module*/

wire clk_25_top;

/*--------------------------------------------------VGA_module*/

wire [9:0] vga_horizontal_x_top;
wire [9:0] vga_vertical_y_top;

/*--------------------------------------------------SEL_module*/

wire [1:0] sel_digit_top;
wire sel_en_mem_top;

wire [4:0] sel_line_top;

wire sel_pixel_out_top;

/*--------------------------------------------------TIME_module*/

wire [3:0] tm_sec_digit_top;
wire [2:0] tm_dec_digit_top;
wire [3:0] tm_min_digit_top;

/*-----------------------------------------------MUX_module*/

wire [3:0] mux_digit_out_top;

/*-----------------------------------------------MEM_module*/

wire [31:0] mem_line_out_top;

/*-----------------------------------------------OUT_module*/


/*-----------------------------------------------------PARAMETERS*/

parameter H_VIZ = 'd640;
parameter V_VIZ = 'd480;
parameter ENABLE = 1;
parameter DISABLE = 0;
parameter RESET = 0;

/*-----------------------------------------------------*/

clk DUT_CLK(
    .clk_clk(clk_top),
    .rst_clk(rst_top),

    .clk_25(clk_25_top)
);

/*-----------------------------------------------------*/

vga DUT_VGA(
    .clk_vga(clk_25_top), 
    .rst_vga(rst_top), 

    .h_out_vga(h_out),
    .v_out_vga(v_out),

    .horizontal_x_vga(vga_horizontal_x_top),
    .vertical_y_vga(vga_vertical_y_top)
);

/*-----------------------------------------------------*/

timing DUT_TM(
    .clk_tm(clk_25_top),
    .rst_tm(rst_top),

    .sec_digit(tm_sec_digit_top),
    .dec_digit(tm_dec_digit_top),
    .min_digit(tm_min_digit_top)
);

/*-----------------------------------------------------*/
mux DUT_MUX(
    .clk_mux(clk_25_top),
    .rst_mux(rst_top),

    .sec_digit_in(tm_sec_digit_top),
    .dec_digit_in(tm_dec_digit_top),
    .min_digit_in(tm_min_digit_top),

    .sel_in(sel_digit_top),
    .digit_out(mux_digit_out_top)
);

/*-----------------------------------------------------*/

sel DUT_SEL(
    .clk_sel(clk_25_top),
    .rst_sel(rst_top),

    .h_index(vga_horizontal_x_top),
    .v_index(vga_vertical_y_top),

    .digit_sel(sel_digit_top),
    .en_mem(sel_en_mem_top),
    .line_sel(sel_line_top),

    .pixel_out(sel_pixel_out_top),

    .line_buffer(mem_line_out_top)

);

/*-----------------------------------------------------*/

mem DUT_MEM(
    .clk_mem(clk_25_top),
    .rst_mem(rst_top),

    .en_in(sel_en_mem_top),
    .digit_in(mux_digit_out_top),
    .line_in(sel_line_top),

    .line_out(mem_line_out_top)
);

/*-----------------------------------------------------*/

out DUT_OUT(
    .clk_u(clk_25_top),
    .rst_u(rst_top),

    .pixel_in(sel_pixel_out_top),

    .color_out(display_out)
);


/*-----------------------------------------------------*/

endmodule