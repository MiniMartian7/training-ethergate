//////////////////////////////////////////
//                                      //
// Numele modulului: counter            //
// Descriere       : numarator binar de //
//                   dimensiune fixa    //
//                   parametrizabila    //
// Functionalitate :                    //
//     - numarat crescator la apasarea  //
//       butonului "cnt_up"             //
//     - numarat descrescator la        //
//       apasare butonului "cnt_down"   //
//     - numararea se face pe frontul   //
//       crescator al semnalelor        //
//     - activarea debouncingului cu    //
//       ajutorul unui intrerupator     //
//     - afisarea valorii numaratorului //
//       pe LED-uri                     //
//                                      // 
//////////////////////////////////////////

module counter
    (
        clk,
        reset,
        cnt_up,
        cnt_down,
        debounce_en,
        count
    );

    // parametrul care defineste dimensiunea in biti a numaratorului
    parameter COUNT_WIDTH = 8;
    
    input clk, reset, cnt_up, cnt_down, debounce_en;
    output [(COUNT_WIDTH-1):0] count; // iesirea pe LED-uri de lungimea parametrului
    
    // semnalele de la butoane dupa debouncer
    wire cnt_up_deb, cnt_down_deb;
    
    // semnalele sincrone si combinationale ale semnalului de iesire
    reg [(COUNT_WIDTH-1):0] count_ff, count_d;
    // semnelele de la butoanele "cnt_up", respectiv "cnt_down" intarziate cu un tact
    // folosite la detectia de front
    reg cnt_up_delay, cnt_down_delay; 
    // flaguri pentru inceperea debouncingului
    reg start_deb_up_ff, start_deb_up_d;
    reg start_deb_down_ff, start_deb_down_d;
    // sincrone si combinationale ale semnalelor de numarare dupa debouncer
    reg cnt_up_deb_ff, cnt_up_deb_d;
    reg cnt_down_deb_ff, cnt_down_deb_d;
    // numaratoarele folosite pentru debouncing
    reg [31:0] deb_cnt_up_ff, deb_cnt_up_d;
    reg [31:0] deb_cnt_down_ff, deb_cnt_down_d;
    
    // procesul combinational
    always @(*) begin
        cnt_up_deb_d = cnt_up_deb_ff;
        cnt_down_deb_d = cnt_down_deb_ff;
        count_d = count_ff;
        deb_cnt_up_d = deb_cnt_up_ff;
        deb_cnt_down_d = deb_cnt_down_ff;
        start_deb_up_d = start_deb_up_ff;
        start_deb_down_d = start_deb_down_ff;
        // procesul de debounce
        //// detecteaza frontul crescator (primele 2 conditii) si daca nu e in derulare un proces de debouncing
        //// dupa 5 sutimi de secunda (valoarea numaratorului indica 2.5 milioane de tacte de 50 MHz - perioada de 20ns) 
        ////     se verifica daca valoare de la buton a ramas pe 1 sau frontul a fost doar un glitch
        //// procesul se intampla si pentru "cnt_up" si pentru "cnt_down"
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
        // procesul de numarare
        //// cu debouncer
        if (debounce_en) begin
            if (cnt_up_deb) begin
                count_d = count_ff + 'h1;
            end
            if (cnt_down_deb) begin
                count_d = count_ff - 'h1;
            end
        end
        //// fara debouncer
        else begin
            if ((cnt_up != cnt_up_delay) && (cnt_up == 1'b1)) begin
                count_d = count_ff + 'h1;
            end
            if ((cnt_down != cnt_down_delay) && (cnt_down == 1'b1)) begin
                count_d = count_ff - 'h1;
            end
        end
    end
    
    // procesul sincron de tact
    always @(posedge clk or posedge reset) begin
        // asignare valori de reset
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
        end
        // asignare valori flip-flop din semnalele combinationale
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
        end
    end
    
    // asignari continue (iesiri + semnale intermediare necesare)
    assign count = count_ff;
    assign cnt_up_deb = cnt_up_deb_ff;
    assign cnt_down_deb = cnt_down_deb_ff;
    
endmodule
