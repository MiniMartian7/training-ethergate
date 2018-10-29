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

reg[3:0] number_d, number_ff;


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
        number_ff <= 4'b0;
    end
    else begin
        h_poz_ff <= h_poz_d;
        v_poz_ff <= v_poz_d;
        red_b_ff <= red_b_d;
        green_b_ff <= green_b_d;
        blue_b_ff <= blue_b_d;
        h_out_ff <= h_out_d;
        v_out_ff <= v_out_d;
        number_ff <= number_d;
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
    number_d = number_ff;


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


number_d = 4'b0011;
if(v_poz_ff < v_pulse) begin
    v_out_d = 1'b0;
    red_b_d = 3'b0;
    green_b_d = 3'b0;
    blue_b_d = 2'b0;
end
else begin
    v_out_d = 1'b1;
    if(v_poz_ff >= (v_pulse + v_bp - 1) && v_poz_ff <= (v_sync - v_fp - 1)) begin /*vertical and horizontal visible interval*/
        if(h_poz_ff >= (h_pulse + h_bp - 2) && h_poz_ff < (h_sync-h_fp-2))begin
            case (number_ff)
            4'b0000: begin
                if((v_poz_ff < v_pulse + v_bp - 1 + 5) || (v_poz_ff >= v_pulse + v_bp - 1 + 45 && v_poz_ff < v_pulse + v_bp - 1 + 50))begin
                    if(h_poz_ff < h_pulse + h_bp - 2 + 40) begin
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
                else if((v_poz_ff >= v_pulse + v_bp - 1 + 5) && (v_poz_ff < v_pulse + v_bp - 1 + 45)) begin
                    if(h_poz_ff < h_pulse + h_bp - 2 + 10 || (h_poz_ff >= h_pulse + h_bp - 2 + 30  && h_poz_ff < h_pulse + h_bp - 2 + 40))begin
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
                else begin
                    red_b_d = 3'b0;
                    green_b_d = 3'b0;
                    blue_b_d = 2'b0;
                end
            end

            4'b0001: begin
                if((v_poz_ff < v_pulse + v_bp - 1 + 5)) begin
                     if((h_poz_ff >= h_pulse + h_bp - 2 + 20) && (h_poz_ff < h_pulse + h_bp - 2 + 40)) begin
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
                else if((v_poz_ff >= v_pulse + v_bp - 1 + 5) && (v_poz_ff < v_pulse + v_bp - 1 + 50)) begin
                    if((h_poz_ff >= h_pulse + h_bp - 2 + 30  && h_poz_ff < h_pulse + h_bp - 2 + 40))begin
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
                else begin
                    red_b_d = 3'b0;
                    green_b_d = 3'b0;
                    blue_b_d = 2'b0;
                end
            end
            4'b0010: begin
                if((v_poz_ff < v_pulse + v_bp - 1 + 5) || (v_poz_ff >= v_pulse + v_bp - 1 + 20 && v_poz_ff < v_pulse + v_bp - 1 + 25) || (v_poz_ff >= v_pulse + v_bp - 1 + 45 && v_poz_ff < v_pulse + v_bp - 1 + 50))begin
                    if(h_poz_ff < h_pulse + h_bp - 2 + 40) begin
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
                else if(v_poz_ff >= v_pulse + v_bp - 1 + 5 && v_poz_ff < v_pulse + v_bp - 1 + 20) begin
                     if((h_poz_ff >= h_pulse + h_bp - 2 + 30  && h_poz_ff < h_pulse + h_bp - 2 + 40))begin
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
                else if(v_poz_ff >= v_pulse + v_bp - 1 + 25 && v_poz_ff < v_pulse + v_bp - 1 + 45) begin
                     if(h_poz_ff < h_pulse + h_bp - 2 + 10) begin
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
                else begin
                    red_b_d = 3'b0;
                    green_b_d = 3'b0;
                    blue_b_d = 2'b0;
                end
            end
            4'b0011: begin
                if((v_poz_ff < v_pulse + v_bp - 1 + 5) || (v_poz_ff >= v_pulse + v_bp - 1 + 20 && v_poz_ff < v_pulse + v_bp - 1 + 25) || (v_poz_ff >= v_pulse + v_bp - 1 + 45 && v_poz_ff < v_pulse + v_bp - 1 + 50))begin
                    if(h_poz_ff < h_pulse + h_bp - 2 + 40) begin
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
                else if((v_poz_ff >= v_pulse + v_bp - 1 + 5) && (v_poz_ff < v_pulse + v_bp - 1 + 50)) begin
                    if((h_poz_ff >= h_pulse + h_bp - 2 + 30  && h_poz_ff < h_pulse + h_bp - 2 + 40))begin
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
                else begin
                    red_b_d = 3'b0;
                    green_b_d = 3'b0;
                    blue_b_d = 2'b0;
                end
            end
            endcase
        end
    end       
    else begin
        red_b_d = 3'b0;
        green_b_d = 3'b0;
        blue_b_d = 2'b0;
    end
end
end

assign red_px = red_b_ff;
assign green_px = green_b_ff;
assign blue_px = blue_b_ff;
assign h_out = h_out_ff;
assign v_out = v_out_ff;

endmodule
