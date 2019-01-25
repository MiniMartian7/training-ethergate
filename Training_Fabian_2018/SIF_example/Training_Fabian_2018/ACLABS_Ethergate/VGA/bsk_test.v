module rtl_smpte(
    red_px,
    green_px,
    blue_px,
    h_out,
    v_out,
    clk,
    rst
);

//input and output
input clk, rst;
output h_out, v_out;
output [2:0] red_px, green_px;
output [1:0] blue_px;

//clock
reg clk_25;

//combinational
reg[9:0] h_poz_d, h_poz_ff;//the counting is done from 0
reg[9:0] v_poz_d, v_poz_ff;//the counting is done from 0

reg[9:0] v_zero_d, v_zero_ff; //visible areea
reg[9:0] h_zero_d, h_zero_ff; //visible areea 

reg h_out_d, h_out_ff;//out sync signal for HS
reg v_out_d, v_out_ff;//out sync signal for VS

reg[2:0] red_b_d, red_b_ff, green_b_d, green_b_ff;
reg[1:0] blue_b_d, blue_b_ff;
reg white;


//horizontal
parameter H_VIZ = 640; //width rez-the count is started from zero
parameter H_PULSE = 96;//retrace
parameter H_BP = 48;
parameter H_FP = 16;
parameter H_SYNC = 800;//total horizontal clock duration

//vertical
parameter V_VIZ = 480;//heigth rez-the count is started from zero
parameter V_PULSE = 2;//retrace
parameter V_BP = 33;
parameter V_FP = 10;
parameter V_SYNC = 525;//total vertical clock duration

/*-------------------------------------------------------------time*/
reg[31:0] period_cnt_d, period_cnt_ff;
reg[3:0] sec_d, sec_ff;
reg[2:0] ten_d, ten_ff;
reg[3:0] min_d, min_ff;
parameter ONE_SEC = 50000000;
parameter ONE_MIN = 60 * ONE_SEC;
parameter TEN_SEC = 10 * ONE_SEC;
/*-------------------------------------------------------------*/

/*-------------------------------------------------------------mapping*/

/*-------------------------------------------------------------*/
always @(posedge clk or posedge rst) begin//divide the clock into half
   if(rst) begin
            clk_25 <= 1'b0;
  end
 else begin
        clk_25 <= ~clk_25;
    end
end

always @(posedge clk_25 or posedge rst) begin//sequential block
    if(rst) begin
        h_poz_ff <= 10'b0;
        v_poz_ff <= 9'b0;
        red_b_ff <= 3'b0;
        green_b_ff <= 3'b0;
        blue_b_ff <= 2'b0;
        h_out_ff <= 1'b0;
        v_out_ff <= 1'b0;
        v_zero_ff <= 0;
        h_zero_ff <= 0;

        period_cnt_ff <= 0;
        sec_ff <= 'b1001;
        ten_ff <= 'b101;
        min_ff <= 'b1010;
    end
    else begin
        h_poz_ff <= h_poz_d;
        v_poz_ff <= v_poz_d;
        h_out_ff <= h_out_d;
        v_out_ff <= v_out_d;
        v_zero_ff <= v_zero_d;
        h_zero_ff <= h_zero_d;

        period_cnt_ff <= period_cnt_d;
        sec_ff <= sec_d;
        ten_ff <= ten_d;
        min_ff <= min_d;
    end
end

always @(*) begin//combinational block

    //horizontal combinational block
    h_poz_d = h_poz_ff;
    h_out_d = h_out_ff;
    v_poz_d = v_poz_ff;
    v_out_d = v_out_ff;
    red_b_d = red_b_ff;
    green_b_d = green_b_ff;
    blue_b_d = blue_b_ff;
   
    if(v_poz_ff == V_SYNC-1 && h_poz_ff == H_SYNC-1) begin/*vertical & horizontal sync*/
        v_poz_d = 0;
        h_poz_d = 0;
    end
    else if(h_poz_ff == H_SYNC - 1) begin
        v_poz_d = v_poz_d + 1;
        h_poz_d = 0;
        h_out_d = 1'b0;
        
    end
    else begin
        if(h_poz_ff < H_PULSE) begin
            h_out_d = 1'b0;
            red_b_d = 3'b0;
            green_b_d = 3'b0;
            blue_b_d = 2'b0;
        end
        else begin
            h_out_d = 1'b1;
        end
        h_poz_d = h_poz_d + 1;
    end

    if(v_poz_ff < V_PULSE) begin
        v_out_d = 1'b0;
        red_b_d = 3'b0;
        green_b_d = 3'b0;
        blue_b_d = 2'b0;
    end
    else begin
        v_out_d = 1'b1;
        if(v_poz_ff >= V_PULSE && v_poz_ff < V_PULSE + V_BP && v_poz_ff >= V_SYNC - V_FP) begin
            red_b_d = 3'b0;
            green_b_d = 3'b0;
            blue_b_d = 2'b0;
        end

        if(h_poz_ff >= H_PULSE && h_poz_ff < H_PULSE + H_BP && h_poz_ff >= H_SYNC - H_FP) begin
            red_b_d = 3'b0;
            green_b_d = 3'b0;
            blue_b_d = 2'b0;
        end
    end


    v_zero_d = v_zero_ff;
    h_zero_d = h_zero_ff;

    if(v_poz_ff == V_PULSE + V_BP) begin
        v_zero_d = 0;
        h_zero_d = 0;
    end
    else if(h_poz_ff == H_PULSE + H_BP) begin
        v_zero_d = v_zero_d + 1;
        h_zero_d = 0;
    end
    else begin
        h_zero_d = h_zero_d + 1;
    end

    if(v_zero_ff < V_VIZ && h_zero_ff < H_VIZ) begin
        red_b_d = 3'b111;
        green_b_d = 3'b111;
        blue_b_d = 2'b11;
    end
    else begin
        red_b_d = 3'b0;
        green_b_d = 3'b0;
        blue_b_d = 2'b0;
    end

end



always @(*) begin
    period_cnt_d = period_cnt_ff;
    sec_d = sec_ff;
    ten_d = ten_ff;
    min_d = min_ff;

    if(clk) begin
        if(period_cnt_ff == ONE_SEC) begin
            if(sec_ff == 0) begin
                sec_d = 'b1001;
            end
            else begin
                sec_d = sec_d - 1;
            end
        end
        else if(period_cnt_ff == TEN_SEC) begin
            if(ten_ff == 0) begin
                ten_d = 'b101;
            end
            else begin
                ten_d = ten_d - 1;
            end
        end
        else if(period_cnt_ff == ONE_MIN) begin
            period_cnt_d = 0;
            if(min_ff == 0) begin
                sec_d = 0;
                min_d = 0;
                ten_d = 0;                
            end          
            else begin
                min_d = min_d - 1; 
            end
        end
        else begin
            period_cnt_d = period_cnt_d + 1;
        end
    end
end

assign red_px = red_b_ff;
assign green_px = green_b_ff;
assign blue_px = blue_b_ff;
assign h_out = h_out_ff;
assign v_out = v_out_ff;
endmodule
