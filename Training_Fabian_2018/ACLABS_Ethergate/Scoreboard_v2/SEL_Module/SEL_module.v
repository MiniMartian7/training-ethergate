module sel(
    clk_sel,
    rst_sel,

    h_index,
    v_index,

    sel_digit
);

input clk_sel, rst_sel;
input [9:0] h_index, v_index;
output [1:0] sel_digit;

reg [1:0] sel_digit_d,sel_digit_ff;

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

parameter SEL_SEC = 'b01;
parameter SEL_TEN_SEC = 'b10;
parameter SEL_MIN = 'b11;
parameter SEL_NULL = 'b00;

parameter ENABLE = 1;
parameter DISABLE = 0;
parameter RESET = 0;

always @(posedge clk_sel or posedge rst_sel) begin
    if(rst_sel) begin
        sel_digit_ff <= RESET;
    end
    else begin
        sel_digit_ff <= sel_digit_d;
    end
end

always @(*) begin
    sel_digit_d = sel_digit_ff;
    if(v_index >= 50 && v_index < 50 + 32)
        if(h_index >= 250 && h_index < 250 + 32) begin
            sel_digit_d = SEL_SEC;
        end
        else if(h_index == 320 && h_index < 320 + 32) begin
            sel_digit_d = SEL_TEN_SEC;
        end
        else if(h_index == 450 && h_index < 450 + 32) begin
            sel_digit_d =SEL_MIN;
        end
        else begin
            sel_digit_d = SEL_NULL;
        end
    else begin
        sel_digit_d = SEL_NULL;
    end
end

assign sel_digit = sel_digit_ff;

endmodule