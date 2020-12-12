module ID_ALU_OP#(
                  parameter OP_IMME_ARITHMETIC =  7'b0010011,
                  parameter OP_ARITHMETIC =  7'b0110011,
                  parameter OP_CONDITIONAL_JMP =  7'b1100011,
                  parameter OP_UNCONDITIONAL_JMP =  7'b1101111,
                  parameter OP_MEMORY_LOAD =  7'b0000011,
                  parameter OP_MEMORY_STORE =  7'b0100011,
                  parameter FUNC3_BEQ = 3'b0,
                  parameter FUNC3_BLT = 3'b100,
                  parameter FUNC3_ADDI = 3'b0,
                  parameter FUNC3_LW = 3'b010,
                  parameter FUNC3_SW = 3'b010,
                  parameter FUNC3_ADD = 3'b000,
                  parameter FUNC3_SUB = 3'b000,
                  parameter FUNC3_SLL = 3'b001,
                  parameter FUNC3_SRL = 3'b101,
                  parameter FUNC3_OR = 3'b110,
                  parameter FUNC3_AND = 3'b111,
                  parameter FUNC3_XOR = 3'b100,
                  parameter ALU_OP_ADD = 4'd0,
                  parameter ALU_OP_SUB = 4'd1,
                  parameter ALU_OP_AND = 4'd2,
                  parameter ALU_OP_OR = 4'd3,
                  parameter ALU_OP_XOR = 4'd4,
                  parameter ALU_OP_LT = 4'd5,
                  parameter ALU_OP_JUMP = 4'd6,
                  parameter ALU_OP_SHIFT_LEFT = 4'd7,
                  parameter ALU_OP_SHIFT_RIGHT = 4'd8,
                  parameter ALU_OP_NOPE = 4'd9
                  )
   (
    input wire [6:0]  opcode,
    input wire [2:0]  func3,
    input wire        func7_sign,
    output wire [3:0] ALU_op
    );
   reg [3:0]          ALU_op_internal;
   always @ (*)
     case (opcode)
       OP_IMME_ARITHMETIC : begin
          if (func3 == FUNC3_ADDI) ALU_op_internal = ALU_OP_ADD;
          else ALU_op_internal = ALU_OP_ADD;
       end
       OP_ARITHMETIC : begin
          case (func3)
            FUNC3_ADD : begin
               if (func7_sign) ALU_op_internal = ALU_OP_SUB;
               else ALU_op_internal = ALU_OP_ADD;
            end
            FUNC3_SLL : ALU_op_internal = ALU_OP_SHIFT_LEFT;
            FUNC3_SRL : ALU_op_internal = ALU_OP_SHIFT_RIGHT;
            FUNC3_AND : ALU_op_internal = ALU_OP_AND;
            FUNC3_OR : ALU_op_internal = ALU_OP_OR;
            FUNC3_XOR : ALU_op_internal = ALU_OP_XOR;
            default : ALU_op_internal = ALU_OP_ADD;
          endcase
       end
       OP_CONDITIONAL_JMP : begin
          case (func3)
            FUNC3_BLT : ALU_op_internal = ALU_OP_LT;
            FUNC3_BEQ : ALU_op_internal = ALU_OP_SUB;
            default : ALU_op_internal = ALU_OP_SUB;
          endcase // case (func3)
       end
       OP_UNCONDITIONAL_JMP : ALU_op_internal = ALU_OP_JUMP;
       OP_MEMORY_LOAD : ALU_op_internal = ALU_OP_ADD;
       OP_MEMORY_STORE : ALU_op_internal = ALU_OP_ADD;
       default : ALU_op_internal = ALU_OP_ADD;
     endcase
   assign ALU_op = ALU_op_internal;
endmodule
