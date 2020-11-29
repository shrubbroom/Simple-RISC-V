module IF(
          input wire         clk,
          input wire         reset,
          input wire         Controller_branch,
          input wire         ALU_zero,
          // input wire         ALU_Zero_kick_up,
          input wire [31:0]  imme,
          // input wire         imme_kick_up,
          input wire         WB_kick_up,
          output wire        IF_kick_up,
          output wire        inst_mem_read_enable,
          output wire [31:0] inst_mem_read_addr
          );
   reg                       IF_kick_up_internal;
   reg [31:0]                pc;
   // reg                       pc_ready;
   wire [31:0]               jmp_destination;
   wire [31:0]               normal_destination;
   wire [31:0]               pc_next;
   // assign jmp_destination = {imme[30:0], 1'b0} + pc; // TODO
   assign jmp_destination = imme + pc;
   assign normal_destination = pc + 4;
   assign pc_next = (Controller_branch && ALU_zero)? jmp_destination: normal_destination;

   always @ (posedge clk or posedge reset)
     if (reset) begin
        pc <= 0;
     end else begin
        if (WB_kick_up) pc <= pc_next;
        else pc <= pc;
     end
   assign inst_mem_read_addr = pc;

   // always @ (posedge clk or posedge reset)
   //   if (reset) pc_ready <= 1;
   //   else
   //     if (WB_kick_up) pc_ready <= 1;
   //     else
   //       if (IF_kick_up_internal) pc_ready <= 0;

   always @ (posedge clk or posedge reset)
     if (reset) IF_kick_up_internal <= 1;
     else
       if (WB_kick_up) IF_kick_up_internal <= 1;
       else IF_kick_up_internal <= 0;
   assign IF_kick_up = IF_kick_up_internal;
   assign inst_mem_read_enable = 1;
endmodule
