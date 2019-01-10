package lib_operation_type;
    typedef enum logic [2:0] {WRITE = 3'b110, READ = 3'b101, IDLE = 3'b100, ILLEGAL = 3'b111, RESET = 3'b000} E_Operation;/*{rst_n, xa_wr_st, xa_rd_st}*/
endpackage

