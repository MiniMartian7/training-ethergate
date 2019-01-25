module sel(
    clk_sel,
    rst_sel,

    h_index,
    v_index,

    line_buffer,

    digit_sel,
    en_mem,
    line_sel,

    pixel_out
);

input clk_sel, rst_sel;
input [9:0] h_index, v_index;
input [31:0] line_buffer;

output [1:0] digit_sel;
output [4:0] line_sel;
output en_mem, pixel_out;

reg [1:0] digit_sel_d,digit_sel_ff;
reg [4:0] h_map_d, h_map_ff;
reg [4:0] v_map_d, v_map_ff;

reg en_mem_d, en_mem_ff;
reg pixel_out_d, pixel_out_ff;

parameter ZERO = 'd0;
parameter ONE = 'd1;
parameter TWO = 'd2;
parameter THREE = 'd3;
parameter FOUR = 'd4;
parameter FIVE = 'd5;
parameter SIX = 'd6;
parameter SEVEN = 'd7;
parameter EIGTH = 'd8;
parameter NINE = 'd9;
parameter TEN = 'd10;

parameter CHAR_HEIGTH = 'd32;
parameter CHAR_WIDTH = 'd32;

parameter V_TOP_POS_PERIOD_TIMER = 100;
parameter V_BOT_POS_PERIOD_TIMER = 132;

parameter H_LEFT_POS_PERIOD_MIN = 100;
parameter H_RIGHT_POS_PERIOD_MIN = 132;

parameter H_LEFT_POS_PERIOD_DEC = 200;
parameter H_RIGHT_POS_PERIOD_DEC = 232;

parameter H_LEFT_POS_PERIOD_SEC = 300;
parameter H_RIGHT_POS_PERIOD_SEC = 332; 

parameter SEL_SEC = 'b01;
parameter SEL_TEN_SEC = 'b10;
parameter SEL_MIN = 'b11;

parameter NULL = 'b00;

parameter ENABLE = 1;
parameter DISABLE = 0;
parameter RESET = 0;

parameter DIGIT_DELAY = 3;
parameter ENABLE_MEM_DELAY = 2;

always @(posedge clk_sel or posedge rst_sel) begin
    if(rst_sel) begin
        digit_sel_ff <= RESET;

        en_mem_ff <= RESET;
        pixel_out_ff <= RESET;

        h_map_ff <= RESET;
        v_map_ff <= RESET;
    end
    else begin
        digit_sel_ff <= digit_sel_d;

        en_mem_ff <= en_mem_d;
        pixel_out_ff <= pixel_out_d;

        h_map_ff <= h_map_d;
        v_map_ff <= v_map_d;
    end
end

always @(*) begin
    digit_sel_d = digit_sel_ff;

    en_mem_d = en_mem_ff;
    pixel_out_d = pixel_out_ff;

    h_map_d = h_map_ff;
    v_map_d = v_map_ff;


    if(v_index >= V_TOP_POS_PERIOD_TIMER && v_index < V_BOT_POS_PERIOD_TIMER) begin
        if(h_index >= H_LEFT_POS_PERIOD_MIN - DIGIT_DELAY && h_index < H_RIGHT_POS_PERIOD_MIN) begin
            digit_sel_d = SEL_MIN;
        end
        else if(h_index >= H_LEFT_POS_PERIOD_DEC - DIGIT_DELAY && h_index < H_RIGHT_POS_PERIOD_DEC) begin
            digit_sel_d = SEL_TEN_SEC;
        end
        else if(h_index >= H_LEFT_POS_PERIOD_SEC - DIGIT_DELAY && h_index < H_RIGHT_POS_PERIOD_SEC) begin
            digit_sel_d = SEL_SEC;
        end

        if(h_index >= H_LEFT_POS_PERIOD_MIN - ENABLE_MEM_DELAY && h_index < H_RIGHT_POS_PERIOD_MIN) begin
            en_mem_d = ENABLE;
        end
        else if(h_index >= H_LEFT_POS_PERIOD_DEC - ENABLE_MEM_DELAY && h_index < H_RIGHT_POS_PERIOD_DEC) begin
            en_mem_d = ENABLE;
        end
        else if(h_index >= H_LEFT_POS_PERIOD_SEC - ENABLE_MEM_DELAY && h_index < H_RIGHT_POS_PERIOD_SEC) begin
            en_mem_d = ENABLE;
        end
        else begin
            en_mem_d = DISABLE;
        end
    end
    else begin
        en_mem_d = DISABLE;
    end

    if(en_mem_ff == ENABLE) begin
        if(h_map_ff == CHAR_WIDTH - 1 && h_index >= H_RIGHT_POS_PERIOD_SEC) begin
            h_map_d = RESET;
            v_map_d = v_map_d + 1;
        end
        if(h_map_ff == CHAR_WIDTH - 1) begin
            h_map_d = RESET;
        end
        else begin
            if(h_index == H_LEFT_POS_PERIOD_MIN || h_index == H_LEFT_POS_PERIOD_DEC || h_index == H_LEFT_POS_PERIOD_SEC) begin
            h_map_d = RESET;
            end
            else begin
            h_map_d = h_map_d + 1;
            end
        end

        if(h_map_ff == CHAR_HEIGTH - 1) begin
            pixel_out_d = DISABLE;
        end
        else if(((line_buffer << h_map_ff) & 'h80000000) == 'h80000000) begin
            pixel_out_d = ENABLE;
        end
        else begin
            pixel_out_d = DISABLE;
        end
    end
    else if(v_map_ff == CHAR_HEIGTH - 1 && h_map_ff == CHAR_WIDTH - 1) begin
            v_map_d = RESET;
            h_map_d = RESET;
    end 

end

assign digit_sel = digit_sel_ff;

assign en_mem = en_mem_ff;
assign line_sel = v_map_ff;

assign pixel_out = pixel_out_ff;


endmodule