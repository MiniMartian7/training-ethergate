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

	index = 0;//reset index for populating the ref mem with WR values from generator

	CHECK_4_STATE : assert(state == IDLE) begin
		foreach(op_q[i]) begin
			if(op_q[i].op == READ) begin
				xa_ref_val = new();

				xa_ref_val.addr = op_q[i].addr;
				xa_ref_val.data = {op_q[i].addr[15:9], op_q[i].addr[8]^op_q[i].addr[4], op_q[i].addr[7]^op_q[i].addr[5], op_q[i].addr[6:0]};//this overwrites the generated data for read op
				xa_ref_val.op = op_q[i].op;

				xa_ref_q.push_back(xa_ref_val);
			end

			else if(op_q[i].op == WRITE) begin
				wa_ref_val = new();

				wa_ref_val.addr = op_q[i].addr;
				wa_ref_val.data = op_q[i].data;
				wa_ref_val.op = op_q[i].op;

				wa_ref_q.push_back(wa_ref_val);

				ref_mem[index] = wa_ref_val.data;//create the ref mem with wa WRITE values
				index++;
			end
		end

		index++;
		
			/*reference display*/
		//foreach(xa_ref_q[i]) $display("--%t [REFERENCE] XA RD Ref Val | %h--\n", $time, xa_ref_q[i].data);

		//foreach(wa_ref_q[i]) $display("--%t [REFERENCE] WA WR Ref Val | %h--\n", $time, wa_ref_q[i].data);
	end
	else begin
		$display("--%t [REFERENCE] No IDLE state--\n", $time);
	end

	$display("--%t [REFERENCE] End Main--\n", $time);
    endfunction
endclass : Reference
`endif
