`ifndef GENERATOR
`define GENERATOR

`include "class_transaction.sv"

class Generator;
    Operation trans, gen2driver[$];
    int repeat_count = 'd10;/*number of times to generate a new transaction/operation*/

    /*event generation_ended;*/

    function new(Operation ev_q[$]);
        gen2driver = ev_q;
    endfunction

    task generation();
        $display("--@%gns [GENERATOR] Main Task--\n", $time);

        repeat (repeat_count) begin
            trans = new();

            assert (trans.randomize()) else   $fatal(0, "--@%gns [GENERATOR] Transaction Packet :: randomize failed--\n", $time);

            trans.display();
            gen2driver.push_back(trans);
        end

        $display("--@%gns [GENERATOR] End Main Task--\n", $time);
        /*-> generation_ended;*/
    endtask
endclass /*Generator*/

`endif
