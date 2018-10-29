
module enable(
    rst_en,
    clk_en,
    stm_p_en, /*second, ten, minute pulses*/
    enable_en,/*module enable*/

    mem_position_out,/*enable display location pulses*/
    mem_id_out/*enable memory location pulses*/

    /*red_px_en,
    green_px_en,
    blue_px_en*/
);

/*-----------------------------------------------------I/O*/

input clk_en, rst_en, enable_en;
input [1:0] stm_p_en;
output [2:0] mem_position_out;
output [3:0] mem_id_out;

/*output [2:0] red_px_en, green_px_en;
output [1:0] blue_px_en;*/

/*-----------------------------------------------------combinational*/

reg [9:0] h_coord_d, h_coord_ff;/*visual interval coordinates*/
reg [9:0] v_coord_d, v_coord_ff;

/*reg[2:0] red_b_d, red_b_ff, green_b_d, green_b_ff;
reg[1:0] blue_b_d, blue_b_ff;*/

reg[2:0] mem_position_d, mem_position_ff;
reg[3:0] mem_id_d, mem_id_ff;

/*reg[2:0] color_d, color_ff;*/

/*-----------------------------------------------------PARAMETERS*/
parameter H_VIZ = 'd640;
parameter V_VIZ = 'd480;

parameter ENABLE = 1;
parameter DISABLE = 0;
parameter RESET = 0;

parameter ONE_SEC = 'b01;/*signaling for one pulse*/
parameter TEN_SEC = 'b10;/*signaling for ten pulse*/
parameter ONE_MIN = 'b11;/*signaling for one min pulse*/

parameter POSITION_NULL = 'b111;
parameter POSITION_ZERO = 'b000;
parameter POSITION_ONE = 'b001;

parameter ELEMENT_ZERO = 'b0000;
parameter ELEMENT_ONE = 'b0001;
parameter ELEMENT_TWO = 'b0010;
parameter ELEMENT_THREE = 'b0011;
parameter ELEMENT_FOUR = 'b0100;
parameter ELEMENT_FIVE = 'b0101;
parameter ELEMENT_SIX = 'b0110;
parameter ELEMENT_SEVEN = 'b0111;
parameter ELEMENT_EIGHT = 'b1000;
parameter ELEMENT_NINE = 'b1001;
parameter ELEMENT_NULL = 'b1010;

/*-----------------------------------------------------*/

always @(posedge clk_en or posedge rst_en) begin
    if(rst_en) begin
        mem_position_ff <= POSITION_ZERO;
        mem_id_ff <= ELEMENT_ZERO;

        h_coord_ff <= RESET;
        v_coord_ff <= RESET;

        /*red_b_ff <= RESET; /*red color*/
        /*green_b_ff <= RESET; /*green color*/
        /*blue_b_ff <= RESET; /*blue color*/

        /*color_ff <= RESET;*/
    end
    else if(enable_en)begin
        mem_position_ff <= mem_position_d;
        mem_id_ff <= mem_id_d;

        h_coord_ff <= h_coord_d;
        v_coord_ff <= v_coord_d;

        /*red_b_ff <= red_b_d;
        green_b_ff <= green_b_d;
        blue_b_ff <= blue_b_d;*/

        /*color_ff <= color_d;*/
    end
    else begin
        mem_position_ff <= POSITION_NULL;
        mem_id_ff <= ELEMENT_NULL;

        h_coord_ff <= DISABLE;
        v_coord_ff <= DISABLE;

        /*red_b_ff <= DISABLE; /*red color*/
        /*green_b_ff <= DISABLE; /*green color*/
        /*blue_b_ff <= DISABLE; /*blue color*/
    end
end

/*-----------------------------------------------------*/

always @(*) begin
    h_coord_d = h_coord_ff;
    v_coord_d = v_coord_ff;

    mem_position_d = mem_position_ff;
    mem_id_d = mem_id_ff;

    if(v_coord_ff == V_VIZ - 1 && h_coord_ff == H_VIZ - 1) begin
        h_coord_d = DISABLE;
        v_coord_d = DISABLE;
    end
    else if(h_coord_ff == H_VIZ - 1) begin
        h_coord_d = RESET;
        v_coord_d = v_coord_d + 1;
    end
    else begin
        h_coord_d = h_coord_d + 1;
    end

    if(h_coord_ff < 30 && v_coord_ff < 40) begin
        mem_position_d = POSITION_ZERO;
    end
    else begin
        mem_position_d = POSITION_NULL;
    end

    if(stm_p_en == ONE_SEC) begin
        mem_id_d = ELEMENT_ZERO;
    end
    else if(stm_p_en == TEN_SEC) begin
        mem_id_d = ELEMENT_FIVE;
    end
    else if(stm_p_en == ONE_MIN) begin
        mem_id_d = ELEMENT_NINE;
    end

end

/*-----------------------------------------------------*/

assign mem_position_out = mem_position_ff;
assign mem_id_out = mem_id_ff;

/*assign red_px_en = red_b_ff;
assign green_px_en = green_b_ff;
assign blue_px_en = blue_b_ff;*/

/*-----------------------------------------------------*/

endmodule