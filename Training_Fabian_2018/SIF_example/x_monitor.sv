module x_monitor(
    sif_i.X_MODPORT x_mon
);

/*
modport X_MONITOR(
        input clk, rst_n,
        input xa_addr, xa_data_wr, xa_data_rd,
        input xa_wr_s, xa_rd_s/*enables
    );
*/

reg[15:0] xa_addr_mon, xa_data_wr_mon, xa_data_rd_mon;
wire xa_wr_s_mon, xa_rd_s_mon;

parameter ENABLE = 1;

always @(x_mon.xa_addr) begin
    xa_addr_mon = x_mon.xa_addr;
    $display("@%gns -- input x_address :: %h\n", $time, x_mon.xa_addr); 
end

always @(x_mon.xa_data_wr) begin
    xa_data_wr_mon = x_mon.xa_data_wr_mon;
    if(x_mon.xa_wr_s == ENABLE) begin
        $display("@%gns -- input x_data :: %h\n", $time, x_mon.xa_data_wr); 
    end
    else begin
         $display("@%gns --- not enabled data_wr :: \n", $time, x_mon.xa_wr_s);
    end
end
always @(x_mon.xa_data_rd) begin
    xa_data_rd_mon = x_mon.xa_data_rd;
    if(x_mon.xa_rd_s == ENABLE) begin
        $display("@%gns -- output x_data :: %h\n", $time, x_mon.xa_data_rd);
    end
    else begin
        $$display("@%gns --- not enabled data_rd :: \n", $time, x_mon.xa_data_rd);
    end
    

endmodule