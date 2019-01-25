`ifndef MONITOR
`define MONITOR

import packet::*;
import lib::*;

/*de rezolvat: citirea read-ului care are o intarziere fata de driver-ul pt adresa
  check it taskuri virtuale
  codul de monitor ar fi bine sa fie in interfata*/


class Monitor;/*clasa de monitor trebuie sa fie comuna pentru ambele monitoare*/
    virtual sif_i mon_i;

	integer nr = 0;

    function new(virtual sif_i mon_i);
        this.mon_i = mon_i;
    endfunction

    task xa_run;
	$display("--%t [XA_MONITOR] Run Task--\n", $time);

	forever begin
		xa_mon_pak = new();

		@mon_i.xa_mon_cb;	

		if(mon_i.xa_mon_cb.xa_wr_s) begin
			xa_mon_pak.addr = mon_i.xa_mon_cb.xa_addr;
			xa_mon_pak.data = mon_i.xa_mon_cb.xa_data_wr;
			xa_mon_pak.op = WRITE;
	
			$display("--%t [XA_MONITOR] WR_Data|Addr|Strobe::%h|%h|%b--\n", $time, xa_mon_pak.data, xa_mon_pak.addr, mon_i.xa_mon_cb.xa_wr_s);
			
		end
		else if(mon_i.xa_mon_cb.xa_rd_s) begin
	
			xa_mon_pak.addr = mon_i.xa_mon_cb.xa_addr;
			xa_mon_pak.data = mon_i.xa_mon_cb.xa_data_rd;
			xa_mon_pak.op = READ;		
	
			$display("--%t [XA_MONITOR] RD_Data|Addr|Strobe::%h|%h|%b--\n", $time, xa_mon_pak.data, xa_mon_pak.addr, mon_i.xa_mon_cb.xa_rd_s);
		end	
		xa_mon_q.push_back(xa_mon_pak);
	end
		
	$display("--%t [XA_MONITOR] Run Task--\n", $time);
    endtask
endclass : Monitor
`endif
