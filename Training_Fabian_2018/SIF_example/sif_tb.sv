module generator(sif_i.SIF_DUT i_sif);

parameter WR_ADDR = 'b0001;
parameter WR_DATA = 'b0010;
parameter RD_DATA = 'b0011;

parameter WR_ADDR_2 = 'b0101;
parameter WR_DATA_2 = 'b0110;

parameter WR_ADDR_4 = 'b1101;
parameter WR_DATA_4 = 'b1110;

parameter WR_RD_DISABLE = 'b0000;

parameter ENABLE = 1;
parameter DISABLE = 0;

class Operation;
    logic [3:0] code;
    rand bit [15:0] addr_to_send, data_to send;
    bit wr_flag, rd_flag;

    constraint c_wr {i_sif.xa_wr_s = DISABLE;}
    constraint c_rd {i_sif.xa_rd_s = DISABLE;}
    
    function new(logic [3:0] toDo);
      code = toDo;
      if (code == WR_ADDR || code == WR_DATA || code == WR_ADDR_2 || 
      code == WR_DATA_2 || code == WR_ADDR_4 || code == WR_DATA_4) begin
        wr_flag = ENABLE;
      end
      else if (code == RD_DATA) begin
        rd_flag = ENABLE;
      end
      else if(code == WR_RD_DISABLE) begin
        wr_flag = DISABLE;
        rd_flag = DISABLE;
      end
    endfunction
/*
operation done through a 4 bit code:
Type of operation:
xx01 -> write_addr
xx10 -> write_data
xx11 -> read_data

Patern of transmission:
01xx -> normal clock
10xx -> wait 2 clock
11xx -> wait 4 clock
*/
endclass //operation

Operation x_addr;

initial begin
  x_addr = new(WR_ADDR);
  normal_addr: assert (x_addr.randomise())
    else $error("Assertion normal_addr failed!");

  i_sif.xa_wr_s = x_addr.wr_flag;
  i_sif.xa_rd_s = x_addr.rd_flag;

  i_sif.xa_addr = x_addr.addr_to_send;
end

endmodule