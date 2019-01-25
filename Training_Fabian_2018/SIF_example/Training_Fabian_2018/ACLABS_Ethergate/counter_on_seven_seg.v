///////////////////////////////////////////////////////
//                                                   //
// Numele modulului: numarator pe 7 segmente         //
// Descriere       : afiseaza valoarea numaratorului //
//                   pe display LED 7 segmente de 4  //
//                   digitisi pe LED-uri individuale //
// Functionalitate :                                 //
//     - combinatie intre numarator si afisaj pe 7   //
//       segmente                                    //
//     - daca valoarea numaratorului e mai mare sau  //
//       egala cu 2^16 ('d65536, 'h10000), afisajul  //
//       va afisa mesajul "out!"                     //
//     - cei mai semnificativi 8 biti ai valorii     //
//       numaratorului vor fi afisati pe LED-urile   //
//       individuale                                 //
//     - numarul de biti ai numaratorului e          //
//       parametrizabil                              //
//     - butoanele de numarat in sus si in jos au    //
//       debouncer activabil de la un intrerupator   //
//     - numararea se face pe frontul crescator al   //
//       butonului                                   //
//                                                   // 
///////////////////////////////////////////////////////

module counter_on_seven_seg
    (
        clk,
        reset,
        cnt_up,
        cnt_down,
        debounce_en,
        count,
        an,
        digit
    );

    //parameter COUNT_WIDTH = 16;
    parameter COUNT_WIDTH = 17;
    
    input clk, reset, cnt_up, cnt_down, debounce_en;
    output [7:0] count;
    output [3:0] an;
    output [7:0] digit;
    
    wire cnt_up_deb, cnt_down_deb;
    
    reg [(COUNT_WIDTH-1):0] count_ff, count_d;
    reg cnt_up_delay, cnt_down_delay; 
    reg start_deb_up_ff, start_deb_up_d;
    reg start_deb_down_ff, start_deb_down_d;
    reg cnt_up_deb_ff, cnt_up_deb_d;
    reg cnt_down_deb_ff, cnt_down_deb_d;
    reg [31:0] deb_cnt_up_ff, deb_cnt_up_d;
    reg [31:0] deb_cnt_down_ff, deb_cnt_down_d;
    reg [3:0] an_ff, an_d;
    reg [7:0] digit_ff, digit_d;
    reg [16:0] count_dig_ff, count_dig_d;
    
    always @(*) begin
        cnt_up_deb_d = cnt_up_deb_ff;
        cnt_down_deb_d = cnt_down_deb_ff;
        count_d = count_ff;
        deb_cnt_up_d = deb_cnt_up_ff;
        deb_cnt_down_d = deb_cnt_down_ff;
        start_deb_up_d = start_deb_up_ff;
        start_deb_down_d = start_deb_down_ff;
        // debounce process
        //// detect a signal change and start counting
        //// after 0.05 seconds check if value actually changed
        //// do this for cnt up and cnt down
        if ((cnt_up_delay != cnt_up) && (cnt_up == 1'b1) && (start_deb_up_ff == 1'b0)) begin
            start_deb_up_d = 1'b1;
        end
        else if (start_deb_up_ff == 1'b1) begin
            if (deb_cnt_up_ff == 'd2500000) begin
                cnt_up_deb_d = cnt_up;
                deb_cnt_up_d = 'd0;
                start_deb_up_d = 1'b0;
            end
            else begin
                deb_cnt_up_d = deb_cnt_up_ff + 'd1;
            end
        end
        else begin
            cnt_up_deb_d = 1'b0;
        end
        if ((cnt_down_delay != cnt_down) && (cnt_down == 1'b1) && (start_deb_down_ff == 1'b0)) begin
            start_deb_down_d = 1'b1;
        end
        else if (start_deb_down_ff == 1'b1) begin
            if (deb_cnt_down_ff == 'd2500000) begin
                cnt_down_deb_d = cnt_down;
                deb_cnt_down_d = 'd0;
                start_deb_down_d = 1'b0;
            end
            else begin
                deb_cnt_down_d = deb_cnt_down_ff + 'd1;
            end
        end
        else begin
            cnt_down_deb_d = 1'b0;
        end
        // count process
        if (debounce_en) begin
            if (cnt_up_deb) begin
                count_d = count_ff + 'h1;
            end
            if (cnt_down_deb) begin
                count_d = count_ff - 'h1;
            end
        end
        else begin
            if ((cnt_up != cnt_up_delay) && (cnt_up == 1'b1)) begin
                count_d = count_ff + 'h1;
            end
            if ((cnt_down != cnt_down_delay) && (cnt_down == 1'b1)) begin
                count_d = count_ff - 'h1;
            end
        end
    end
    
    always @(*) begin
        an_d = an_ff;
        digit_d = digit_ff;
        count_dig_d = count_dig_ff + 'h1;
        if (count_dig_ff == 'd50000) begin
            count_dig_d = 'h0;
            case (an_ff) 
                4'b1110 : begin
                        an_d = 4'b1101;
                        if (count_ff > 'hffff) begin
                            digit_d = 8'b10000111; //t
                        end
                        else begin
                            digit_d = hex2digit(count_ff[7:4]);
                        end
                    end
                4'b1101 : begin
                        an_d = 4'b1011;
                        if (count_ff > 'hffff) begin
                            digit_d = 8'b11100011; //u
                        end
                        else begin
                            digit_d = hex2digit(count_ff[11:8]);
                        end
                    end
                4'b1011 : begin
                        an_d = 4'b0111;
                        if (count_ff > 'hffff) begin
                            digit_d = 8'b10100011; //o
                        end
                        else begin
                            digit_d = hex2digit(count_ff[15:12]);
                        end
                    end
                4'b0111 : begin
                        an_d = 4'b1110;
                        if (count_ff > 'hffff) begin
                            digit_d = 8'b01111001; //!
                        end
                        else begin
                            digit_d = hex2digit(count_ff[3:0]);
                        end
                    end
                default : begin //4'b1111 case - out of reset
                        an_d = 4'b1110;
                         if (count_ff > 'hffff) begin
                            digit_d = 8'b01111001; //!
                        end
                        else begin
                            digit_d = hex2digit(count_ff[3:0]);
                        end
                    end
            endcase
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt_up_deb_ff <= 1'b0;
            cnt_down_deb_ff <= 1'b0;
            count_ff <= 'h0;
            deb_cnt_up_ff <= 'h0;
            deb_cnt_down_ff <= 'h0;
            start_deb_up_ff <= 1'b0;
            start_deb_down_ff <= 1'b0;
            cnt_up_delay <= 1'b0;
            cnt_down_delay <= 1'b0;
            an_ff <= 4'b1111;
            digit_ff <= 8'b00000000;
            count_dig_ff <= 'h0;
        end
        else begin
            cnt_up_deb_ff <= cnt_up_deb_d;
            cnt_down_deb_ff <= cnt_down_deb_d;
            count_ff <= count_d;
            deb_cnt_up_ff <= deb_cnt_up_d;
            deb_cnt_down_ff <= deb_cnt_down_d;
            start_deb_up_ff <= start_deb_up_d;
            start_deb_down_ff <= start_deb_down_d;
            cnt_up_delay <= cnt_up;
            cnt_down_delay <= cnt_down;
            an_ff <= an_d;
            digit_ff <= digit_d;
            count_dig_ff <= count_dig_d;
        end
    end
    
    assign count = count_ff[(COUNT_WIDTH-1)-:8];
    assign cnt_up_deb = cnt_up_deb_ff;
    assign cnt_down_deb = cnt_down_deb_ff;
    assign an = an_ff;
    assign digit = digit_ff;
    
    // functie care transforma o valoare hexadecimala pe 4 biti intr-un digit
    function [7:0] hex2digit;
        input [3:0] hex;
        begin
            case (hex) 
                4'h0 : begin
                        hex2digit = 8'b11000000; 
                    end
                4'h1 : begin
                        hex2digit = 8'b11111001; 
                    end
                4'h2 : begin
                        hex2digit = 8'b10100100; 
                    end
                4'h3 : begin
                        hex2digit = 8'b10110000; 
                    end
                4'h4 : begin
                        hex2digit = 8'b10011001;
                    end
                4'h5 : begin
                        hex2digit = 8'b10010010;
                    end
                4'h6 : begin
                        hex2digit = 8'b10000010;
                    end
                4'h7 : begin
                        hex2digit = 8'b11111000;
                    end
                4'h8 : begin
                        hex2digit = 8'b10000000;
                    end
                4'h9 : begin
                        hex2digit = 8'b10010000;
                    end
                4'ha : begin
                        hex2digit = 8'b10001000;
                    end
                4'hb : begin
                        hex2digit = 8'b10000011;
                    end
                4'hc : begin
                        hex2digit = 8'b11000110;
                    end
                4'hd : begin
                        hex2digit = 8'b10100001;
                    end
                4'he : begin
                        hex2digit = 8'b10000110;
                    end
                4'hf : begin
                        hex2digit = 8'b10001110;
                    end
                default : begin // no need for this, all cases covered
                    end
            endcase
        end
    endfunction
    
endmodule
