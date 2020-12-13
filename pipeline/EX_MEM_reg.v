module EX_MEM_reg(
                  input             clk,
                  input             reset,
                  input [31:0]      EX_ALU_result,
                  // input             EX_branch,
                  // input             EX_zero,
                  // input             EX_take,
                  input             EX_memtoreg,
                  input [4:0]       EX_rd,
                  input             EX_regwrite,
                  input             EX_stall,
                  input             EX_memread,
                  input             EX_memwrite,
                  input [31:0]      EX_rs2_data,
                  output reg [31:0] EX_MEM_ALU_result,
                  // output reg        EX_MEM_branch,
                  // output reg        EX_MEM_flush,
                  output reg        EX_MEM_memtoreg,
                  output reg [4:0]  EX_MEM_rd,
                  output reg        EX_MEM_regwrite,
                  // output reg        EX_stall,
                  // output reg        EX_MEM_zero,
                  output reg        EX_MEM_memread,
                  output reg        EX_MEM_memwrite,
                  // output reg [31:0] EX_MEM_rs1_data,
                  output reg [31:0] EX_MEM_rs2_data
                  );
   always @ (posedge clk or negedge reset)
     if (reset)
       EX_MEM_ALU_result <= 0;
     else
       if (EX_stall)
         EX_MEM_ALU_result <= 0; // insert a NOPE
       else
         EX_MEM_ALU_result <= EX_ALU_result;

   // always @ (posedge clk or negedge reset)
   //   if (reset)
   //     EX_MEM_branch <= 0;
   //   else
   //     if (EX_stall)
   //       EX_MEM_branch <= 0; // insert a NOPE
   //     else
   //       EX_MEM_branch <= EX_branch;

   // always @ (posedge clk or negedge reset)
   //   if (reset)
   //     EX_MEM_flush <= 0;
   //   else
   //     if (EX_stall)
   //       EX_MEM_flush <= 0; // insert a NOPE
   //     else
   //       if (EX_branch && EX_take != EX_zero) EX_MEM_flush <= 1;
   //       else EX_MEM_flush <= 0;

   always @ (posedge clk or negedge reset)
     if (reset)
       EX_MEM_memtoreg <= 0;
     else
       if (EX_stall)
         EX_MEM_memtoreg <= 0; // insert a NOPE
       else
         EX_MEM_memtoreg <= EX_memtoreg;

   always @ (posedge clk or negedge reset)
     if (reset)
       EX_MEM_rd <= 0;
     else
       if (EX_stall)
         EX_MEM_rd <= 0; // insert a NOPE
       else
         EX_MEM_rd <= EX_rd;

   always @ (posedge clk or negedge reset)
     if (reset)
       EX_MEM_regwrite <= 0;
     else
       if (EX_stall)
         EX_MEM_regwrite <= 0; // insert a NOPE
       else
         EX_MEM_regwrite <= EX_regwrite;

   // always @ (posedge clk or negedge reset)
   //   if (reset)
   //     EX_MEM_zero <= 0;
   //   else
   //     if (EX_stall)
   //       EX_MEM_zero <= 0; // insert a NOPE
   //     else
   //       EX_MEM_zero <= EX_zero;

   always @ (posedge clk or negedge reset)
     if (reset)
       EX_MEM_memwrite <= 0;
     else
       if (EX_stall)
         EX_MEM_memwrite <= 0; // insert a NOPE
       else
         EX_MEM_memwrite <= EX_memwrite;


   always @ (posedge clk or negedge reset)
     if (reset)
       EX_MEM_memread <= 0;
     else
       if (EX_stall)
         EX_MEM_memread <= 0; // insert a NOPE
       else
         EX_MEM_memread <= EX_memread;

   // always @ (posedge clk or negedge reset)
   //   if (reset)
   //     EX_MEM_rs1_data <= 0;
   //   else
   //     if (EX_stall)
   //       EX_MEM_rs1_data <= 0; // insert a NOPE
   //     else
   //       EX_MEM_rs1_data <= EX_rs1_data;

   always @ (posedge clk or negedge reset)
     if (reset)
       EX_MEM_rs2_data <= 0;
     else
       if (EX_stall)
         EX_MEM_rs2_data <= 0; // insert a NOPE
       else
         EX_MEM_rs2_data <= EX_rs2_data;

endmodule // EX_MEM_reg
