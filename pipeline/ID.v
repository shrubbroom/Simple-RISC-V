`include "ID_ALU_OP.v"
module ID #(
            parameter OP_IMME_ARITHMETIC =  7'b0010011,
            parameter OP_ARITHMETIC =  7'b0110011,
            parameter OP_CONDITIONAL_JMP =  7'b1100011,
            parameter OP_UNCONDITIONAL_JMP =  7'b1101111,
            parameter OP_MEMORY_LOAD =  7'b0000011,
            parameter OP_MEMORY_STORE =  7'b0100011
            )(
              input [31:0]      IF_ID_instruction,
              // input             IF_ID_take,
              input [4:0]       MEM_WB_rd,
              input [31:0]      MEM_WB_result,
              input             MEM_WB_regwrite,
              input [31:0]      reg_read_data_1,
              input [31:0]      reg_read_data_2,
              output reg        ID_branch,
              output reg        ID_unconditional_jmp,
              output reg        ID_memread,
              output reg        ID_memtoreg,
              // output wire [1:0]  ID_aluop,
              output [3:0]      ID_aluop,
              output reg        ID_memwrite,
              output reg        ID_alusrc,
              output reg        ID_regwrite,
              output reg [31:0] ID_imme,
              output reg [4:0]  ID_rs1,
              output reg [4:0]  ID_rs2,
              output reg [4:0]  ID_rd,
              // output reg        ID_take,
              output reg [31:0] ID_rs1_data,
              output reg [31:0] ID_rs2_data
              );


   always @ *
     case (IF_ID_instruction[6:0])
       OP_CONDITIONAL_JMP : ID_branch = 1;
       OP_UNCONDITIONAL_JMP : ID_branch = 1;
       default : ID_branch = 0;
     endcase

   always @ *
     case (IF_ID_instruction[6:0])
       OP_MEMORY_LOAD : ID_memread = 1;
       default : ID_memread = 0;
     endcase

   always @ *
     case (IF_ID_instruction[6:0])
       OP_MEMORY_LOAD : ID_memtoreg = 1;
       default : ID_memtoreg = 0;
     endcase

   always @ *
     case (IF_ID_instruction[6:0])
       OP_MEMORY_STORE : ID_memwrite = 1;
       default : ID_memwrite = 0;
     endcase

   always @ *
     case (IF_ID_instruction[6:0])
       OP_MEMORY_LOAD : ID_regwrite = 1;
       OP_IMME_ARITHMETIC : ID_regwrite = 1;
       OP_ARITHMETIC : ID_regwrite = 1;
       default : ID_regwrite = 0;
     endcase

   always @ *
     case (IF_ID_instruction[6:0])
       OP_MEMORY_LOAD : ID_alusrc = 1;
       OP_MEMORY_STORE : ID_alusrc = 1;
       OP_IMME_ARITHMETIC : ID_alusrc = 1;
       default : ID_alusrc = 0;
     endcase

   ID_ALU_OP ID_ALU_OP(
                       .opcode(IF_ID_instruction[6:0]),
                       .func3(IF_ID_instruction[14:12]),
                       .func7_sign(IF_ID_instruction[30]),
                       .ALU_op(ID_aluop)
                       );

   always @ *
     case (IF_ID_instruction[6:0])
       OP_ARITHMETIC : ID_imme = 0;
       OP_IMME_ARITHMETIC :
         ID_imme = IF_ID_instruction[31]==1?
                   {{20{1'b1}}, IF_ID_instruction[31:20]}:
                   {20'b0, IF_ID_instruction[31:20]};
       OP_CONDITIONAL_JMP :
         ID_imme = IF_ID_instruction[31]==1?
                   {{19{1'b1}},
                    IF_ID_instruction[31],
                    IF_ID_instruction[7],
                    IF_ID_instruction[30:25],
                    IF_ID_instruction[11:8],
                    1'b0}:
                   {19'b0,
                    IF_ID_instruction[31],
                    IF_ID_instruction[7],
                    IF_ID_instruction[30:25],
                    IF_ID_instruction[11:8],
                    1'b0};
       OP_UNCONDITIONAL_JMP :
         ID_imme = IF_ID_instruction[31]==1?
                   {{11{1'b1}},
                    IF_ID_instruction[31],
                    IF_ID_instruction[19:12],
                    IF_ID_instruction[20],
                    IF_ID_instruction[30:21],
                    1'b0}:
                   {11'b0,
                    IF_ID_instruction[31],
                    IF_ID_instruction[19:12],
                    IF_ID_instruction[20],
                    IF_ID_instruction[30:21],
                    1'b0};
       OP_MEMORY_LOAD :
         ID_imme = IF_ID_instruction[31]==1?
                   {{20{1'b1}}, IF_ID_instruction[31:20]}:
                   {20'b0, IF_ID_instruction[31:20]};
       OP_MEMORY_STORE :
         ID_imme = IF_ID_instruction[31]==1?
                   {{20{1'b1}}, IF_ID_instruction[31:25], IF_ID_instruction[11:7]}:
                   {20'b0, IF_ID_instruction[31:25], IF_ID_instruction[11:7]};
       default :
         ID_imme = 0;
     endcase // case (IF_ID_instruction[6:0])

   always @ *
     ID_rs1 = IF_ID_instruction[19:15];

   always @ *
     ID_rs2 = IF_ID_instruction[24:20];

   always @ *
     ID_rd = IF_ID_instruction[11:7];

   // always @ *
   //   ID_take = IF_ID_take;

   /*hazard resolve*/
   always @ *
     if (MEM_WB_rd == ID_rs1 && MEM_WB_regwrite)
       ID_rs1_data = MEM_WB_result;
     else
       ID_rs1_data = reg_read_data_1;

   always @ *
     if (MEM_WB_rd == ID_rs2 && MEM_WB_regwrite)
       ID_rs2_data = MEM_WB_result;
     else
       ID_rs2_data = reg_read_data_2;

   always @ *
     if (IF_ID_instruction[6:0] == OP_UNCONDITIONAL_JMP)
       ID_unconditional_jmp = 1;
     else
       ID_unconditional_jmp = 0;
endmodule
