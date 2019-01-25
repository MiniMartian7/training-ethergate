module arb_port (
output logic [1:0] grant,
input logic [1:0] request,
input rst,
input clk
);

always @(posedge clk or posedge rst) begin
  if(rst) begin
    grant <= 2'b00;
  end
  else begin
  end
end
endmodule