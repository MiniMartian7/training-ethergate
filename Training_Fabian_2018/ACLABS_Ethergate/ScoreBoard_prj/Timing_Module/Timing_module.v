module timing(
    clk_tm,
    rst_tm,
    
    sec_digit,
    dec_digit,
    min_digit
);

/*-----------------------------------------------------I/O*/

input clk_tm, rst_tm;
output [3:0] sec_digit;
output [2:0] dec_digit;
output [3:0] min_digit;

/*-----------------------------------------------------combinational*/
reg [3:0] sec_digit_d, sec_digit_ff;
reg [2:0] dec_digit_d. dec_digit_ff;
reg [3:0] min_digit_d, min_digit_ff;

reg [30:0] period_cnt_d, period_cnt_ff;


/*-----------------------------------------------------PARAMETERS*/
parameter ONE_SEC = 'd25000000;/*value of one second on a 25 MHz clock*/
parameter TEN_SEC = 'd250000000;
parameter TWENTY_SEC = 'd500000000;
parameter THIRTY_SEC = 'd750000000;
parameter FOURTY_SEC = 'd1000000000;
parameter FIFTY_SEC = 'd1250000000;
parameter ONE_MIN = 'd1500000000;

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

parameter ENABLE = 1;
parameter DISABLE = 0;
parameter RESET = 0;

/*-----------------------------------------------------*/

always @(posedge clk_tm or posedge rst_tm) begin
    if(rst_tm) begin
        period_cnt_ff <= RESET;

        sec_digit_ff <= ZERO;
        dec_digit_ff <= ZERO;
        min_digit_ff <= ZERO;
    end
    else begin
        period_cnt_ff <= period_cnt_d;
        
        sec_digit_ff <= sec_digit_d;
        dec_digit_ff <= dec_digit_d;
        min_digit_ff <= min_digit_d;
    end
end

/*-----------------------------------------------------*/

always @(*) begin
    period_cnt_d = period_cnt_ff;

    sec_digit_d = sec_digit_ff;
    dec_digit_d = dec_digit_ff;
    min_digit_d = min_digit_ff;
    
    if(period_cnt_ff == ONE_SEC) begin
        if(sec_digit_d == ZERO) begin
            sec_digit
        end
    end
   
end

/*-----------------------------------------------------*/

assign sec_digit = sec_digit_ff;
assign dec_digit = dec_digit_ff;
assign min_digit = min_digit_ff;

/*-----------------------------------------------------*/

endmodule