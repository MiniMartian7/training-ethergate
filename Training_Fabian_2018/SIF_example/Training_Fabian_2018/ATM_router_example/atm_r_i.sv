interface rx_i (input logic clk);
    logic[7:0] data;
    logic soc, en, clav, rclk;
    
    clocking cb @(posedge clk)
        output data, soc, clav;
        input en;
    endclocking

    modport DUT(
        output en, rclk,
        input data, soc, clav
    );

    modport TB (clocking cb);
endinterface //rx_i