module adder
(
    bit_A,
    bit_B,
    in_c,
    out_s,
    out_c,
    clk,
    rst
);

input bit_A, bit_B, in_c, clk, rst;
output out_s, out_c;

reg out_s_d, out_s_ff;
reg out_c_d, out_c_ff;


always @(posedge clk or posedge rst) begin
    if(rst) begin
        out_s_ff <= 1'b0;
        out_c_ff <= 1'b0;
    end
    else begin
        out_s_ff <= out_s_d;
        out_c_ff <= out_c_d;
    end
end

always @(*) begin
    out_c_d = ((bit_A ^ bit_B) & in_c) | ((bit_A & bit_B));
    out_s_d = ((bit_A ^ bit_B) ^ in_c);
end
assign out_s = out_s_ff;
assign out_c = out_c_ff;
endmodule