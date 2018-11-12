
typedef enum bit [2:0] {WRITE = 'b001, READ = 'b010, IDLE = 'b011, RESET = 'b100} e_operation;

class Operation;
    rand e_operation op;
    rand [15:0] data, addr;

    static int nr_op = 0;

    function new();
      nr_op++;
    endfunction

    function f_display();
      $display("--------Transaction Packet---------\n");
      $display("@%gns transaction_number = %d :: operation = %b\n",$time, this.nr_op, this.op);
      $display("@%gns data = %b :: address = %b \n", $time, this.data, this.addr);
    endfunction
endclass //operation

/*
initial begin
  i_sif.xa_wr_S = ENABLE;
  op1 = new(WR_ADDR);
  normal_addr: assert (op1.randomise())
    else $error("Assertion normal_addr failed!");

  i_sif.xa_addr = x_addr.addr_to_send;
end
*/
