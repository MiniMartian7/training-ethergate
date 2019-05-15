//  Interface: sif_i
//
interface sif_i;
    import sif_pkg::*;

    bit clk_i, nrst_i;

    bit [15:0] xa_addr_i, xa_data_wr_i, xa_data_rd_i;
    bit         xa_rd_s_i, xa_wr_s_i, wa_wr_s_i;
    bit [15:0] wa_addr_i, wa_data_wr_i;

    initial begin
        clk_i = 0;
        forever begin : clk_gen
            #10
            clk_i = ~clk_i;
        end : clk_gen
    end


    task reset();
        @(posedge clk_i);

        nrst_i = 0;

        repeat (2) @(posedge clk_i);

        nrst_i = 1;
    endtask : reset

    task send(input bit addr, input bit data, input sif_op oper);
        @(posedge clk_i);

        {nrst_i, xa_wr_s_i, xa_rd_s_i} <= oper;

        if(oper == rst_op) begin
            repeat (2) @(posedge clk_i);

            nrst_i = 1;
        end
        else if(oper == idle_op) begin
            xa_addr_i = 0;
        end
        else if(oper == wr_op) begin
            xa_data_wr_i = data;
            xa_addr_i = addr;
        end
        else if(oper == rd_op) begin
            xa_addr_i = addr;
        end
    endtask : reset
    
endinterface: sif_i
