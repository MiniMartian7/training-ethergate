package lib;
    typedef enum logic [2:0] {WRITE = 3'b110, READ = 3'b101, IDLE = 3'b100, ILLEGAL = 3'b111, RESET = 3'b000} E_Operation;/*{rst_n, xa_wr_s, xa_rd_s}*/
endpackage

package packet;
    `include "class_packet.sv"
    
    Packet op_pak;
    Packet op_q[$];

    Packet xa_mon_pak, wa_mon_pak;
    Packet xa_mon_q[$], wa_mon_q[$];

    integer q_size;
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

package enviroment;
    `include "class_enviroment.sv"

    Enviroment ev_tb;
endpackage
