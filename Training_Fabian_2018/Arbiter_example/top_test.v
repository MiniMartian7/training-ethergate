module top;
logic [1:0] grant, request;
bit clk, rst;
always #5 clk = ~clk;

arb_port a1 (grant, request, rst, clk);
test t1 (grant, request, rst, clk);
endmodule