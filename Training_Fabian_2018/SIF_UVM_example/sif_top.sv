//  Module: sif_top
//
module sif_top #(
        <parameter_list>
    )(
        <port_list>
    );

    sif_i TOP_i;

    initial begin
        uvm_config_db#(virtual sif_i)::set(null, "*", "sif_i", TOP_i);
    end
endmodule: sif_top
