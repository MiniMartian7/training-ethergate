`ifndef REFERENCE
`define REFERENCE

import packet::*;
import lib::*;

class Reference;
    virtual sif_i ref_i;

    function new(virtual sif_i ref_i);
        this.ref_i = ref_i;
    endfunction

    /*a posibility to take each obj in the queue is to check each time the size of the queue
    or maybe to do a initial go trough the queue, make the expected value and after that in case of size change, redo this
    
    or take the whole queue and generate another queue with the expected read and writes value
    */

    function void run();
	$display("--%t [REFERENCE] Main--\n", $time);
	
	CHECK_4_VAL : assert(xa_mon_q.size() && status == IDLE) begin
			foreach(xa_mon_q[i]) begin
				if(xa_mon_q[i].op == READ) begin
					xa_ref_val = {xa_mon_q[i].addr[15:9], xa_mon_q[i].addr[8]^xa_mon_q[i].addr[4], xa_mon_q[i].addr[7]^xa_mon_q[i].addr[5], xa_mon_q[i].addr[6:0]};
					xa_ref_q.push_back(xa_ref_val);
				end
				else if(xa_mon_q[i].op == WRITE) begin
					wa_ref_val = xa_mon_q[i].data;
					xa_ref_q.push_back(wa_ref_val);
				end
			end
		end
		else begin
			$display("--%t [REFERENCE] Queue is empty--\n", $time);
		end

		foreach(xa_ref_q[i]) begin
			$display("--%t [REFERNCE] XA RD Ref Val | %h--\n", $time, xa_ref_q[i]);
		end

		foreach(xa_ref_q[i]) begin
			$display("--%t [REFERNCE] WA RD Ref Val | %h--\n", $time, wa_ref_q[i]);
		end

	$display("--%t [REFERENCE] End Main--\n", $time);
    endfunction
endclass : Reference
`endif
