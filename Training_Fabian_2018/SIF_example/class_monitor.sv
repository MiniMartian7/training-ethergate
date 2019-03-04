`ifndef MONITOR
`define MONITOR

import packet::*;
import lib::*;

/*de rezolvat: citirea read-ului care are o intarziere fata de driver-ul pt adresa
  check it taskuri virtuale
  codul de monitor ar fi bine sa fie in interfata*/
/*
	tascurile pentru monitor pot fi puse in interfata de maniera, unu pt citirea de adresa si date scrise si unu pentru datele rezultate

	pentru combaterea delay-ului pe pinul de date rezultante, se poate folosii metoda lui jivet, 
	controlarea citirii prin manipularea semnalului de strobe ca a unui clock de citire
*/

virtual class Monitor;/*clasa de monitor trebuie sa fie comuna pentru ambele monitoare*/
    virtual sif_i mon_i;

    virtual task run(); endtask
endclass : Monitor

class XA_Monitor extends Monitor;
    function new(virtual sif_i mon_i);
        this.mon_i = mon_i;
    endfunction

    task run();
	$display("--%t [XA_MONITOR] Run Task--\n", $time);
		fork
			forever begin
				mon_i.write("xa");
			end
			forever begin
				mon_i.read();
			end
		join_none
	$display("--%t [XA_MONITOR] Run Task--\n", $time);
    endtask
endclass : XA_Monitor
/*--------------------------------------------------------------------------------*/
class WA_Monitor extends Monitor;
    function new(virtual sif_i mon_i);
        this.mon_i = mon_i;
    endfunction
	
    task run();
	$display("--%t [WA_MONITOR] Run Task--\n", $time);
		forever begin
			mon_i.write("wa");
		end
	$display("--%t [WA_MONITOR] Run Task--\n", $time);
    endtask
endclass : WA_Monitor
`endif
