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
reg mem_nr_0 [0:39] [0:29];
wire mem_nr_0_data;

reg mem_nr_1 [0:39] [0:29];
wire mem_nr_1_data;

reg mem_nr_2 [0:39] [0:29];
wire mem_nr_2_data;

reg mem_nr_3 [0:39] [0:29];
wire mem_nr_3_data;

reg mem_nr_4 [0:39] [0:29];
wire mem_nr_4_data;

reg mem_nr_5 [0:39] [0:29];
wire mem_nr_5_data;

reg mem_nr_6 [0:39] [0:29];
wire mem_nr_6_data;

reg mem_nr_7 [0:39] [0:29];
wire mem_nr_7_data;

reg mem_nr_8 [0:39] [0:29];
wire mem_nr_8_data;

reg mem_nr_9 [0:39] [0:29];
wire mem_nr_9_data;

reg mem nr_10 [0:39] [0:64];
wire mem_nr_10_data;

reg[5:0] i;
reg[4:0] j;
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

        period_cnt_ff <= 0;
        sec_ff <= 'b1001;
        ten_ff <= 'b101;
        min_ff <= 'b1010;
/*----------------------------------------------------------zero*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_0 [i][j] = 'b1;
            end
        end

        for(i = 5 ; i < 34; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_0 [i][j] = 'b1;
            end
            for(j = 5; j < 24; j = j + 1) begin
                mem_nr_0 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_0 [i][j] = 'b1;
            end
        end
        
        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_0 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------one*/
        for(i = 0; i < 40; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_1 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_1 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------two*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_2 [i][j] = 'b1;
            end
        end

        for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_2 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_2 [i][j] = 'b1;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_2 [i][j] = 'b1;
            end
        end

       for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_2 [i][j] = 'b1;
            end
            for(j = 5; j < 30; j = j + 1) begin
                mem_nr_2 [i][j] = 'b0;
            end
       end
        
        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_2 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------three*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_3 [i][j] = 'b1;
            end
        end

        for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_3 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_3 [i][j] = 'b1;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_3 [i][j] = 'b1;
            end
        end

         for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_3 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_3 [i][j] = 'b1;
            end
       end
        
        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_3 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------four*/
        for(i = 0; i < 15; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_4 [i][j] = 'b1;
            end
             for(j = 5; j < 30; j = j + 1) begin
                mem_nr_4 [i][j] = 'b0;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_4 [i][j] = 'b1;
            end
        end

        for(i = 20 ; i < 40; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_4 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_4 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------five*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_5 [i][j] = 'b1;
            end
        end

         for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_5 [i][j] = 'b1;
            end
            for(j = 5; j < 30; j = j + 1) begin
                mem_nr_5 [i][j] = 'b0;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_5 [i][j] = 'b1;
            end
        end
        
        for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_5 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_5 [i][j] = 'b1;
            end
        end

        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_5 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------six*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
        end

         for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
            for(j = 5; j < 30; j = j + 1) begin
                mem_nr_6 [i][j] = 'b0;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
        end
        
        for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
            for(j = 5; j < 24; j = j + 1) begin
                mem_nr_6 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
        end

        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_6 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------seven*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_7 [i][j] = 'b1;
            end
        end

        for(i = 5; i < 40; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_7 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_7 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------eight*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
        end

        for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
            for(j = 5; j < 24; j = j + 1) begin
                mem_nr_8 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
        end
        
        for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
            for(j = 5; j < 24; j = j + 1) begin
                mem_nr_8 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
        end

        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_8 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------nine*/
        for(i = 0; i < 5; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
        end

        for(i = 5 ; i < 15; i = i + 1) begin
            for(j = 0; j < 5; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
            for(j = 5; j < 24; j = j + 1) begin
                mem_nr_9 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
        end

        for(i = 15; i < 20; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
        end
        
        for(i = 20 ; i < 34; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_9 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
        end

        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 0; j < 30; j = j + 1) begin
                mem_nr_9 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------ten*/
        for(i = 0; i < 40; i = i + 1) begin
            for(j = 0; j < 24; j = j + 1) begin
                mem_nr_10 [i][j] = 'b0;
            end
            for(j = 24; j < 30; j = j + 1) begin
                mem_nr_10 [i][j] = 'b1;
            end
        end

        for(i = 0; i < 5; i = i + 1) begin
            for(j = 35; j < 65; j = j + 1) begin
                mem_nr_10 [i][j] = 'b1;
            end
        end

        for(i = 5 ; i < 34; i = i + 1) begin
            for(j = 35; j < 40; j = j + 1) begin
                mem_nr_10 [i][j] = 'b1;
            end
            for(j = 40; j < 60; j = j + 1) begin
                mem_nr_10 [i][j] = 'b0;
            end
            for(j = 60; j < 65; j = j + 1) begin
                mem_nr_10 [i][j] = 'b1;
            end
        end
        
        for(i = 34 ; i < 40; i = i + 1) begin
            for(j = 35; j < 65; j = j + 1) begin
                mem_nr_0 [i][j] = 'b1;
            end
        end
/*-------------------------------------------------------------*/
    end
    else begin
        h_poz_ff <= h_poz_d;
        v_poz_ff <= v_poz_d;
        red_b_ff <= red_b_d;
        green_b_ff <= green_b_d;
        blue_b_ff <= blue_b_d;
        h_out_ff <= h_out_d;
        v_out_ff <= v_out_d;

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
        if(h_poz_ff < H_PULSE-1) begin
            h_out_d = 1'b0;
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
        if(v_poz_ff >= (V_PULSE + V_BP - 1) && v_poz_ff <= (V_SYNC - V_FP - 1)) begin /*vertical visible interval*/
            if(h_poz_ff >= (H_PULSE + H_BP - 2) && h_poz_ff < (H_SYNC - H_FP - 2))begin /*horizontal visible interval*/
                if(v_poz_ff < V_PULSE + V_BP - 1 + 40) begin
                    if(h_poz_ff < H_PULSE + H_BP - 2 + 65)begin
                        case (min_d)
                            'b1010: begin
                                if(mem_nr_10_data == 1) begin
                                end
                            end
                            'b1001: begin
                            end
                            'b1000: begin
                            end
                            'b0111: begin
                            end
                            'b0110: begin
                            end
                            'b0101: begin
                            end
                            'b0100: begin
                            end
                            'b0011: begin
                            end
                            'b0010: begin
                            end
                            'b0001: begin
                            end
                            'b0000: begin
                            end
                        endcase
                    end
                    else if(h_poz_ff >= H_PULSE + H_BP - 2 + 65 && h_poz_ff < H_PULSE + H_BP - 2 + 75) begin
                    end
                    else if(h_poz_ff >= H_PULSE + H_BP - 2 + 75 && h_poz_ff < H_PULSE + H_BP - 2 + 105 begin
                        case (ten_d)
                        'b0110: begin
                            end
                            'b0101: begin
                            end
                            'b0100: begin
                            end
                            'b0011: begin
                            end
                            'b0010: begin
                            end
                            'b0001: begin
                            end
                            'b0000: begin
                            end
                        endcase
                    end
                    else if(h_poz_ff >= H_PULSE + H_BP - 2 + 110 && h_poz_ff < H_PULSE + H_BP - 2 + 140) begin
                        case (sec_d)
                            'b1001: begin
                            end
                            'b1000: begin
                            end
                            'b0111: begin
                            end
                            'b0110: begin
                            end
                            'b0101: begin
                            end
                            'b0100: begin
                            end
                            'b0011: begin
                            end
                            'b0010: begin
                            end
                            'b0001: begin
                            end
                            'b0000: begin
                            end
                        endcase
                    end
                end
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
end

always @(*) begin
    period_cnt_d = period_cnt_ff;
    sec_d = sec_ff;
    ten_d = ten_ff;
    min_d = min_ff;

    if(clk) begin
        if(period_cnt_ff == ONE_SEC) begin
            if(sec_ff == 0) begin
                sec_d = 'b1001;;
            end
            else begin
                sec_d = sec_d - 1;
            end
        end
        else if(period_cnt_ff == TEN_SEC) begin
            if(ten_ff == 0) begin
                ten_d = 'b101;;
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
assign mem_nr_0_data = mem_nr_0[v_poz_ff - V_PULSE - V_BP + 1][h_poz_ff - H_PULSE - H_BP + 2];
assign mem_nr_1_data = mem_nr_1[v_poz_ff - V_PULSE - V_BP + 1][h_poz_ff - H_PULSE - H_BP + 2 - 40];
assign mem_nr_2_data = mem_nr_2[v_poz_ff - V_PULSE - V_BP + 1][h_poz_ff - H_PULSE - H_BP + 2 - 80];
assign mem_nr_3_data = mem_nr_3[v_poz_ff - V_PULSE - V_BP + 1][h_poz_ff - H_PULSE - H_BP + 2 - 120];
assign mem_nr_4_data = mem_nr_4[v_poz_ff - V_PULSE - V_BP + 1][h_poz_ff - H_PULSE - H_BP + 2 - 160];
assign mem_nr_5_data = mem_nr_5[v_poz_ff - V_PULSE - V_BP + 1][h_poz_ff - H_PULSE - H_BP + 2 - 200];
assign mem_nr_6_data = mem_nr_6[v_poz_ff - V_PULSE - V_BP + 1][h_poz_ff - H_PULSE - H_BP + 2 - 240];
assign mem_nr_7_data = mem_nr_7[v_poz_ff - V_PULSE - V_BP + 1][h_poz_ff - H_PULSE - H_BP + 2 - 280];
assign mem_nr_8_data = mem_nr_8[v_poz_ff - V_PULSE - V_BP + 1][h_poz_ff - H_PULSE - H_BP + 2 - 320];
assign mem_nr_9_data = mem_nr_9[v_poz_ff - V_PULSE - V_BP + 1][h_poz_ff - H_PULSE - H_BP + 2 - 360];
assign mem_nr_10_data = mem_nr_10[v_poz_ff - V_PULSE - V_BP + 1][h_poz_ff - H_PULSE - H_BP + 2 - 360];
endmodule
