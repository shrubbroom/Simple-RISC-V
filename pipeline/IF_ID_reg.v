module IF_ID_reg(
                 input             clk,
                 input             reset,
                 input [31:0]      inst_mem_read_data,
                 input             EX_flush,
                 input             EX_MEM_stall,
                 input             IF_take,
                 // input             ID_EX_branch,
                 output reg [31:0] IF_ID_instruction,
                 output reg        IF_ID_take
                 );
   always @ (posedge clk or posedge reset)
     if (reset) IF_ID_instruction <= 0;
     else if(EX_flush)
       IF_ID_instruction <= 0;
     else
       if (EX_MEM_stall)
         IF_ID_instruction <= IF_ID_instruction;
       else
         // if (ID_EX_branch)
         //   IF_ID_instruction <= 0; // this is a nope for JMP instruction
         // else
         IF_ID_instruction <= inst_mem_read_data;

   always @ (posedge clk or negedge reset)
     if (reset) IF_ID_take <= 0;
     else IF_ID_take <= IF_take; // it is not important to flush or stall this signal

endmodule // IF_ID_reg
