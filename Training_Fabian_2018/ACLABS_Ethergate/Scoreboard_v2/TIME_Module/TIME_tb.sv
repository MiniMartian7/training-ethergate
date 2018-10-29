`timescale 1ns/100ps
module time_tb;

reg clk_tb, rst_tb;
reg [3:0] sec_digit_tb;
reg [2:0] dec_digit_tb;
reg [3:0] min_digit_tb;

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
    sec_digit_tb = 0;
    dec_digit_tb = 0;
    min_digit_tb = 0;
    #40    
    rst_tb = 0;
end

timing
#(
    .ONE_SEC(100)
)
 DUT
(
    .clk_tm(clk_tb),
    .rst_tm(rst_tb),

    .sec_digit(sec_digit_tb),
    .dec_digit(dec_digit_tb),
    .min_digit(min_digit_tb)
);
endmodule