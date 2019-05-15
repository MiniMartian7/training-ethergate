//  Package: sif_pkg
//
package sif_pkg;
    //includes & imports

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "sif_sequence_item.svh"

    //  Group: Typedefs
    typedef enum_op[2:0] = {
        wr_op = `b110, 
        rd_op = `b101, 
        idle_op = `b100, 
        ilegal_op = `b111, 
        rst_op - `b000} sif_op; /*{rst_n, xa_wr_s, xa_rd_s}*/

    typedef uvm_sequencer #(sequence_item) sequencer;
    //  Group: Parameters
    

    
endpackage: sif_pkg
