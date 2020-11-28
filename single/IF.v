module IF(
          input wire         clk,
          input wire         reset,
          input wire         Controller_branch,
          input wire         Controller_branch_kick_up,
          input wire         ALU_Zero,
          // input wire         ALU_Zero_kick_up,
          input wire [31:0]  imme,
          // input wire         imme_kick_up,
          input wire         WB_kick_up,
          output wire        IF_kick_up,
          output wire        inst_mem_read_enable,
          output wire [31:0] inst_mem_read_addr
          );
   reg                       ALU_Zero_ready;
   reg                       Controller_branch_ready;
   reg                       imme_ready;
   reg                       pc_ready;
   reg                       instruction_kick_up_internal;
   reg [31:0]                pc;
   always @ (posedge clk or negedge reset)
     if (! reset) ALU_Zero_ready <= 0;
     else
       if (pc_ready)  ALU_Zero_ready <= 0;
       else
         if (ALU_Zero_kick_up) ALU_Zero_ready <= 1;

   always @ (posedge clk or negedge reset)
     if (!reset) Controller_branch_ready <= 0;
     else
       if (pc_ready) Controller_branch_ready <= 0;
       else
         if (Controller_branch_kick_up) Controller_branch_ready <= 1;

   always @ (posedge clk or negedge reset)
     if (!reset) imme_ready <= 0;
     else
       if (pc_ready) imme_ready <= 0;
       else
         if (imme_kick_up) imme_ready <= 1;

   wire [31:0]               jmp_destination;
   assign jmp_destination = {imme[30:0], 1'b0} + pc;

   wire [31:0]               normal_destination;
   assign normal_destination = pc + 4;

   wire [31:0]               pc_next;
   assign pc_next = (Controller_branch && ALU_Zero)? jmp_destination: normal_destination;

   always @ (posedge clk or negedge reset)
     if (!reset) begin
        pc <= 0;
     end else begin
        if (ALU_Zero_ready && Controller_branch_ready && imme_ready) pc <= pc_next;
        else pc <= pc;
     end
   assign inst_mem_read_addr = pc;

   always @ (posedge clk or negedge reset)
     if (!reset) pc_ready <= 1;
     else
       if (ALU_Zero_ready && Controller_branch_ready && imme_ready) pc_ready <= 1;
       else
         if (instruction_kick_up_internal) pc_ready <= 0;
   assign inst_mem_read_enable = 1;

   always @ (posedge clk or negedge reset)
     if (!reset) instruction_kick_up_internal <= 0;
     else
       if (pc_ready) instruction_kick_up_internal <= 1;
       else instruction_kick_up_internal <= 0;
   assign instruction_kick_up = instruction_kick_up_internal;
endmodule
