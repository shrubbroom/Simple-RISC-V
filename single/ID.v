module ID #(
            parameter OP_IMME_ARITHMETIC =  7'b0010011,
            parameter OP_ARITHMETIC =  7'b0110011,
            parameter OP_CONDITIONAL_JMP =  7'b1100011,
            parameter OP_UNCONDITIONAL_JMP =  7'b1101111,
            parameter OP_MEMORY_LOAD =  7'b0000011,
            parameter OP_MEMORY_STORE =  7'b0100011
            )(
              input wire         clk,
              input wire         reset,
              input wire [31:0]  instruction,
              input wire         IF_kick_up,
              output wire        Controller_branch,
              output wire        Controller_memread,
              output wire        Controller_memtoreg,
              // output wire [1:0]  Controller_aluop,
              output wire [3:0]  Controller_aluop,
              output wire        Controller_memwrite,
              output wire        Controller_alusrc,
              output wire        Controller_regwrite,
              output wire [31:0] imme,
              output wire        Controller_kick_up
              );
   reg                           Controller_branch_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       Controller_branch_internal <= 0;
     else
       if (IF_kick_up) begin
          case (instruction[6:0])
            OP_CONDITIONAL_JMP : Controller_branch_internal <= 1;
            OP_UNCONDITIONAL_JMP : Controller_branch_internal <= 1;
            default : Controller_branch_internal <= 0;
          endcase
       end
       else Controller_branch_internal <= Controller_branch_internal;
   assign Controller_branch = Controller_branch_internal;

   reg Controller_memread_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       Controller_memread_internal <= 0;
     else
       if (IF_kick_up) begin
          case (instruction[6:0])
            OP_MEMORY_LOAD : Controller_memread_internal <= 1;
            default : Controller_memread_internal <= 0;
          endcase
       end
       else Controller_memread_internal <= Controller_memread_internal;
   assign Controller_memread = Controller_memread_internal;

   reg Controller_memtoreg_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       Controller_memtoreg_internal <= 0;
     else
       if (IF_kick_up) begin
          case (instruction[6:0])
            OP_MEMORY_LOAD : Controller_memtoreg_internal <= 1;
            default : Controller_memtoreg_internal <= 0;
          endcase
       end
       else Controller_memtoreg_internal <= Controller_memtoreg_internal;
   assign Controller_memtoreg = Controller_memtoreg_internal;

   reg Controller_memwrite_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       Controller_memwrite_internal <= 0;
     else
       if (IF_kick_up) begin
          case (instruction[6:0])
            OP_MEMORY_STORE : Controller_memwrite_internal <= 1;
            default : Controller_memwrite_internal <= 0;
          endcase
       end
       else Controller_memwrite_internal <= Controller_memwrite_internal;
   assign Controller_memwrite = Controller_memwrite_internal;

   reg Controller_regwrite_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       Controller_regwrite_internal <= 0;
     else
       if (IF_kick_up) begin
          case (instruction[6:0])
            OP_MEMORY_LOAD : Controller_regwrite_internal <= 1;
            OP_IMME_ARITHMETIC : Controller_regwrite_internal <= 1;
            OP_ARITHMETIC : Controller_regwrite_internal <= 1;
            default : Controller_regwrite_internal <= 0;
          endcase
       end
       else Controller_regwrite_internal <= Controller_regwrite_internal;
   assign Controller_regwrite = Controller_regwrite_internal;

   reg Controller_alusrc_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       Controller_alusrc_internal <= 0;
     else
       if (IF_kick_up) begin
          case (instruction[6:0])
            OP_MEMORY_LOAD : Controller_alusrc_internal <= 1;
            OP_MEMORY_STORE : Controller_alusrc_internal <= 1;
            OP_IMME_ARITHMETIC : Controller_alusrc_internal <= 1;
            default : Controller_alusrc_internal <= 0;
          endcase
       end
       else Controller_alusrc_internal <= Controller_alusrc_internal;
   assign Controller_alusrc = Controller_alusrc_internal;

   ID_ALU_OP ID_ALU_OP(.opcode(instruction[6:0]),
                       .func3(instruction[14:12]),
                       .func7_sign(instruction[30]),
                       .ALU_op(Controller_aluop)
                       );

   reg [31:0] imme_internal;
   always @ (posedge clk or posedge reset)
     if (reset) begin
        imme_internal <= 0;
     end
     else
       if (IF_kick_up) begin
          case (instruction[6:0])
            OP_ARITHMETIC : imme_internal <= 0;
            OP_IMME_ARITHMETIC :
              imme_internal <= instruction[31]==1?
                               {{20{1'b1}}, instruction[31:20]}:
                               {20'b0, instruction[31:20]};
            OP_CONDITIONAL_JMP :
              imme_internal <= instruction[31]==1?
                               {{19{1'b1}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}:
                               {19'b0, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            OP_UNCONDITIONAL_JMP :
              imme_internal <= instruction[31]==1?
                               {{11{1'b1}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}:
                               {11'b0, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            OP_MEMORY_LOAD :
              imme_internal <= instruction[31]==1?
                               {{20{1'b1}}, instruction[31:20]}:
                               {20'b0, instruction[31:20]};
            OP_MEMORY_STORE :
              imme_internal <= instruction[31]==1?
                               {{20{1'b1}}, instruction[31:25], instruction[11:7]}:
                               {20'b0, instruction[31:25], instruction[11:7]};
            default :
              imme_internal <= 0;
          endcase // case (instruction[6:0])
       end // if (IF_kick_up)
       else imme_internal <= imme_internal;
   assign imme = imme_internal;

   // reg imme_ready;
   // always @ (posedge clk or posedge reset)
   //   if (reset) imme_ready <= 0;
   //   else
   //     if (IF_kick_up) imme_ready <= 1;
   //     else
   //       if (imme_kick_up_internal) imme_ready <= 0;

   // reg imme_kick_up_internal;
   // always @ (posedge clk or posedge reset)
   //   if (reset) imme_kick_up_internal <= 0;
   //   else
   //     if (imme_ready && ~imme_kick_up_internal) imme_kick_up_internal <= 1;
   //     else imme_kick_up_internal <= 0;
   reg Controller_kick_up_internal;
   always @ (posedge clk or posedge reset)
     if (reset) Controller_kick_up_internal <= 0;
     else
       if (IF_kick_up) Controller_kick_up_internal <= 1;
       else Controller_kick_up_internal <= 0;
   assign Controller_kick_up = Controller_kick_up_internal;
endmodule
