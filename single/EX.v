module EX
  #(
    parameter ALU_OP_ADD = 4'd0,
    parameter ALU_OP_SUB = 4'd1,
    parameter ALU_OP_AND = 4'd2,
    parameter ALU_OP_OR = 4'd3,
    parameter ALU_OP_XOR = 4'd4,
    parameter ALU_OP_LT = 4'd5,
    parameter ALU_OP_NONE = 4'd6,
    parameter ALU_OP_SHIFT_LEFT = 4'd7,
    parameter ALU_OP_SHIFT_RIGHT = 4'd8
    )
   (
    input wire [31:0] reg_read_data_1,
    input wire [31:0] reg_read_data_2,
    input wire [31:0] ID_imme,
    input wire        ID_alusrc,
    input wire [3:0]  ID_aluop,
    output reg [31:0] EX_result,
    output wire       EX_zero
    );
   wire [31:0]        ALU_op_1;
   reg [31:0]         ALU_op_2;

   assign ALU_op_1 = reg_read_data_1;

   always @ *
     if (ID_alusrc)
       ALU_op_2 = ID_imme;
     else
       ALU_op_2 = reg_read_data_2;

   assign EX_zero = (EX_result == 0);

   always @ *
     case (ID_aluop)
       ALU_OP_ADD : EX_result = ALU_op_1 + ALU_op_2;
       ALU_OP_SUB : EX_result = ALU_op_1 - ALU_op_2;
       ALU_OP_AND : EX_result = ALU_op_1 & ALU_op_2;
       ALU_OP_OR : EX_result = ALU_op_1 | ALU_op_2;
       ALU_OP_XOR : EX_result = ALU_op_1 ^ ALU_op_2;
       ALU_OP_LT : EX_result = ($signed(ALU_op_1) < $signed(ALU_op_2))?32'b0:32'b1;
       ALU_OP_NONE : EX_result = 32'b0;
       ALU_OP_SHIFT_LEFT : EX_result = (ALU_op_1 << ALU_op_2[4:0]);
       ALU_OP_SHIFT_RIGHT : EX_result = (ALU_op_1 >> ALU_op_2[4:0]);
       default : EX_result = 0;
     endcase

endmodule
