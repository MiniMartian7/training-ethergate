`include "sif_interface.sv"
`include "class_enviroment.sv"

module testbench(sif_i INTERFACE);
    program enviroment_test;
        initial begin
            Enviroment tb_ev;
            tb_ev = new(INTERFACE);
            tb_ev.run();
        end
    endprogram
endmodule : TB