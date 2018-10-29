module out(
    clk_u,
    rst_u,

    pixel_in,

    color_out

);

input clk_u, rst_u, pixel_in;
output [7:0] color_out;

reg [7:0] color_out_d, color_out_ff;

parameter WHITE = 'hFF;
parameter BLACK = 'h0;

parameter ENABLE = 1;
parameter DISABLE = 0;
parameter RESET = 0;

always @(posedge clk_u or posedge rst_u) begin
    if(rst_u) begin
        color_out_ff <= RESET;
    end
    else begin
        color_out_ff <= color_out_d;
    end
end

always @(*) begin
    color_out_d = color_out_ff;

    if(pixel_in == ENABLE) begin
        color_out_d = WHITE;
    end
    else begin
        color_out_d = BLACK;
    end
end

assign color_out = color_out_ff;
endmodule