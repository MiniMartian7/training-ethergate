`timescale 1ns/10ps
module rtl_adder_tb;
reg clk_tb, rst_tb;
reg bit_A_tb, bit_B_tb, in_c_tb;
wire out_c_tb, out_s_tb;

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
    bit_A_tb = 1'b1;
    bit_B_tb = 1'b0;
    in_c_tb = 1'b1;

    $display("@%gns rst = %b bitA = %b bitB = %b Cin = %b", $time, rst_tb, bit_A_tb, bit_B_tb, in_c_tb);

    #10

    rst_tb = 1'b0;
    $display("@%gns rst = %b bitA = %b bitB = %b Cin = %b S = %b Cout = %b", $time, rst_tb, bit_A_tb, bit_B_tb, in_c_tb, out_s_tb, out_c_tb);

    #10
    bit_A_tb = 1'b1;
    bit_B_tb = 1'b1;
    in_c_tb = 1'b1;
    $display("@%gns rst = %b bitA = %b bitB = %b Cin = %b S = %b Cout = %b", $time, rst_tb, bit_A_tb, bit_B_tb, in_c_tb, out_s_tb, out_c_tb);

    #10
    bit_A_tb = 1'b0;
    bit_B_tb = 1'b1;
    in_c_tb = 1'b0;
    $display("@%gns rst = %b bitA = %b bitB = %b Cin = %b S = %b Cout = %b", $time, rst_tb, bit_A_tb, bit_B_tb, in_c_tb, out_s_tb, out_c_tb);

    #10
    bit_A_tb = 1'b0;
    bit_B_tb = 1'b0;
    in_c_tb = 1'b1;
    $display("@%gns rst = %b bitA = %b bitB = %b Cin = %b S = %b Cout = %b", $time, rst_tb, bit_A_tb, bit_B_tb, in_c_tb, out_s_tb, out_c_tb);
    
end

adder DUT(.bit_A(bit_A_tb),.bit_B(bit_B_tb),.in_c(in_c_tb),.out_c(out_c_tb),.out_s(out_s_tb),.clk(clk_tb),.rst(rst_tb));

endmodule