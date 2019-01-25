module test_deb

{
	clk,
	reset,
	digit_en,
	digit_val,
	db_en;
	//add,
	//sustract
}


//inputs
input clk, reset, db_en; //add, substract;

output [3:0]digit_en;
//output [7:0] digit_val;

wire count_entry, count_delay;

////internal signals
reg[3:0] digit_en_d, digit_en_ff;
reg[31:0] db_cnt_d, db_cnt_ff;
ref[18:0]digit_en_cnt_d, digit_en_cnt_ff;
reg
reg[6:0] digit_val_d, digit_val_ff;

//clk and reset
always @(posedge clk or posedge reset)begin

	if(reset) begin
		digit_en_ff <= 'b0001;
		digit_val_ff <= 'b0000000;
		digit_en_cnt_ff <= 'h0;
	end
	else begin
		digit_en_cnt_ff <= digit_en_cnt_d;
		digit_val_ff <= digit_val_d;
	end
end

//digit activation
always @(*) begin

	digit_en_cnt_d = digit_en_cnt_ff + 1;
	digit_en_d = digit_en_ff;
	
	if(digit_en_cnt_ff >= 20'h3ffff) begin
		digit_en_cnt_d = 20'h0;
		
		if(digit_en_ff == 'b1000) begin
			digit_en_d = 'b0001;
		end
		else begin
			digit_en_d = digit_en_ff << 1;
		end
	end
end

//deboucing
always@(*) begin
	db_cnt_d = db_cnt_ff;
	digit_val_d = digit_val_ff;

	if((count_entry!=count_delay) && db_en == 1) begin
		if(db_cnt_ff >= 'd2500000)
	end
end

endmodule