module ID #(
            parameter OP_IMME_ARITHMETIC =  7'b0010011,
            parameter OP_ARITHMETIC =  7'b0110011,
            parameter OP_CONDITIONAL_JMP =  7'b1100011,
            parameter OP_UNCONDITIONAL_JMP =  7'b1101111,
            parameter OP_MEMORY_LOAD =  7'b0000011,
            parameter OP_MEMORY_STORE =  7'b0100011
            )(
              input         clk,
              input         reset,
              input [31:0]  instruction,
              input         EX_kick_up,
              input         EX_flush,
              input         IF_ID_kick_up,
              output        ID_branch,
              output        ID_memread,
              output        ID_memtoreg,
              // output wire [1:0]  ID_aluop,
              output [3:0]  ID_aluop,
              output        ID_memwrite,
              output        ID_alusrc,
              output        ID_regwrite,
              output [31:0] imme,
              output [4:0]  rs1,
              output [4:0]  rs2,
              output [4:0]  rd,
              output        ID_kick_up
              );

   reg                      initial_reg;
   always @ (posedge clk or posedge reset)
      if (reset)
        initial_reg <= 0;
      else
        if (IF_ID_kick_up) initial_reg <= 1;
        else initial_reg <= initial_reg;


   reg [31:0]               instruction_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       instruction_internal <= 0;
     else
       if (initial_reg == 0) begin
          if (IF_ID_kick_up) instruction_internal <= instruction;
          else instruction_internal <= instruction_internal;
       end
       else
         if (EX_flush) begin
            instruction_internal <= 0; // This is nope
         end
         else begin
            if (EX_kick_up) instruction_internal <= instruction;
            else instruction_internal <= instruction_internal;
         end

   reg ID_kick_up_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_kick_up_internal <= 0;
     else
       if (initial_reg == 0) begin
          if (IF_ID_kick_up) ID_kick_up_internal <= 1;
          else ID_kick_up_internal <= 0;
       end
       else begin
          if (EX_kick_up) ID_kick_up_internal <= 1;
          else ID_kick_up_internal <= 0;
       end
   assign ID_kick_up = ID_kick_up_internal;


   reg                      ID_branch_internal;
   always @ *
     case (instruction_internal[6:0])
       OP_CONDITIONAL_JMP : ID_branch_internal = 1;
       OP_UNCONDITIONAL_JMP : ID_branch_internal = 1;
       default : ID_branch_internal = 0;
     endcase
   assign ID_branch = ID_branch_internal;

   reg                      ID_memread_internal;
   always @ *
     case (instruction_internal[6:0])
       OP_MEMORY_LOAD : ID_memread_internal = 1;
       default : ID_memread_internal = 0;
     endcase
   assign ID_memread = ID_memread_internal;

   reg                      ID_memtoreg_internal;
   always @ *
     case (instruction_internal[6:0])
       OP_MEMORY_LOAD : ID_memtoreg_internal = 1;
       default : ID_memtoreg_internal = 0;
     endcase
   assign ID_memtoreg = ID_memtoreg_internal;

   reg                      ID_memwrite_internal;
   always @ *
     case (instruction_internal[6:0])
       OP_MEMORY_STORE : ID_memwrite_internal = 1;
       default : ID_memwrite_internal = 0;
     endcase
   assign ID_memwrite = ID_memwrite_internal;

   reg                      ID_regwrite_internal;
   always @ *
     case (instruction_internal[6:0])
       OP_MEMORY_LOAD : ID_regwrite_internal = 1;
       OP_IMME_ARITHMETIC : ID_regwrite_internal = 1;
       OP_ARITHMETIC : ID_regwrite_internal = 1;
       default : ID_regwrite_internal = 0;
     endcase
   assign ID_regwrite = ID_regwrite_internal;

   reg                      ID_alusrc_internal;
   always @ *
     case (instruction_internal[6:0])
       OP_MEMORY_LOAD : ID_alusrc_internal = 1;
       OP_MEMORY_STORE : ID_alusrc_internal = 1;
       OP_IMME_ARITHMETIC : ID_alusrc_internal = 1;
       default : ID_alusrc_internal = 0;
     endcase
   assign ID_alusrc = ID_alusrc_internal;

   ID_ALU_OP ID_ALU_OP(
                       .EX_flush(EX_flush),
                       .opcode(instruction_internal[6:0]),
                       .func3(instruction_internal[14:12]),
                       .func7_sign(instruction_internal[30]),
                       .ALU_op(ID_aluop)
                       );

   reg [31:0]               imme_internal;
   always @ *
     case (instruction_internal[6:0])
       OP_ARITHMETIC : imme_internal = 0;
       OP_IMME_ARITHMETIC :
         imme_internal = instruction_internal[31]==1?
                         {{20{1'b1}}, instruction_internal[31:20]}:
                         {20'b0, instruction_internal[31:20]};
       OP_CONDITIONAL_JMP :
         imme_internal = instruction_internal[31]==1?
                         {{19{1'b1}}, instruction_internal[31], instruction_internal[7], instruction_internal[30:25], instruction_internal[11:8], 1'b0}:
                         {19'b0, instruction_internal[31], instruction_internal[7], instruction_internal[30:25], instruction_internal[11:8], 1'b0};
       OP_UNCONDITIONAL_JMP :
         imme_internal = instruction_internal[31]==1?
                         {{11{1'b1}}, instruction_internal[31], instruction_internal[19:12], instruction_internal[20], instruction_internal[30:21], 1'b0}:
                         {11'b0, instruction_internal[31], instruction_internal[19:12], instruction_internal[20], instruction_internal[30:21], 1'b0};
       OP_MEMORY_LOAD :
         imme_internal = instruction_internal[31]==1?
                         {{20{1'b1}}, instruction_internal[31:20]}:
                         {20'b0, instruction_internal[31:20]};
       OP_MEMORY_STORE :
         imme_internal = instruction_internal[31]==1?
                         {{20{1'b1}}, instruction_internal[31:25], instruction_internal[11:7]}:
                         {20'b0, instruction_internal[31:25], instruction_internal[11:7]};
       default :
         imme_internal = 0;
     endcase // case (instruction_internal[6:0])
   assign imme = imme_internal;

   reg [4:0]                rs1_internal;
   always @ *
     rs1_internal = instruction[19:15];
   assign rs1 = rs1_internal;

   reg [4:0]                rs2_internal;
   always @ *
     rs2_internal = instruction[24:20];
   assign rs2 = rs2_internal;

   reg [4:0]                rd_internal;
   always @ *
     rd_internal = instruction[11:7];
   assign rd = rd_internal;


endmodule
