module Top(
    clk_top,
    rst_top,
    
    v_out,
    h_out,

    red_px,
    green_px,
    blue_px
);

/*-----------------------------------------------------I/O*/

input clk_top, rst_top;
output v_out, h_out;
output [2:0] red_px, green_px;
output [1:0] blue_px;

/*--------------------------------------------------CLK_module*/

wire clk_clk_25_in_top;

/*--------------------------------------------------VGA_module*/

wire vga_enable_out_top;

/*---------------------------------------------------EN_module*/

wire en_mem_id_out_top, en_mem_position_out_top;

/*-----------------------------------------------Timing_module*/

wire [1:0] tm_stm_p_top;

/*-----------------------------------------------MEM_module*/

/*-----------------------------------------------------PARAMETERS*/

parameter H_VIZ = 'd640;
parameter V_VIZ = 'd480;
parameter ENABLE = 1;
parameter DISABLE = 0;
parameter RESET = 0;

/*--------------------------------------------------CLK_module*/

/*--------------------------------------------------VGA_module*/



/*--------------------------------------------------EN_module*/




/*--------------------------------------------------Timing_module*/

/*-----------------------------------------------MEM_module*/

/*-----------------------------------------------------*/

clk DUT_CLK(
    .clk_clk(clk_top),
    .rst_clk(rst_top),

    .clk_25(clk_clk_25_in_top)
);

/*-----------------------------------------------------*/

vga DUT_VGA(
    .clk_vga(clk_clk_25_in_top), 
    .rst_vga(rst_top), 

    .h_out_vga(h_out),
    .v_out_vga(v_out),

    .enable_out(vga_enable_out_top)
);

/*-----------------------------------------------------*/

enable DUT_EN(
    .clk_en(clk_clk_25_in_top),
    .rst_en(rst_top),

    .stm_p_en(tm_stm_p_top),

    .mem_position_out(en_mem_position_out_top),
    .mem_id_out(en_mem_id_out_top),

    .enable_en(vga_enable_out_top)
);

/*-----------------------------------------------------*/

timing DUT_TM(
    .clk_tm(clk_clk_25_in_top),
    .rst_tm(rst_top),

    .enable_tm(vga_enable_out_top),

    .stm_p_out(tm_stm_p_top)
);

/*-----------------------------------------------------*/

mem DUT_MEM(
    .clk_mem(clk_clk_25_in_top),
    .rst_mem(rst_top),

    .red_px_mem(red_px), 
    .green_px_mem(green_px), 
    .blue_px_mem(blue_px),
    
    .mem_position_in(en_mem_position_out_top),
    .mem_id_in(en_mem_id_out_top),

    .enable_mem(vga_enable_out_top)
);

/*-----------------------------------------------------*/

endmodule