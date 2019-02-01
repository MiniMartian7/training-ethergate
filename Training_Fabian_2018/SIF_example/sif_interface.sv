import packet::*;
import lib::*;

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

    clocking driver_cb @(posedge clk);
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
/*--------------------------------------------------------------------------------*/
    task reset();

	$display("--%t [INTERFACE] Reset Task--\n", $time);

	DUT.rst_n <= 0;
	DUT.xa_wr_s <= 0;
	DUT.xa_rd_s <= 0;
	DUT.xa_data_wr <= 0;
	DUT.xa_addr <= 0;
	
        repeat (5) @(posedge clk);

        DUT.rst_n <= 1;

	$display("--%t [INTERFACE] End Reset Task--\n", $time);

    endtask
/*----------------------------------------------the send function is called from driver*/
    task send(input logic [15:0] sent_data, sent_addr, input logic [2:0] flags);	
	@driver_cb;
	
        DUT.xa_addr <= sent_addr;
        DUT.xa_data_wr <= sent_data;
        {DUT.rst_n, DUT.xa_wr_s, DUT.xa_rd_s} <= flags;
    endtask
/*------------------------------------------------------------------------------------------------------*/
    
    task write(Packet mon_pak, mon_q[$], string mon);
	@(posedge clk);

	if(mon == "xa") begin
		if(xa_mon_cb.xa_wr_s) begin
			mon_pak.addr = xa_mon_cb.xa_addr;
			mon_pak.data = xa_mon_cb.xa_data_wr;
			mon_pak.op = WRITE;

			mon_q.push_back(mon_pak);
		
			$display("--%t [XA_MONITOR] WR_Data|Addr|Strobe::%h|%h--\n", $time, mon_pak.data, mon_pak.addr);	
		end
	end
	else if(mon == "wa") begin
		if(wa_mon_cb.wa_wr_s) begin
			mon_pak.addr = wa_mon_cb.wa_addr;
			mon_pak.data = wa_mon_cb.wa_data_wr;
			mon_pak.op = WRITE;

			mon_q.push_back(mon_pak);
		
			$display("--%t [WA_MONITOR] WR_Data|Addr::%h|%h--\n", $time, mon_pak.data, mon_pak.addr);	
		end
	end
    endtask

/*-------------------------------------------------------------------------------------------------------------*/

    task read(Packet mon_pak,  mon_q[$], string mon);

	if(mon == "xa") begin
		if(xa_mon_cb.xa_rd_s) begin
			mon_pak.addr = xa_mon_cb.xa_addr;
			mon_pak.op = READ;
			
			mon_q.push_back(mon_pak);
		end
		
		if(xa_mon_q[xa_mon_q.size() - 1].op == READ) begin
			xa_mon_q[xa_mon_q.size() - 1].data = xa_mon_cb.xa_data_rd;
		
			$display("--%t [XA_MONITOR] RD_Data|Addr::%h|%h--\n", $time, mon_pak.data, mon_pak.addr);	
		end
	end


    endtask


endinterface : sif_i


/*Modports are only used in interface port and virtual interface declarations. They are not used to reference individual interface items.*/

/*modports are necessary when you want to control other signal from a DUT that are not included in the same clocking bloc|
but also some simulators can not compile without the existance of the modports*/
