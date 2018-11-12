
class Generator;
    Operation op;
    int repeat_count = 'd10;
    event ended;

    Queue_line gen2driver;

    function new(Queue_line ev_gen2driver);
    this.gen2driver = ev_gen2driver;
    endfunction

    task main();
        repeat (repeat_count) begin
            op = new();
            assert (op.randomize()); 
            else   $fatal(0, "Packet::randomize failed");

            op.f_display();
            gen2driver.push_back(op);
        end
        -> ended;
    endtask
endclass //Generator