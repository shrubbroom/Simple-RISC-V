module EX#(
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
           ) (
              input wire [4:0]  ID_EX_rs1,
              input wire [31:0] ID_EX_rs1_data,
              input wire [4:0]  ID_EX_rs2,
              input wire [31:0] ID_EX_rs2_data,
              input wire [4:0]  ID_EX_rd,
              input wire        ID_EX_branch,
              input wire        ID_EX_alusrc,
              input wire [3:0]  ID_EX_aluop,
              input wire [31:0] ID_EX_imme,
              input wire        ID_EX_memread,
              input wire        ID_EX_memtoreg,
              input wire        ID_EX_memwrite,
              input wire        ID_EX_regwrite,
              input wire        ID_EX_take,
              output reg [31:0] EX_ALU_result,
              output reg        EX_zero,
              output reg [4:0]  EX_rd,
              output            EX_stall,
              output            EX_branch,
              output reg        EX_memread,
              output reg        EX_memtoreg,
              output reg        EX_memwrite,
              output reg        EX_regwrite,
              output reg [31:0] EX_rs1_data,
              output reg [31:0] EX_rs2_data,
              output reg        EX_take,
              /*AUTOINPUT*/
              // Beginning of automatic inputs (from unused autoinst inputs)
              input [31:0]      EX_MEM_ALU_result, // To EX_hazard_checker of EX_hazard_checker.v
              input             EX_MEM_memtoreg, // To EX_hazard_checker of EX_hazard_checker.v
              input [4:0]       EX_MEM_rd, // To EX_hazard_checker of EX_hazard_checker.v
              input             EX_MEM_regwrite, // To EX_hazard_checker of EX_hazard_checker.v
              input [4:0]       MEM_WB_rd, // To EX_hazard_checker of EX_hazard_checker.v
              input             MEM_WB_regwrite, // To EX_hazard_checker of EX_hazard_checker.v
              input [31:0]      MEM_WB_result          // To EX_hazard_checker of EX_hazard_checker.v
              // End of automatics
              );
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [31:0]          EX_hazard_rs1_data;     // From EX_hazard_checker of EX_hazard_checker.v
   wire                 EX_hazard_rs1_data_enable;// From EX_hazard_checker of EX_hazard_checker.v
   wire [31:0]          EX_hazard_rs2_data;     // From EX_hazard_checker of EX_hazard_checker.v
   wire                 EX_hazard_rs2_data_enable;// From EX_hazard_checker of EX_hazard_checker.v
   // End of automatics
   EX_hazard_checker EX_hazard_checker(/*AUTOINST*/
                                       // Outputs
                                       .EX_stall        (EX_stall),
                                       .EX_hazard_rs1_data(EX_hazard_rs1_data[31:0]),
                                       .EX_hazard_rs1_data_enable(EX_hazard_rs1_data_enable),
                                       .EX_hazard_rs2_data(EX_hazard_rs2_data[31:0]),
                                       .EX_hazard_rs2_data_enable(EX_hazard_rs2_data_enable),
                                       // Inputs
                                       .ID_EX_rs1       (ID_EX_rs1[4:0]),
                                       .ID_EX_rs2       (ID_EX_rs2[4:0]),
                                       .EX_MEM_rd       (EX_MEM_rd[4:0]),
                                       .EX_MEM_regwrite (EX_MEM_regwrite),
                                       .EX_MEM_ALU_result(EX_MEM_ALU_result[31:0]),
                                       .EX_MEM_memtoreg (EX_MEM_memtoreg),
                                       .MEM_WB_rd       (MEM_WB_rd[4:0]),
                                       .MEM_WB_result   (MEM_WB_result[31:0]),
                                       .MEM_WB_regwrite (MEM_WB_regwrite),
                                       .ID_EX_alusrc    (ID_EX_alusrc));
   // reg [31:0]                   EX_rs1_data;
   // reg [31:0]                   EX_rs2_data;
   always @ *
     if (ID_EX_alusrc) EX_rs1_data = ID_EX_imme;
     else
       if (EX_hazard_rs1_data_enable) EX_rs1_data = EX_hazard_rs1_data;
       else
         EX_rs1_data = ID_EX_rs1_data;

   always @ *
     if (EX_hazard_rs2_data_enable) EX_rs2_data = EX_hazard_rs2_data;
     else
       EX_rs2_data = ID_EX_rs2_data;

   always @ *
     case (ID_EX_aluop)
       ALU_OP_ADD : EX_ALU_result = EX_rs1_data + EX_rs2_data;
       ALU_OP_SUB : EX_ALU_result = EX_rs1_data - EX_rs2_data;
       ALU_OP_AND : EX_ALU_result = EX_rs1_data & EX_rs2_data;
       ALU_OP_OR : EX_ALU_result = EX_rs1_data | EX_rs2_data;
       ALU_OP_XOR : EX_ALU_result = EX_rs1_data ^ EX_rs2_data;
       ALU_OP_LT : EX_ALU_result = ($signed(EX_rs1_data) < $signed(EX_rs2_data))?32'b0:32'b1;
       ALU_OP_JUMP : EX_ALU_result = 32'b0;
       ALU_OP_SHIFT_LEFT : EX_ALU_result = (EX_rs1_data << EX_rs2_data[4:0]);
       ALU_OP_SHIFT_RIGHT : EX_ALU_result = (EX_rs1_data >> EX_rs2_data[4:0]);
       ALU_OP_NOPE : EX_ALU_result = 32'b0;
       default : EX_ALU_result = 0;
     endcase // case (ID_EX_aluop)

   always @ *
     if (ID_EX_aluop == ALU_OP_NOPE)
       EX_zero = 0;
     else EX_zero = (EX_ALU_result == 0);

   always @ *
     EX_rd = ID_EX_rd;

   always @ *
     EX_memread = ID_EX_memread;

   always @ *
     EX_memwrite = ID_EX_memwrite;

   always @ *
     EX_memtoreg = ID_EX_memtoreg;

   always @ *
     EX_regwrite = ID_EX_regwrite;

   always @ *
     EX_branch = ID_EX_branch;

   always @ *
     EX_take = ID_EX_take;

endmodule // EX
