module MEM_WB_reg(
                  input             clk,
                  input             reset,
                  input [31:0]      data_mem_read_data,
                  input             MEM_regwrite,
                  input [4:0]       MEM_rd,
                  input [31:0]      MEM_pc,
                  input             MEM_unconditional_jmp,
                  input             MEM_memtoreg,
                  input [31:0]      MEM_ALU_result,
                  output reg [4:0]  MEM_WB_rd,
                  output reg        MEM_WB_regwrite,
                  output reg [31:0] MEM_WB_result
                  );
   always @ (posedge clk or posedge reset)
     if (reset)
       MEM_WB_rd <= 0;
     else
       MEM_WB_rd <= MEM_rd;


   always @ (posedge clk or posedge reset)
     if (reset)
       MEM_WB_regwrite <= 0;
     else
       MEM_WB_regwrite <= MEM_regwrite;

   always @ (posedge clk or posedge reset)
     if (reset)
       MEM_WB_result <= 0;
     else
       if (MEM_memtoreg)
         MEM_WB_result <= data_mem_read_data;
       else
         if (MEM_unconditional_jmp)
           MEM_WB_result <= MEM_pc;
         else
           MEM_WB_result <= MEM_ALU_result;
endmodule
