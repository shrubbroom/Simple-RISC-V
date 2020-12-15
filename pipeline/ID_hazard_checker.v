module ID_hazard_checker(
                         input [4:0]       MEM_WB_rd,
                         input [31:0]      MEM_WB_result,
                         input             MEM_WB_regwrite,
                         input [4:0]       EX_MEM_rd,
                         input [31:0]      EX_MEM_ALU_result,
                         input             EX_MEM_regwrite,
                         input             EX_MEM_memread,
                         input [4:0]       ID_rs1,
                         output reg        ID_hazard_rs1_data_enable,
                         output reg [31:0] ID_hazard_rs1_data,
                         input [4:0]       ID_rs2,
                         output reg        ID_hazard_rs2_data_enable,
                         output reg [31:0] ID_hazard_rs2_data
                         );
   always @ *
     if (EX_MEM_rd != 0 && EX_MEM_rd == ID_rs1 && EX_MEM_regwrite && !EX_MEM_memread) begin
        ID_hazard_rs1_data = EX_MEM_ALU_result;
        ID_hazard_rs1_data_enable = 1;
     end
     else
       if (MEM_WB_rd != 0 && MEM_WB_rd == ID_rs1 && MEM_WB_regwrite) begin
          ID_hazard_rs1_data = MEM_WB_result;
          ID_hazard_rs1_data_enable = 1;
       end
       else begin
          ID_hazard_rs1_data = 0;
          ID_hazard_rs1_data_enable = 0;
       end

   always @ *
     if (EX_MEM_rd != 0 && EX_MEM_rd == ID_rs2 && EX_MEM_regwrite && !EX_MEM_memread) begin
        ID_hazard_rs2_data = EX_MEM_ALU_result;
        ID_hazard_rs2_data_enable = 1;
     end
     else
       if (MEM_WB_rd != 0 && MEM_WB_rd == ID_rs2 && MEM_WB_regwrite) begin
          ID_hazard_rs2_data = MEM_WB_result;
          ID_hazard_rs2_data_enable = 1;
       end
       else begin
          ID_hazard_rs2_data = 0;
          ID_hazard_rs2_data_enable = 0;
       end

endmodule // ID_hazard_checker
