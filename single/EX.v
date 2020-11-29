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
    input wire        clk,
    input wire        reset,
    input wire [31:0] Read_data_1,
    input wire [31:0] Read_data_2,
    input wire [31:0] imme,
    input wire        Controller_alusrc,
    input wire [3:0]  Controller_aluop,
    input wire        ID_kick_up,
    output [31:0]     ALU_result,
    output            ALU_zero,
    output            ALU_kick_up
    );
   wire [31:0]        ALU_op_1;
   wire [31:0]        ALU_op_2;
   assign ALU_op_1 = Read_data_1;
   assign ALU_op_2 = Controller_alusrc?imme:Read_data_2;
   assign ALU_zero = (ALU_result == 0);

   always @ (posedge clk or negedge reset)
     if (~reset)
       ALU_result <= 0;
     else begin
        if (ID_kick_up) begin
           case (Controller_aluop)
             ALU_OP_ADD : ALU_result <= ALU_op_1 + ALU_op_2;
             ALU_OP_SUB : ALU_result <= ALU_op_1 - ALU_op_2;
             ALU_OP_AND : ALU_result <= ALU_op_1 & ALU_op_2;
             ALU_OP_OR : ALU_result <= ALU_op_1 | ALU_op_2;
             ALU_OP_XOR : ALU_result <= ALU_op_1 ^ ALU_op_2;
             ALU_OP_LT : ALU_result <= ($signed(ALU_op_1) < $signed(ALU_op_2))?32'b0:32'b1;
             ALU_OP_NONE : ALU_result <= 32'b0;
             ALU_OP_SHIFT_LEFT : ALU_result <= (ALU_op_1 << ALU_op_2[4:0]);
             ALU_OP_SHIFT_RIGHT : ALU_result <= (ALU_op_1 >> ALU_op_2[4:0]);
           endcase
        end
        else ALU_result <= ALU_result;
     end

   reg ALU_kick_up_internal;
   always @ (posedge clk or negedge reset)
     if (~reset)
       ALU_kick_up_internal <= 0;
     else begin
        if (ID_kick_up) ALU_kick_up_internal <= 1;
        else ALU_kick_up_internal <= 0;
     end
   assign ALU_kick_up = ALU_kick_up_internal;
endmodule
