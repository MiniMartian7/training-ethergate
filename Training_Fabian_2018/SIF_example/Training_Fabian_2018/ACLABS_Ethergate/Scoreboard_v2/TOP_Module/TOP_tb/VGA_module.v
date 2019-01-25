module vga(
    clk_vga,
    rst_vga,

    h_out_vga,
    v_out_vga,

    horizontal_x_vga,
    vertical_y_vga
);

/*-----------------------------------------------------I/O*/

input clk_vga, rst_vga;
output h_out_vga, v_out_vga;

output [9:0] horizontal_x_vga;/*visible output horizontal position*/
output [9:0] vertical_y_vga;/*visible output vertical position*/

/*-----------------------------------------------------combinational*/

reg[9:0] h_poz_d, h_poz_ff;/*the counting is done from 0*/
reg[9:0] v_poz_d, v_poz_ff;/*the counting is done from 0*/

reg [9:0] h_x_d, h_x_ff;/*rtl for horizontal visible interval*/
reg [9:0] v_y_d, v_y_ff;/*rtl for vetical visible interval*/

reg h_out_d, h_out_ff;
reg v_out_d, v_out_ff;

/*-----------------------------------------------------PARAMETERS*/

/*horizontal*/
parameter H_VIZ = 'd640; /*width rezolution - the count is started from zero*/
parameter H_PULSE = 'd96;/*retrace*/
parameter H_BP = 'd48;
parameter H_FP = 'd16;
parameter H_SYNC = 'd800;/*total horizontal clock duration*/

/*vertical*/
parameter V_VIZ = 'd480;/*heigth rezolution - the count is started from zero*/
parameter V_PULSE = 'd2;/*retrace*/
parameter V_BP = 'd33;
parameter V_FP = 'd10;
parameter V_SYNC = 'd525;/*total vertical clock duration*/

parameter ENABLE = 1;
parameter DISABLE = 0;
parameter RESET = 0;

/*-----------------------------------------------------*/

always @(posedge clk_vga or posedge rst_vga) begin/*sequential block*/
    if(rst_vga) begin
        h_poz_ff <= RESET; /*horizontal pozition*/
        v_poz_ff <= RESET; /*vertical pozition*/

        h_out_ff <= RESET; /*horizontal output signal*/
        v_out_ff <= RESET; /*veritcal output signal*/

        h_x_ff <= RESET;
        v_y_ff <= RESET;
    end
    else begin
        h_poz_ff <= h_poz_d;
        v_poz_ff <= v_poz_d;

        h_out_ff <= h_out_d;
        v_out_ff <= v_out_d;

        h_x_ff <= h_x_d;
        v_y_ff <= v_y_d;
    end
end

/*-----------------------------------------------------*/

always @(*) begin/*combinational block*/
    h_poz_d = h_poz_ff;
    v_poz_d = v_poz_ff;

    h_out_d = h_out_ff;
    v_out_d = v_out_ff;

    h_x_d = h_x_ff;
    v_y_d = v_y_ff;

    if(v_poz_ff == V_SYNC-1 && h_poz_ff == H_SYNC-1) begin/*vertical & horizontal sync*/
        v_poz_d = RESET;
        h_poz_d = RESET;
        h_out_d = DISABLE;
        v_out_d = DISABLE;
    end
    else if(h_poz_ff == H_SYNC - 1) begin
        v_poz_d = v_poz_d + 1;
        h_poz_d = RESET;
        h_out_d = DISABLE;
    end
    else begin
        h_poz_d = h_poz_d + 1;
    end

    if(h_poz_ff == H_PULSE - 1) begin
            h_out_d = ENABLE;
            if(v_poz_ff == V_PULSE) begin
                v_out_d = ENABLE;
            end
    end

    if(h_poz_ff < H_PULSE + H_BP - 1 || h_poz_ff >= H_SYNC - H_FP - 1) begin
        h_x_d = DISABLE;
    end
    else h_x_d = h_x_d + 1;

    if(v_poz_ff < V_PULSE + V_BP - 1 || v_poz_ff >= V_SYNC - V_FP) begin
        v_y_d = DISABLE;
    end
    else if(h_poz_ff == H_SYNC - 1) begin
        v_y_d = v_y_d + 1;
    end
end

/*-----------------------------------------------------*/

assign horizontal_x_vga = h_x_ff;
assign vertical_y_vga = v_y_ff;

assign h_out_vga = h_out_ff;
assign v_out_vga = v_out_ff;

/*-----------------------------------------------------*/

endmodule
