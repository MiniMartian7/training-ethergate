interface tx_i (input logic clk);
    logic [7:0] data;
    logic soc, en, clav, tclk;

    clocking cb @(posedge clk);
        input data, soc, en;
        output clav;
    endclocking

    modport DUT(
        output data, soc, en, tclk,
        input clk, clav
    );

    modport TB(clocking cb);
    
endinterface //tx_i