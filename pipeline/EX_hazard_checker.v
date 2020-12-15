module EX_hazard_checker#(
                          parameter OP_IMME_ARITHMETIC =  7'b0010011,
                          parameter OP_ARITHMETIC =  7'b0110011,
                          parameter OP_CONDITIONAL_JMP =  7'b1100011,
                          parameter OP_UNCONDITIONAL_JMP =  7'b1101111,
                          parameter OP_MEMORY_LOAD =  7'b0000011,
                          parameter OP_MEMORY_STORE =  7'b0100011
                          ) (
                             input wire [4:0]   ID_EX_rs1,
                             input wire [4:0]   ID_EX_rs2,
                             // input wire [4:0]   ID_rd,
                             input wire [4:0]   EX_MEM_rd,
                             input wire         EX_MEM_regwrite,
                             input wire [31:0]  EX_MEM_ALU_result,
                             input wire         EX_MEM_memtoreg,
                             input wire         EX_MEM_memread,
                             input wire [4:0]   MEM_WB_rd, // rd in MEM_WB_reg
                             input wire [31:0]  MEM_WB_result, // result in MEM_WB_reg, this result can be ALU result (if this is not a mem operation) or MEM read result (is this is 'memtoreg' operation)
                             input wire         MEM_WB_regwrite,
                             output wire        EX_stall,
                             output wire [31:0] EX_hazard_rs1_data,
                             output             EX_hazard_rs1_data_enable,
                             output wire [31:0] EX_hazard_rs2_data,
                             output             EX_hazard_rs2_data_enable
                             );
   reg [31:0]                                   EX_rs1_data_internal;
   reg                                          EX_rs1_data_enable_internal;
   reg [31:0]                                   EX_rs2_data_internal;
   reg                                          EX_rs2_data_enable_internal;
   reg                                          EX_stall_internal;

   assign EX_hazard_rs1_data = EX_rs1_data_internal;
   assign EX_hazard_rs2_data = EX_rs2_data_internal;
   assign EX_hazard_rs1_data_enable = EX_rs1_data_enable_internal;
   assign EX_hazard_rs2_data_enable = EX_rs2_data_enable_internal;
   assign EX_stall = EX_stall_internal;

   always @ * begin
      if (EX_MEM_rd == ID_EX_rs1 && EX_MEM_regwrite && !EX_MEM_memread) begin
         EX_rs1_data_internal = EX_MEM_ALU_result;
         EX_rs1_data_enable_internal = 1;
      end else begin
         if (MEM_WB_rd == ID_EX_rs1 && MEM_WB_regwrite) begin
            EX_rs1_data_internal = MEM_WB_result;
            EX_rs1_data_enable_internal = 1;
         end else begin
            EX_rs1_data_internal =0;
            EX_rs1_data_enable_internal = 0;
         end
      end
   end

   always @ * begin
      if (EX_MEM_rd == ID_EX_rs2 && EX_MEM_regwrite && !EX_MEM_memread) begin
         EX_rs2_data_internal = EX_MEM_ALU_result;
         EX_rs2_data_enable_internal = 1;
      end else begin
         if (MEM_WB_rd == ID_EX_rs2 && MEM_WB_regwrite) begin
            EX_rs2_data_internal = MEM_WB_result;
            EX_rs2_data_enable_internal = 1;
         end else begin
            EX_rs2_data_internal =0;
            EX_rs2_data_enable_internal = 0;
         end
      end
   end


   always @ * begin
      if ((EX_MEM_rd == ID_EX_rs1 || EX_MEM_rd == ID_EX_rs2) && EX_MEM_memtoreg) EX_stall_internal = 1;
      else EX_stall_internal = 0;
   end
endmodule
