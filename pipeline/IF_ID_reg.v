module IF_ID_reg(
                 input             clk,
                 input             reset,
                 input [31:0]      inst_mem_read_data,
                 input [31:0]      inst_mem_read_addr,
                 // input             EX_flush,
                 input             EX_stall,
                 input             IF_take,
                 input             ID_branch,
                 input             EX_branch,
                 input             EX_zero,
                 // input             ID_EX_branch,
                 output reg [31:0] IF_ID_instruction,
                 output reg [31:0] IF_ID_pc
                 // output reg        IF_ID_take
                 );
   always @ (posedge clk or posedge reset)
     if (reset) IF_ID_instruction <= 0;
     else if(EX_branch && (EX_zero != IF_take))
       IF_ID_instruction <= 0;
     else
       if (EX_stall)
         IF_ID_instruction <= IF_ID_instruction;
       else
         if (ID_branch)
           IF_ID_instruction <= 0; // this is a nope for JMP instruction
         else
           IF_ID_instruction <= inst_mem_read_data;

   always @ (posedge clk or posedge reset)
     if (reset) IF_ID_pc <= 0;
   // else if(EX_branch && (EX_zero != IF_take))
   //   IF_ID_pc <= 0;
   // else
   //   if (EX_stall)
   //     IF_ID_pc <= IF_ID_pc;
   //   else
   //     if (ID_branch)
   //       IF_ID_pc <= 0; // this is a nope for JMP instruction
     else
       IF_ID_pc <= inst_mem_read_addr + 4;


   // always @ (posedge clk or posedge reset)
   //   if (reset) IF_ID_take <= 0;
   //   else IF_ID_take <= IF_take; // it is not important to flush or stall this signal

endmodule // IF_ID_reg
