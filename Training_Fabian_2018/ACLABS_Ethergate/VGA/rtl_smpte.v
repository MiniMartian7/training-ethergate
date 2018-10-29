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

reg h_out_d, h_out_ff;//out sync signal for HS
reg v_out_d, v_out_ff;//out sync signal for VS

reg[2:0] red_b_d, red_b_ff, green_b_d, green_b_ff;
reg[1:0] blue_b_d, blue_b_ff;


//horizontal
parameter h_viz = 640; //width rez-the count is started from zero
parameter h_pulse = 96;//retrace
parameter h_bp = 48;
parameter h_fp = 16;
parameter h_sync = 800;//total horizontal clock duration

//vertical
parameter v_viz = 480;//heigth rez-the count is started from zero
parameter v_pulse = 96;//retrace
parameter v_bp = 48;
parameter v_fp = 16;
parameter v_sync = 640;//total vertical clock duration


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
    end
    else begin
        h_poz_ff <= h_poz_d;
        v_poz_ff <= v_poz_d;
        red_b_ff <= red_b_d;
        green_b_ff <= green_b_d;
        blue_b_ff <= blue_b_d;
        h_out_ff <= h_out_d;
        v_out_ff <= v_out_d;
    end
end

always @(*) begin//horizontal combinational block
    h_poz_d = h_poz_ff;
    h_out_d = h_out_ff;
    if((h_poz_ff) == (h_sync-1)) begin//if the clock reached the end of the HS period
        h_poz_d = 0;
    end
    else begin
        h_poz_d = h_poz_d + 1;
    end

    if((h_poz_ff < ((h_sync-1) - h_pulse)) || (h_poz_ff == (h_sync-1))) begin
        h_out_d = 1'b1;
    end
    else begin
        h_out_d = 1'b0;
    end
end

always @(*) begin//vertical combinational block
    v_poz_d = v_poz_ff;
    v_out_d = v_out_ff;
    if((v_poz_ff == (v_sync-2)) && (h_poz_ff == (h_sync-1))) begin//if the clock reached the end of the VS period and the HS perios is done
        v_poz_d= 0;
    end
    else if((h_poz_ff) == (h_sync-1))begin
        v_poz_d = v_poz_d + 1;
    end
     
    if((h_poz_ff < ((h_sync-1) - h_pulse)) || (h_poz_ff == (h_sync-1))) begin
        v_out_d = 1'b1;
    end
    else begin
        v_out_d = 1'b0;
    end
end

always @(*) begin//color displaying
    h_poz_d = h_poz_ff;
    red_b_d = red_b_ff;
    green_b_d = green_b_ff;
    blue_b_d = blue_b_ff;

    if((h_poz_ff < ((h_viz/8)-1 + v_fp) && (h_poz_ff >= (v_fp-1)))) begin//white
        red_b_d = 3'b1;
        green_b_d = 3'b1;
        blue_b_d = 2'b1;
    end
    else if((h_poz_ff < ((h_viz/8)*2-1 + v_fp)) && (h_poz_ff >= ((h_viz/8)-1 + v_fp))) begin//yellow
        red_b_d = 3'b1;
        green_b_d = 3'b1;
        blue_b_d = 2'b0;
    end
     else if((h_poz_ff < ((h_viz/8)*3-1 + v_fp)) && (h_poz_ff >= ((h_viz/8)*2-1 + v_fp))) begin//cyan
        red_b_d = 3'b0;
        green_b_d = 3'b1;
        blue_b_d = 2'b1;
    end
     else if((h_poz_ff < ((h_viz/8)*4-1 + v_fp)) && (h_poz_ff >= ((h_viz/8)*3-1 + v_fp))) begin//green
        red_b_d = 3'b0;
        green_b_d = 3'b1;
        blue_b_d = 2'b0;
    end
     else if((h_poz_ff <((h_viz/8)*5-1 + v_fp)) && (h_poz_ff >= ((h_viz/8)*4-1 + v_fp))) begin//magenta
        red_b_d = 3'b1;
        green_b_d = 3'b0;
        blue_b_d = 2'b1;
    end
     else if((h_poz_ff < ((h_viz/8)*6-1 + v_fp)) && (h_poz_ff >=((h_viz/8)*5-1 + v_fp))) begin//red
        red_b_d = 3'b1;
        green_b_d = 3'b0;
        blue_b_d = 2'b0;
    end
     else if((h_poz_ff < ((h_viz/8)*7-1 + v_fp)) && (h_poz_ff >= ((h_viz/8)*6-1 + v_fp))) begin//blue
        red_b_d = 3'b0;
        green_b_d = 3'b0;
        blue_b_d = 2'b1;
    end
     else if((h_poz_ff < ((h_viz/8)*8-1)) && (h_poz_ff >= ((h_viz/8)*7-1 + v_fp))) begin//black
        red_b_d = 3'b0;
        green_b_d = 3'b0;
        blue_b_d = 2'b0;
    end
    else begin
        red_b_d = 3'b0;
        green_b_d = 3'b0;
        blue_b_d = 2'b0;
    end
end

assign red_px = red_b_ff;
assign green_px = green_b_ff;
assign blue_px = blue_b_ff;
assign h_out = h_out_ff;
assign v_out = v_out_ff;

endmodule
