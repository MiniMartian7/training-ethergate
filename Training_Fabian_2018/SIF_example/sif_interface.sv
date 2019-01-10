interface sif_i(input bit clk);
    logic rst_n;
    logic xa_wr_s, xa_rd_s, wa_wr_s;
    logic [15:0] xa_addr, wa_addr, xa_data_rd, xa_data_wr, wa_data_wr;

    clocking xa_mon_cb @(posedge clk);
        input xa_addr, xa_data_wr;
        input xa_data_rd;
	input xa_wr_s, xa_rd_s;
    endclocking

    clocking wa_mon_cb @(posedge clk);
        input wa_addr, wa_data_wr;
        input wa_wr_s;
    endclocking

    clocking dut_cb @(posedge clk);
        input clk, rst_n;

        input xa_addr, xa_data_wr;
        input xa_wr_s, xa_rd_s;

        output xa_data_rd;
        output wa_addr, wa_data_wr, wa_wr_s;
    endclocking

    clocking tb_cb @(posedge clk);
        output xa_addr, xa_data_wr;
        output xa_wr_s, xa_rd_s;
    endclocking

	modport XA_MONITOR(
	clocking xa_mon_cb;
);

    task reset();
	    rst_n <= 0;

        repeat (2) @(clk);

        rst_n <= 1;
    endtask
/*----------------------------------------------the send function is called from driver*/
    task send(input logic [15:0] sent_addr, sent_data, input logic [2:0] flags);
        @(posedge clk) begin
            xa_addr <= sent_addr;
            xa_data_wr <= sent_data;
            {rst_n, xa_wr_s, xa_rd_s} <= flags;
	     
            @(posedge clk);/*give a delay for the observation region*/
        end
    endtask
endinterface : sif_i




/*modports are necessary when you want to control other signal from a DUT that are not included in the same clocking bloc|
but also some simulators can not compile without the existance of the modports
    modport X_MONITOR(
        clocking xmon_cb
    );

    modport W_MONITOR(
        clocking wmon_cb
    );

    modport DRIVER(
        clocking driver_cb
    );

    modport DUT(
        clocking dut_cb
    );

    modport TB(
        clocking tb_cb;
    );*/

    /*clocking driver_cb @(posedge clk);
        output xa_addr, xa_data_wr;
        output xa_wr_s, xa_rd_s;
        output rst_n;
    endclocking */
