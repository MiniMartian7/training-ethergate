`ifndef COMPARE
`define COMPARE

import packet::*;
import lib::*;

class Compare;

virtual sif_i comp_i;

function new(virtual sif_i comp_i);
	this.comp_i = comp_i;
endfunction : new

function void run(ref Packet ref_q[$], mon_q[$]);//nu merge cu ref. sunt goale
	$display("--%t [COMPARE] Main--\n", $time);

	//foreach(ref_q[i]) $display("--%t [COMPARE] XA RD Ref Val | %h |%b--\n", $time, ref_q[i].data, ref_q[i].op);

	//foreach(mon_q[i]) $display("--%t [COMPARE] XA RD Queue Val | %h |%b--\n", $time, mon_q[i].data, mon_q[i].op);

	foreach(mon_q[i]) begin
		
		if(mon_q[i].op == RESET) begin
			//$display("--%t [COMPARE] XA RD Queue Addr | %h |%h--\n", $time, mon_q[i].addr, ref_q[i].addr);
			CHECK_4_RESET : assert(mon_q[i].addr == ref_q[i].addr) begin
				$display("-- %t[COMPARE] The read value for address |%h| was lost in a reset operation--\n", $time, ref_q[i].addr);
				check_sum++;
			end
		end
		else if(mon_q[i].op == READ) begin
			CHECK_4_READ : assert(mon_q[i].data == ref_q[i].data) check_sum++;
			else $error("--%t [COMPARE] RD inequality at address |%h|-- \n", $time, mon_q[i].addr);
		end
		else if(mon_q[i].op == WRITE) begin
			CHECK_4_WRITE : assert(mon_q[i].data == ref_q[i].data) check_sum++;
			else $error("--%t [COMPARE] WR inequality at address |%h|-- \n", $time, mon_q[i].addr);
		end
	end

	$display("--%t [COMPARE] End Main--\n", $time);
endfunction : run


endclass : Compare 

`endif
