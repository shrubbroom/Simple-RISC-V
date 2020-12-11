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
              input wire        clk,
              input wire        reset,
              input wire        ID_EX_kick_up,
              input wire        MEM_kick_up,
              input wire [4:0]  ID_EX_rs1,
              input wire [31:0] ID_EX_rs1_data,
              input wire [4:0]  ID_EX_rs2,
              input wire [31:0] ID_EX_rs2_data,
              input wire [4:0]  ID_EX_rd,
              input wire        ID_EX_branch,
              input wire        ID_EX_alusrc,
              input wire        ID_EX_aluop,
              input wire        ID_EX_imme,
              input wire        ID_EX_memread,
              input wire        ID_EX_memtoreg,
              input wire        ID_EX_memwrite,
              input wire        ID_EX_regwrite,
              output wire       EX_kick_up,
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
   wire [31:0]                  EX_hazard_rs1_data;     // From EX_hazard_checker of EX_hazard_checker.v
   wire                         EX_hazard_rs1_data_enable;// From EX_hazard_checker of EX_hazard_checker.v
   wire [31:0]                  EX_hazard_rs2_data;     // From EX_hazard_checker of EX_hazard_checker.v
   wire                         EX_hazard_rs2_data_enable;// From EX_hazard_checker of EX_hazard_checker.v
   wire                         EX_stall;               // From EX_hazard_checker of EX_hazard_checker.v
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
   wire [31:0]                  EX_rs1_data = EX_hazard_rs1_data_enable?EX_hazard_rs1_data:ID_EX_rs1_data;
   wire [31:0]                  EX_rs2_data = EX_hazard_rs1_data_enable?EX_hazard_rs1_data:ID_EX_rs2_data;

   reg                          initial_reg;
endmodule // EX
