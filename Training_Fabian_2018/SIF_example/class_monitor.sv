`ifndef MONITOR_X
`define MONITOR_X

`include "class_transaction.sv"

class Monitor;/*clasa de monitor trebuie sa fie comuna pentru ambele monitoare*/
    virtual sif_i mon_i;

    /*function new(virtual sif_i mon_i);
        this.mon_i = mon_i;
    end*/

    task run(bit [15:0] input_data, input_addr, ref Monitor ev_q_mon2scb[$]);
        forever begin
            Monitor_Operation q_mon2scb;
            q_mon2scb = new();

            @(posedge mon_i.clk) begin
                q_mon2scb.data = input_data;
                q_mon2scb.addr = input_addr;
                q_mon2scb.display();
                ev_q_mon2scb.push_back(q_mon2scb);
            end
        end
    endtask

endclass : Monitor_Operation
`endif