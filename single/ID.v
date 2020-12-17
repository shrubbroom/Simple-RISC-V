`include "ID_ALU_OP.v"
module ID #(
            parameter OP_IMME_ARITHMETIC =  7'b0010011,
            parameter OP_ARITHMETIC =  7'b0110011,
            parameter OP_CONDITIONAL_JMP =  7'b1100011,
            parameter OP_UNCONDITIONAL_JMP =  7'b1101111,
            parameter OP_MEMORY_LOAD =  7'b0000011,
            parameter OP_MEMORY_STORE =  7'b0100011
            )(
              input wire [31:0] instruction,
              output reg        ID_branch,
              output reg        ID_memread,
              output reg        ID_memtoreg,
              output wire [3:0]  ID_aluop,
              output reg        ID_memwrite,
              output reg        ID_alusrc,
              output reg        ID_regwrite,
              output reg [31:0] ID_imme,
              output reg ID_unconditional_jmp
              );
   always @ (*)
     case (instruction[6:0])
       OP_CONDITIONAL_JMP : ID_branch = 1;
       OP_UNCONDITIONAL_JMP : ID_branch = 1;
       default : ID_branch = 0;
     endcase

   always @ (*)
     case (instruction[6:0])
       OP_MEMORY_LOAD : ID_memread = 1;
       default : ID_memread = 0;
     endcase

   always @ (*)
     case (instruction[6:0])
       OP_MEMORY_LOAD : ID_memtoreg = 1;
       default : ID_memtoreg = 0;
     endcase

   always @ (*)
     case (instruction[6:0])
       OP_MEMORY_STORE : ID_memwrite = 1;
       default : ID_memwrite = 0;
     endcase

   always @ (*)
     case (instruction[6:0])
       OP_MEMORY_LOAD : ID_regwrite = 1;
       OP_IMME_ARITHMETIC : ID_regwrite = 1;
       OP_ARITHMETIC : ID_regwrite = 1;
       OP_UNCONDITIONAL_JMP : ID_regwrite = 1;
       default : ID_regwrite = 0;
     endcase

   always @ (*)
     case (instruction[6:0])
       OP_MEMORY_LOAD : ID_alusrc = 1;
       OP_MEMORY_STORE : ID_alusrc = 1;
       OP_IMME_ARITHMETIC : ID_alusrc = 1;
       default : ID_alusrc = 0;
     endcase

   ID_ALU_OP ID_ALU_OP(.opcode(instruction[6:0]),
                       .func3(instruction[14:12]),
                       .func7_sign(instruction[30]),
                       .ALU_op(ID_aluop)
                       );

   always @ (*)
     case (instruction[6:0])
       OP_ARITHMETIC : ID_imme = 0;
       OP_IMME_ARITHMETIC :
         ID_imme = instruction[31]==1?
                   {{20{1'b1}}, instruction[31:20]}:
                   {20'b0, instruction[31:20]};
       OP_CONDITIONAL_JMP :
         ID_imme = instruction[31]==1?
                   {{19{1'b1}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}:
                   {19'b0, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
       OP_UNCONDITIONAL_JMP :
         ID_imme = instruction[31]==1?
                   {{11{1'b1}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}:
                   {11'b0, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
       OP_MEMORY_LOAD :
         ID_imme = instruction[31]==1?
                   {{20{1'b1}}, instruction[31:20]}:
                   {20'b0, instruction[31:20]};
       OP_MEMORY_STORE :
         ID_imme = instruction[31]==1?
                   {{20{1'b1}}, instruction[31:25], instruction[11:7]}:
                   {20'b0, instruction[31:25], instruction[11:7]};
       default :
         ID_imme = 0;
     endcase // case (instruction[6:0])

   always @ *
      if (instruction[6:0] == OP_UNCONDITIONAL_JMP)
        ID_unconditional_jmp = 1;
      else
        ID_unconditional_jmp = 0;

endmodule
