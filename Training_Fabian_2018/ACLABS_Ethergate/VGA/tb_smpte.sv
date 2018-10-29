`timescale 1ns/10ps
module tb_smpte;

reg clk_tb, rst_tb;
reg[4:0] v_poz_tb, h_poz_tb;
reg[2:0] red_b_tb, gree_b_tb;
reg[1:0] blue_b_tb;
wire red_tb, green_tb, blue_tb, h_out_tb, v_out_tb;

/*parameter H_VIZ_TB = 10;
parameter H_PULSE_TB = 2;
parameter H_BP = 3;
parameter H_FP = 1;
parameter H_SYNC = 16;

parameter V_VIZ_TB = 10;
parameter V_PULSE_TB = 2;
parameter V_BP = 3;
parameter V_FP = 1;
parameter V_SYNC = 15;*/

parameter H_VIZ_TB = 640;
parameter H_PULSE_TB = 86;
parameter H_BP = 48;
parameter H_FP = 16;
parameter H_SYNC = 800;

parameter V_VIZ_TB = 480;
parameter V_PULSE_TB = 2;
parameter V_BP = 33;
parameter V_FP = 10;
parameter V_SYNC = 525;

initial begin
    clk_tb = 1'b0;
    forever begin
        #5
        clk_tb = !clk_tb;
    end
end

initial begin
    clk_tb = 1'b1;
    rst_tb = 1'b1;
    v_poz_tb = 'd0;
    h_poz_tb = 'd0;
    $display("@%gns rst = %b HS = %b VH = %b RED = %b GREEN = %b BLUE = %b", $time, rst_tb, h_poz_tb, v_poz_tb, red_tb, green_tb, blue_tb);
    #20    
    rst_tb = 1'b0;
end

always@(posedge DUT.clk_25) begin
    if(h_poz_tb == DUT.h_poz_ff) begin
        $display("@%gns--HS position in sync\n", $time);
        if(DUT.h_poz_ff == (H_SYNC - 1)) begin
            $display("@%gns--HS reset\n", $time);
            h_poz_tb = 0;
             if(DUT.v_poz_ff == (V_SYNC - 1)) begin
                $display("@%gns--VS reset\n",$time);//vertical position reset
                v_poz_tb = 0;
            end
            else begin
                v_poz_tb ++;//vertical position incrementation
                $display("@%gns--VS position %x\n", $time, v_poz_tb);
            end
        end
        else begin
            h_poz_tb ++;
            $display("@%gns--HS position %x\n", $time, h_poz_tb);
        end
    end
    else begin
        $display("@%gns--HS out of sync %x\n", $time, h_poz_tb);
    end
end

always@(posedge DUT.clk_25) begin
    if(v_poz_tb == DUT.v_poz_ff) begin
        $display("@%gns--VS position in sync\n",$time);
    end
    else begin
        $display("@%gns--VS out of sync %x\n", $time, v_poz_tb);
    end
end

rtl_smpte 
/*#(
    .h_viz(10),
    .h_pulse(2),
    .h_bp(3),
    .h_fp(1),
    .h_sync(16),
    .v_viz(8),
    .v_pulse(1),
    .v_bp(4),
    .v_fp(2),
    .v_sync(15)
)*/
DUT
(
    .red_px(red_tb),
    .green_px(green_tb),
    .blue_px(blue_tb),
    .h_out(h_out_tb),
    .v_out(v_out_tb),
    .clk(clk_tb),
    .rst(rst_tb)
);
endmodule