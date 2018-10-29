module clk(
    clk_clk,
    rst_clk,

    clk_25/*25 MHz clock generation*/
);

/*-----------------------------------------------------I/O*/

input clk_clk, rst_clk;
output clk_25;

/*-----------------------------------------------------*/

reg clk_25_out;

/*-----------------------------------------------------*/

always @(posedge clk_clk or posedge rst_clk) begin
    if(rst_clk) begin
        clk_25_out <= 0;
    end
    else begin
        clk_25_out <= ~clk_25_out;
    end
end

/*-----------------------------------------------------*/

assign clk_25 = clk_25_out;

/*-----------------------------------------------------*/

endmodule