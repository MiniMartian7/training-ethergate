`include "sif_interface.sv"

module sif_top;
    bit clk_top;

    initial begin
        forever begin
            #5 clk_top = ~clk_top;
        end
    end

    sif_i INTERFACE (clk_top);
    sif DUT(INTERFACE);
    testbench TB(INTERFACE);
endmodule : top