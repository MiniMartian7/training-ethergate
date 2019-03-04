`ifndef PACKET
`define PACKET

import lib::*;

class Packet;
    rand E_Operation op;
    rand bit [15:0] data, addr;

    constraint c_op {op dist {WRITE :=35, READ := 35, IDLE := 10, RESET := 10, ILLEGAL := 10};}/*WRITE and READ have a probability of 25% and the rest 10%*/

    static integer nr_pak = 0;

    function new();
      /*srandom($urandom());generate seed*/
      nr_pak++;
    endfunction : new

    function void compare(bit [15:0] data_ref);//comparation is done by comparing each READ and WRITE values with the reference
	CHECK_WITH_REF : assert(this.data == data_ref) 
		check_sum++; 
	else $error("--%t [PACKET] Reference inequality--\n", $time);
    endfunction : compare

    function void display();
      $display("--%t [PACKET] Number|Operation|Data|Address :: %d|%b|%h|%h--\n", $time, nr_pak, op, data, addr);
    endfunction : display

	/*ar trebui sa existe o metoda de compare care sa fie folosita mai departe in la comparari*/
endclass : Packet
`endif
