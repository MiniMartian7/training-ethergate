
class Generator;
    Operation op, gen2driver[$];
    int repeat_count = 'd10;
    //event generation_ended;

    function new(Operation ev_gen2driver[$]);
        gen2driver = ev_gen2driver;
    endfunction

    task main();
        repeat (repeat_count) begin
            op = new();
            assert (op.randomize()); 
            else   $fatal(0, "[GENERATOR]Packet::randomize failed");

            op.display();
            gen2driver.push_back(op);
        end
        //-> generation_ended;
    endtask
endclass //Generator