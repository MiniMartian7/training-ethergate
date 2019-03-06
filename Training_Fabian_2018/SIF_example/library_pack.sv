package lib;
    typedef enum logic [2:0] {WRITE = 3'b110, READ = 3'b101, IDLE = 3'b100, ILLEGAL = 3'b111, RESET = 3'b000} E_Operation;/*{rst_n, xa_wr_s, xa_rd_s}*/

    E_Operation state; /*detects the status of the DUT controled by the driver*/

    integer check_sum = 0;

    integer index = 0; //index for memories

    bit[15:0] ref_mem[integer];
    bit[15:0] actual_mem[integer];
endpackage

package packet;
    `include "class_packet.sv"
    
    Packet op_pak;
    Packet op_q[$];

    Packet xa_mon_wr_pak, wa_mon_pak, xa_mon_rd_pak;
    Packet xa_mon_wr_q[$],xa_mon_rd_q[$], wa_mon_q[$];

    Packet xa_ref_val, wa_ref_val;
    Packet xa_ref_q[$], wa_ref_q[$];
endpackage

package generator;
    `include "class_generator.sv"

    Generator ev_gen;
endpackage

package driver;
    `include "class_driver.sv"

    Driver ev_driver;
endpackage

package monitor;
    `include "class_monitor.sv"

    XA_Monitor ev_xa_mon;
    WA_Monitor ev_wa_mon;
endpackage

package reference;
    `include "class_reference.sv"

    Reference ev_ref;
endpackage

package compare;
    `include "class_compare.sv"

    Compare ev_xa_comp, ev_wa_comp;
endpackage

package enviroment;
    `include "class_enviroment.sv"

    Enviroment ev_tb;
endpackage
