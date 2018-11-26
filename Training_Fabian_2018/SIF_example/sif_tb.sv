`include "sif_interface.sv"
`include "class_enviroment.sv"

module TB();
    logic clk_tb = 1'b0;

    initial begin
        clk_tb = 1'b0;
        forever being
            #10
            clk_tb = ~clk_tb;
        end
    end
endmodule : TB