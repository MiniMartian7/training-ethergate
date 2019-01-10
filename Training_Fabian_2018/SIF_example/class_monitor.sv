`ifndef MONITOR
`define MONITOR

import lib_operation_type::*;

`include "class_packet.sv"

class Monitor;/*clasa de monitor trebuie sa fie comuna pentru ambele monitoare*/
    virtual sif_i mon_i;
    Packet ev_xa_mon_q[$], ev_wa_mon_q[$];


    function new(virtual sif_i mon_i, ref Packet ev_xa_mon_q[$], ev_wa_mon_q[$]);
        this.mon_i = mon_i;
	this.ev_xa_mon_q = ev_xa_mon_q;
	this.ev_wa_mon_q = ev_wa_mon_q;
    endfunction

    task run_xa_mon;
	$display("--@%gns [XA_MONITOR] Run Task--\n", $time);
		
		forever begin
			Packet xa_mon_pak;
			xa_mon_pak = new();

			@(posedge mon_i.xa_mon_cb) begin
				if(mon_i.xa_mon_cb.xa_wr_s) begin
					xa_mon_pak.data <= mon_i.XA_MONITOR.xa_mon_cb.xa_data_wr;
					xa_mon_pak.addr <= mon_i.xa_mon_cb.xa_addr;
				end
				else if(mon_i.xa_mon_cb.xa_rd_s) begin
					xa_mon_pak.data <= mon_i.xa_mon_cb.xa_data_rd;
					xa_mon_pak.addr <= mon_i.xa_mon_cb.xa_addr;
				end
				xa_mon_pak.display();
				ev_xa_mon_q.push_back(xa_mon_pak);
			end
		end
		
	$display("--@%gns [XA_MONITOR] Run Task--\n", $time);
    endtask

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
    endtask
endclass : Monitor
`endif
