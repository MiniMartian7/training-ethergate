`include "sif_interface.sv"

module top(sif_i.DUT top_sif);
    logic bit clk_top;

    sif SIF_DUT(top_sif);
endmodule : top