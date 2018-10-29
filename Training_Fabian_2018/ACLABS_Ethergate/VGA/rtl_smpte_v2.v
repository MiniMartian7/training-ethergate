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
parameter v_pulse = 2;//retrace
parameter v_bp = 33;
parameter v_fp = 10;
parameter v_sync = 525;//total vertical clock duration


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

always @(*) begin//combinational block

    //horizontal combinational block
    h_poz_d = h_poz_ff;
    h_out_d = h_out_ff;
    v_poz_d = v_poz_ff;
    v_out_d = v_out_ff;
    red_b_d = red_b_ff;
    green_b_d = green_b_ff;
    blue_b_d = blue_b_ff;


if(v_poz_ff == v_sync-1 && h_poz_ff == h_sync-1) begin/*vertical & horizontal sync*/
    v_poz_d = 0;
    h_poz_d = 0;
end
else if(h_poz_ff == h_sync - 1) begin
    v_poz_d = v_poz_d + 1;
    h_poz_d = 0;
    h_out_d = 1'b0;
end
else begin
    if(h_poz_ff < h_pulse-1) begin
        h_out_d = 1'b0;
    end
    else begin
        h_out_d = 1'b1;
    end
    h_poz_d = h_poz_d + 1;
end

if(v_poz_ff < v_pulse) begin
    v_out_d = 1'b0;
    red_b_d = 3'b0;
    green_b_d = 3'b0;
    blue_b_d = 2'b0;
end
else begin
    v_out_d = 1'b1;
     if(v_poz_ff >= (v_pulse + v_bp - 1) && v_poz_ff <= (v_sync - v_fp - 1)) begin /*vertical and horizontal visible interval*/
        if(h_poz_ff >= (h_pulse + h_bp - 2) && h_poz_ff < (h_sync-h_fp-2)) begin
            if(h_poz_ff >= (h_pulse + h_bp) && h_poz_ff < (h_pulse + h_bp + h_viz/8)) begin//white
                red_b_d = 3'b111;
                green_b_d = 3'b111;
                blue_b_d = 2'b11;
            end
            else if(h_poz_ff > (h_pulse + h_bp + h_viz/8) && h_poz_ff < (h_pulse + h_bp + 2*h_viz/8)) begin//yellow
                red_b_d = 3'b111;
                green_b_d = 3'b111;
                blue_b_d = 2'b0;
            end
            else if(h_poz_ff > (h_pulse + h_bp + 2*h_viz/8) && h_poz_ff < (h_pulse + h_bp + 3*h_viz/8)) begin//cyan
                red_b_d = 3'b0;
                green_b_d = 3'b111;
                blue_b_d = 2'b11;
            end
            else if(h_poz_ff > (h_pulse + h_bp + 3*h_viz/8) && h_poz_ff < (h_pulse + h_bp + 4*h_viz/8)) begin//green
                red_b_d = 3'b0;
                green_b_d = 3'b111;
                blue_b_d = 2'b0;
            end
            else if(h_poz_ff > (h_pulse + h_bp + 4*h_viz/8) && h_poz_ff < (h_pulse + h_bp + 5*h_viz/8)) begin//magenta
                red_b_d = 3'b111;
                green_b_d = 3'b0;
                blue_b_d = 2'b11;
            end
            else if(h_poz_ff > (h_pulse + h_bp + 5*h_viz/8) && h_poz_ff < (h_pulse + h_bp + 6*h_viz/8)) begin//red
                red_b_d = 3'b111;
                green_b_d = 3'b0;
                blue_b_d = 2'b0;
            end
            else if(h_poz_ff > (h_pulse + h_bp + 6*h_viz/8) && h_poz_ff < (h_pulse + h_bp + 7*h_viz/8)) begin//blue
                red_b_d = 3'b0;
                green_b_d = 3'b0;
                blue_b_d = 2'b11;
            end
            else if(h_poz_ff > (h_pulse + h_bp + 7*h_viz/8) && h_poz_ff < (h_pulse + h_bp + 8*h_viz/8)) begin//black
                red_b_d = 3'b0;
                green_b_d = 3'b0;
                blue_b_d = 2'b0;
            end
        end
        else begin
            red_b_d = 3'b0;
            green_b_d = 3'b0;
            blue_b_d = 2'b0;
        end
    end
end





/*
    //color display
    if((h_poz_ff < ((h_viz/8)-1 + h_bp) && (h_poz_ff >= (h_bp-1)))) begin//white
        red_b_d = 3'b1;
        green_b_d = 3'b1;
        blue_b_d = 2'b1;
    end
    else if((h_poz_ff < ((h_viz/8)*2-1 + h_bp)) && (h_poz_ff >= ((h_viz/8)-1 + h_bp))) begin//yellow
        red_b_d = 3'b1;
        green_b_d = 3'b1;
        blue_b_d = 2'b0;
    end
     else if((h_poz_ff < ((h_viz/8)*3-1 + h_bp)) && (h_poz_ff >= ((h_viz/8)*2-1 + h_bp))) begin//cyan
        red_b_d = 3'b0;
        green_b_d = 3'b1;
        blue_b_d = 2'b1;
    end
     else if((h_poz_ff < ((h_viz/8)*4-1 + h_bp)) && (h_poz_ff >= ((h_viz/8)*3-1 + h_bp))) begin//green
        red_b_d = 3'b0;
        green_b_d = 3'b1;
        blue_b_d = 2'b0;
    end
     else if((h_poz_ff <((h_viz/8)*5-1 + h_bp)) && (h_poz_ff >= ((h_viz/8)*4-1 + h_bp))) begin//magenta
        red_b_d = 3'b1;
        green_b_d = 3'b0;
        blue_b_d = 2'b1;
    end
     else if((h_poz_ff < ((h_viz/8)*6-1 + h_bp)) && (h_poz_ff >=((h_viz/8)*5-1 + h_bp))) begin//red
        red_b_d = 3'b1;
        green_b_d = 3'b0;
        blue_b_d = 2'b0;
    end
     else if((h_poz_ff < ((h_viz/8)*7-1 + h_bp)) && (h_poz_ff >= ((h_viz/8)*6-1 + h_bp))) begin//blue
        red_b_d = 3'b0;
        green_b_d = 3'b0;
        blue_b_d = 2'b1;
    end
     else if((h_poz_ff < ((h_viz/8)*8-1)) && (h_poz_ff >= ((h_viz/8)*7-1 + h_bp))) begin//black
        red_b_d = 3'b0;
        green_b_d = 3'b0;
        blue_b_d = 2'b0;
    end
    else begin
        red_b_d = 3'b0;
        green_b_d = 3'b0;
        blue_b_d = 2'b0;
    end*/
end

assign red_px = red_b_ff;
assign green_px = green_b_ff;
assign blue_px = blue_b_ff;
assign h_out = h_out_ff;
assign v_out = v_out_ff;

endmodule
