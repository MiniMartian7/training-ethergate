`ifndef PACKET
`define PACKET

import lib::*;

class Packet;
    rand E_Operation op;
    rand bit [15:0] data, addr;

    constraint c_op {op dist {WRITE :=35, READ := 35, IDLE := 10, RESET := 10, ILLEGAL := 10};}/*WRITE and READ have a probability of 25% and the rest 10%*/

    static integer nr_pak = 0;

    function new();
      nr_pak ++;
    endfunction

    function void display();
      $display("--%t [Packet] Number|Operation|Data|Address :: %d|%b|%h|%h--\n", $time, nr_pak, op, data, addr);
    endfunction

	/*ar trebui sa existe o metoda de compare care sa fie folosita mai departe in la comparari*/
endclass : Packet
`endif
