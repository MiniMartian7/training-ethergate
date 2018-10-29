


task number_0;

    input [29:0] line;
    input [9:0] h_poz;
    output [2:0] red_out; 
    output [2:0] green_out;
    output [1:0] blue_out;

    begin
    if((line<<h_poz && (30'h10000000))>>29 == 1) begin
        red_out = 3'b111;
        green_out = 3'b111;
        blue_out = 2'b11;
    end
    else begin
        red_out = 3'b000;
        green_out = 3'b000;
        blue_out = 2'b00;
    end
    end
endtask