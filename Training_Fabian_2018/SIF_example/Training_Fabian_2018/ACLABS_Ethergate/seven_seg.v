//////////////////////////////////////////
//                                      //
// Numele modulului: 7 segmente         //
// Descriere       : afiseaza numarul   //
//                   "4321" pe display  //
//                   tip LED 7 segmente //
//                   din 4 digiti       //
// Functionalitate :                    //
//     - folosind tehnica multiplexarii //
//       in timp (TDM - Time Division   //
//       Multiplexing) se afiseaza      //
//       valori diferite pe afisaje ale //
//       caror pini pentru segmente     //
//       sunt legate impreuna           //
//     - afisajele sunt de tip anod     //
//       comun, dar iesirile FPGA-ului  //
//       de la acei pini sunt trecute   // 
//       prin inversoare, astfel un     //
//       afisaj este activ daca anodul  //
//       e controlat cu valoarea '0'    //
//     - segmentele active sunt cele    // 
//       comandate cu valoarea '0'      //
//                                      // 
//////////////////////////////////////////

module seven_seg
    (
        clk,
        reset,
        an,
        digit
    );

    input clk, reset;
    output [3:0] an;
    output [7:0] digit;
    
    reg [3:0] an_ff, an_d;
    reg [7:0] digit_ff, digit_d;
    // numarator care da durata de aprindere a unui afisaj
    reg [16:0] count_dig_ff, count_dig_d;
    
    always @(*) begin
        an_d = an_ff;
        digit_d = digit_ff;
        count_dig_d = count_dig_ff + 'h1;
        // daca numaratorul a ajuns la valoarea 50000 (1ms) se trece la digitul urmator
        if (count_dig_ff == 'd50000) begin
            count_dig_d = 'h0;
            // in functie de digitul curent activ se stabileste urmatorul digit activ si valoarea aceluia
            case (an_ff) 
                4'b1110 : begin
                        an_d = 4'b1101; // digit 1 activ
                        digit_d = 8'b10100100; // valoarea 2
                    end
                4'b1101 : begin
                        an_d = 4'b1011; // digit 2 activ 
                        digit_d = 8'b10110000; // valoarea 3
                    end
                4'b1011 : begin
                        an_d = 4'b0111; // digit 3 activ
                        digit_d = 8'b10011001; // valoarea 4
                    end
                4'b0111 : begin
                        an_d = 4'b1110; // digit 0 activ 
                        digit_d = 8'b11111001; // valoarea 1
                    end
                default : begin //4'b1111 case - cazul de la reset reset
                        an_d = 4'b1110;
                        digit_d = 8'b11111001;
                    end
            endcase
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            an_ff <= 4'b1111;
            digit_ff <= 8'b00000000;
            count_dig_ff <= 'h0;
        end
        else begin
            an_ff <= an_d;
            digit_ff <= digit_d;
            count_dig_ff <= count_dig_d;
        end
    end
    
    assign an = an_ff;
    assign digit = digit_ff;
    
endmodule
