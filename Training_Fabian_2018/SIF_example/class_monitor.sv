`ifndef MONITOR
`define MONITOR

import packet::*;
import lib::*;

class Monitor;/*clasa de monitor trebuie sa fie comuna pentru ambele monitoare*/
    virtual sif_i mon_i;
	
    integer nr = 0;


    function new(virtual sif_i mon_i);
        this.mon_i = mon_i;
    endfunction

    task xa_run;
	$display("--@%gns [XA_MONITOR] Run Task--\n", $time);

		forever begin
			xa_mon_pak = new();
			
			@(mon_i.xa_mon_cb);
				if(mon_i.xa_mon_cb.xa_wr_s) begin
					xa_mon_pak.op = WRITE;
					xa_mon_pak.addr = mon_i.xa_addr;
					xa_mon_pak.data = mon_i.xa_data_wr;
				end
				else if(mon_i.xa_mon_cb.xa_rd_s) begin
					xa_mon_pak.op = READ;
					xa_mon_pak.addr = mon_i.xa_addr;
					xa_mon_pak.data = mon_i.xa_data_rd;
				end
				
				if(nr == 10) begin
					$finish;
				end
				else begin
					nr++;
					$display("--@%gns [XA_MONITOR] %h|%h|%h--\n", $time, mon_i.xa_addr, mon_i.xa_data_wr, mon_i.xa_data_rd);
				end

				xa_mon_q.push_back(xa_mon_pak);
		end
		
	$display("--@%gns [XA_MONITOR] Run Task--\n", $time);
    endtask
/*
    task run_wa_mon;
	$display("--@%gns [WA_MONITOR] Run Task--\n", $time);
		
		forever begin
			Packet wa_mon_pak;
			wa_mon_pak = new();

			@(posedge mon_i.wa_mon_cb) begin
				if(mon_i.wa_mon_cb.wa_wr_s) begin
					wa_mon_pak.data <= mon_i.wa_mon_cb.wa_data_wr;
					wa_mon_pak.addr <= mon_i.wa_mon_cb.wa_addr;
				end
				else begin
					//wa_mon_pak.data <= mon_i.wa_mon_cb.wa_data_wr;
					wa_mon_pak.addr <= mon_i.wa_mon_cb.wa_addr;
				end
				wa_mon_pak.display();
				ev_wa_mon_q.push_back(wa_mon_pak);
			end			
		end

	$display("--@%gns [WA_MONITOR] Run Task--\n", $time);
    endtask*/
endclass : Monitor
`endif
