module IF_ID_reg(input clk,
                 input reset,
                 input         IF_kick_up,
                 input [31:0]  inst_mem_read_data,
                 output [31:0] instruction,
                 output IF_ID_reg_kickup
                 );
   reg [31:0]                  instruction_internal;
   always @ (posedge clk or posedge reset)
     if (reset) instruction_internal <= 0;
     else if (IF_kick_up) instruction_internal <= inst_mem_read_data;
     else instruction_internal <= instruction_internal;
   assign instruction = instruction_internal;

   reg                         IF_ID_reg_kickup_internal;
   always @ (posedge clk or posedge reset)
     if (reset) IF_ID_reg_kickup_internal <= 0;
     else if (IF_kick_up) IF_ID_reg_kickup_internal <= 1;
     else IF_ID_reg_kickup_internal <= 0;
   assign IF_ID_reg_kickup = IF_ID_reg_kickup_internal;

endmodule // IF_ID_reg
