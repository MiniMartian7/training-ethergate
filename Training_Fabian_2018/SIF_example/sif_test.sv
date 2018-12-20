`include "class_enviroment.sv"

module sif_test(sif_i TB_i);
	program automatic ev_test;
		initial begin
			Enviroment ev_tb;
			ev_tb = new(TB_i);
			ev_tb.build();
			ev_tb.init();
			ev_tb.run();
		end
	endprogram
endmodule : sif_test
