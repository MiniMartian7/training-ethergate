module mux(
    clk_mux,
    rst_mux,

    sec_digit_in,
    dec_digit_in,
    min_digit_in,

    sel_in,
    digit_out
);

input clk_mux, rst_mux;
input [3:0] sec_digit_in, min_digit_in;
input [2:0] dec_digit_in;
input [1:0] sel_in;
output [3:0] digit_out;

reg [3:0] digit_d, digit_ff;

parameter SEL_SEC = 'b01;
parameter SEL_TEN_SEC = 'b10;
parameter SEL_MIN = 'b11;
parameter SEL_NULL = 'b00;

parameter NULL = 'b1111;

parameter ENABLE = 1;
parameter DISABLE = 0;
parameter RESET = 0;

always @(posedge clk_mux or posedge rst_mux) begin
    if(rst_mux) begin
        digit_ff <= RESET;
    end
    else begin
        digit_ff <= digit_d;
    end
end

always @(*) begin
    digit_d = digit_ff;

    if(sel_in == SEL_SEC) begin
        digit_d = sec_digit_in;
    end
    else if(sel_in == SEL_TEN_SEC) begin
        digit_d = dec_digit_in;
    end
    else if(sel_in == SEL_MIN) begin
        digit_d = min_digit_in;
    end
    else if(sel_in == SEL_NULL) begin
        digit_d = NULL;
    end
end

assign digit_out = digit_ff;

endmodule