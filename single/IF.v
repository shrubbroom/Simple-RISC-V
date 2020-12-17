module IF(
          input wire         clk,
          input wire         reset,
          input wire         ID_branch,
          input wire         EX_zero,
          input wire [31:0]  ID_imme,
          output wire        inst_mem_read_enable,
          output wire [31:0] inst_mem_read_addr
          );
   reg [31:0]                pc;
   always @ (posedge clk or posedge reset)
     if (reset)
       pc <= 0;
     else
       if (ID_branch && EX_zero)
         pc <= pc + ID_imme;
       else
         pc <= pc + 4;
   assign inst_mem_read_addr = pc;
   assign inst_mem_read_enable = 1;
endmodule
