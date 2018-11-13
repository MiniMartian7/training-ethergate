
typedef enum bit [2:0] {WRITE = 'b101, READ = 'b110, IDLE = 'b100, ILLEGAL = 'b111, RESET = 'b000} e_operation;

class Operation;
    rand e_operation op;
    rand bit [15:0] wr_data, addr;

    static int nr_op = 0;

    function new();
      nr_op++;
    endfunction

    function display();

      $display("--------[OPERATION]Transaction Packet Number $d :: operation-----------\n", this.nr_op);
      $display("@%gns operation = %b\n",$time, this.op);
      $display("@%gns data = %b :: address = %b \n", $time, this.data, this.addr);
      $display("--------[OPERATION]Transaction Sent-----------\n");

    endfunction
endclass //operation
