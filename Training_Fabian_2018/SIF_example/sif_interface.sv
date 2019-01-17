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

    clocking tb_cb @(posedge clk);
        output xa_addr, xa_data_wr;
        output xa_wr_s, xa_rd_s;
    endclocking

    modport DUT(
        input rst_n,

        input xa_addr, xa_data_wr,
        input xa_wr_s, xa_rd_s,

        output xa_data_rd,
        output wa_addr, wa_data_wr, wa_wr_s
    );

    modport TB(
        clocking tb_cb
    );

    task reset();
	$display("--@%gns [INTERFACE] Reset Task--\n", $time);

	rst_n <= 0;

        repeat (2) @(clk);

        rst_n <= 1;

	$display("--@%gns [INTERFACE] End Reset Task--\n", $time);
    endtask
/*----------------------------------------------the send function is called from driver*/
    task send(input logic [15:0] sent_addr, sent_data, input logic [2:0] flags);
	$display("--@%gns [INTERFACE] Send Task--\n", $time);

        @(posedge clk);
        DUT.xa_addr <= sent_addr;
        DUT.xa_data_wr <= sent_data;
        {DUT.rst_n, DUT.xa_wr_s, DUT.xa_rd_s} <= flags;
	
        repeat(2) begin
		$display("--@%gns DELAY--\n", $time);
		@(posedge clk);
	end/*give a delay for the observation region*/

       $display("--@%gns [INTERFACE] End Send Task--\n", $time);
    endtask

endinterface : sif_i


/*Modports are only used in interface port and virtual interface declarations. They are not used to reference individual interface items.*/

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
        clocking tb_cb
    );

    /*clocking driver_cb @(posedge clk);
        output xa_addr, xa_data_wr;
        output xa_wr_s, xa_rd_s;
        output rst_n;
    endclocking */
