module w_monitor(
    sif_i.W_MODPORT w_mon
);

/*
 modport W_MONITOR(
        input clk, rst_n;
        input wa_addr, wa_data_wr;
        input wa_wr_s/*enables
    );*/

reg[15:0] wa_addr_mon, wa_data_wr_mon;
wire wa_wr_s_mon;

parameter ENABLE = 1;

always @(w_mon.wa_addr) begin
    wa_addr_mon = w_mon.wa_addr;n
    $display("@%gns --- passed address :: \n", $time, w_mon.wa_addr);
end

always @(w_mon.wa_data_wr) begin
    wa_data_wr_mon = w_mon.wa_data_wr;
    if(w_mon.wa_wr_s == ENABLE) begin
        $display("@%gns --- passed data :: \n", $time, w_mon.wa_data_wr);
    end
    else begin
        wa_wr_s_mon = w_mon.wa_wr_s
        $display("@%gns --- not enabled data_wr :: \n", $time, w_mon.wa_wr_s);
    end
end
endmodule