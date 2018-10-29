module timing(
    clk_tm,
    rst_tm,
    
    sec_digit,
    dec_digit,
    min_digit
);

/*here a one tackt delay is obtained due to the difference of the counters value and the rection of the outputs*/


/*-----------------------------------------------------I/O*/

input clk_tm, rst_tm;
output [3:0] sec_digit;
output [2:0] dec_digit;
output [3:0] min_digit;

/*-----------------------------------------------------combinational*/
reg [3:0] sec_digit_d, sec_digit_ff;
reg [2:0] dec_digit_d, dec_digit_ff;
reg [3:0] min_digit_d, min_digit_ff;

reg [3:0] sec_cnt_d, sec_cnt_ff;
reg [2:0] ten_cnt_d, ten_cnt_ff;
reg [3:0] min_cnt_d, min_cnt_ff;
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
parameter TEN = 'd10;

parameter ENABLE = 1;
parameter DISABLE = 0;
parameter RESET = 0;

/*-----------------------------------------------------*/

always @(posedge clk_tm or posedge rst_tm) begin
    if(rst_tm) begin
        period_cnt_ff <= RESET;
        sec_cnt_ff <= RESET;
        ten_cnt_ff <= RESET;
        min_cnt_ff <= RESET;

        sec_digit_ff <= ZERO;
        dec_digit_ff <= ZERO;
        min_digit_ff <= ZERO;
    end
    else begin
        period_cnt_ff <= period_cnt_d;
        sec_cnt_ff <= sec_cnt_d;
        ten_cnt_ff <= ten_cnt_d;
        min_cnt_ff <= min_cnt_d;

        sec_digit_ff <= sec_digit_d;
        dec_digit_ff <= dec_digit_d;
        min_digit_ff <= min_digit_d;
    end
end

/*-----------------------------------------------------*/

always @(*) begin
    period_cnt_d = period_cnt_ff;
    sec_cnt_d = sec_cnt_ff;
    ten_cnt_d = ten_cnt_ff;
    min_cnt_d = min_cnt_ff;

    sec_digit_d = sec_digit_ff;
    dec_digit_d = dec_digit_ff;
    min_digit_d = min_digit_ff;
/*-----------------------------------------------------*/
    if(period_cnt_ff == ONE_SEC - 1 && min_cnt_ff == NINE && ten_cnt_ff == FIVE && sec_cnt_ff == NINE) begin
        period_cnt_d = RESET;
        min_digit_d = NINE;
        sec_cnt_d = RESET;
        ten_cnt_d = RESET;
        min_cnt_d = RESET;
    end
    else if(period_cnt_ff == ONE_SEC - 1 && ten_cnt_ff == FIVE && sec_cnt_ff == NINE) begin
        period_cnt_d = RESET;
        dec_digit_d = FIVE;
        sec_cnt_d = RESET;
        ten_cnt_d = RESET;
        min_cnt_d = min_cnt_d + 1;
    end
    else if(period_cnt_ff == ONE_SEC - 1 && sec_cnt_ff == NINE) begin
        period_cnt_d = RESET;
        sec_digit_d = ZERO;
        sec_cnt_d = RESET;
        ten_cnt_d = ten_cnt_d + 1;
    end
    else if(period_cnt_ff == ONE_SEC - 1) begin
        period_cnt_d = RESET;
        sec_cnt_d = sec_cnt_d + 1;
    end
    else begin
        period_cnt_d = period_cnt_d + 1;
    end

    /*-----------------------------------------------------*/
    if(min_cnt_ff == ZERO) begin
        min_digit_d = NINE;
    end
    else if(min_cnt_ff == ONE) begin
        min_digit_d = EIGTH;
    end
    else if(min_cnt_ff == TWO) begin
        min_digit_d = SEVEN;
    end
    else if(min_cnt_ff == THREE) begin
        min_digit_d = SIX;
    end
    else if(min_cnt_ff == FOUR) begin
        min_digit_d = FIVE;
    end
    else if(min_cnt_ff == FIVE) begin
        min_digit_d = FOUR;
    end
    else if(min_cnt_ff == SIX) begin
        min_digit_d = THREE;
    end
    else if(min_cnt_ff == SEVEN) begin
        min_digit_d = TWO;
    end
    else if(min_cnt_ff == EIGTH) begin
        min_digit_d = ONE;
    end
    else if(min_cnt_ff == NINE) begin
        min_digit_d = ZERO;
    end

/*-----------------------------------------------------*/

    if(ten_cnt_ff == ZERO) begin
        dec_digit_d = FIVE;
    end
    else if(ten_cnt_ff == ONE) begin
        dec_digit_d = FOUR;
    end
    else if(ten_cnt_ff == TWO) begin
        dec_digit_d = THREE;
    end
    else if(ten_cnt_ff == THREE) begin
        dec_digit_d = TWO;
    end
    else if(ten_cnt_ff == FOUR) begin
        dec_digit_d = ONE;
    end
    else if(ten_cnt_ff == FIVE) begin
        dec_digit_d = ZERO;
    end

/*-----------------------------------------------------*/
    if(sec_cnt_ff == ZERO) begin
        sec_digit_d = ZERO;

        case (dec_digit_d)
            FIVE: begin
                dec_digit_d = ZERO;
                case (min_digit_d)
                    NINE: min_digit_d = ZERO;
                    EIGTH: min_digit_d = NINE;
                    SEVEN: min_digit_d = EIGTH;
                    SIX: min_digit_d = SEVEN;
                    FIVE: min_digit_d = SIX;
                    FOUR: min_digit_d = FIVE;
                    THREE: min_digit_d = FOUR;
                    TWO: min_digit_d = THREE;
                    ONE: min_digit_d = TWO;
                    ZERO: min_digit_d = ONE;
                    default: begin
                        
                    end
                endcase
            end
            FOUR: dec_digit_d = FIVE;
            THREE: dec_digit_d = FOUR;
            TWO: dec_digit_d = THREE;
            ONE: dec_digit_d = TWO;
            ZERO: dec_digit_d = ONE;
            default: begin
                
            end
        endcase
    end
    else if(sec_cnt_ff == ONE) begin
        sec_digit_d = NINE;
    end
    else if(sec_cnt_ff == TWO) begin
        sec_digit_d = EIGTH;
    end
    else if(sec_cnt_ff == THREE) begin
        sec_digit_d = SEVEN;
    end
    else if(sec_cnt_ff == FOUR) begin
        sec_digit_d = SIX;
    end
    else if(sec_cnt_ff == FIVE) begin
        sec_digit_d = FIVE;
    end
    else if(sec_cnt_ff == SIX) begin
        sec_digit_d = FOUR;
    end
    else if(sec_cnt_ff == SEVEN) begin
        sec_digit_d = THREE;
    end
    else if(sec_cnt_ff == EIGTH) begin
        sec_digit_d = TWO;
    end
    else if(sec_cnt_ff == NINE) begin
        sec_digit_d = ONE;
    end
end
/*-----------------------------------------------------*/

assign sec_digit = sec_digit_ff;
assign dec_digit = dec_digit_ff;
assign min_digit = min_digit_ff;

/*-----------------------------------------------------*/

endmodule