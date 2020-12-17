module ID_EX_stall_hazard_checker(
                                  input             EX_stall,
                                  input [4:0]       ID_EX_rs1,
                                  input [4:0]       ID_EX_rs2,
                                  input [4:0]       MEM_WB_rd,
                                  input             MEM_WB_regwrite,
                                  input [31:0]      MEM_WB_result,
                                  input [4:0]       EX_MEM_rd,
                                  input [31:0]      EX_MEM_ALU_result,
                                  input             EX_MEM_memread,
                                  input             EX_MEM_regwrite,
                                  output reg [31:0] ID_EX_stall_hazard_rs1_data,
                                  output reg [31:0] ID_EX_stall_hazard_rs2_data,
                                  output reg        ID_EX_stall_hazard_rs1_data_enable,
                                  output reg        ID_EX_stall_hazard_rs2_data_enable
                                  );
   always @ *
     if (EX_stall)
       begin
          if (EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rs1 && EX_MEM_regwrite && !EX_MEM_memread) begin
             ID_EX_stall_hazard_rs1_data = EX_MEM_ALU_result;
             ID_EX_stall_hazard_rs1_data_enable = 1;
          end
          else
            if (MEM_WB_rd != 0 && MEM_WB_rd == ID_EX_rs1 && MEM_WB_regwrite) begin
               ID_EX_stall_hazard_rs1_data = MEM_WB_result;
               ID_EX_stall_hazard_rs1_data_enable = 1;
            end
            else begin
               ID_EX_stall_hazard_rs1_data = 0;
               ID_EX_stall_hazard_rs1_data_enable = 0;
            end
       end // if (EX_stall)
     else
       begin end

   always @ *
     if (EX_stall)
       begin
          if (EX_MEM_rd != 0 && EX_MEM_rd == ID_EX_rs2 && EX_MEM_regwrite && !EX_MEM_memread) begin
             ID_EX_stall_hazard_rs2_data = EX_MEM_ALU_result;
             ID_EX_stall_hazard_rs2_data_enable = 1;
          end
          else
            if (MEM_WB_rd != 0 && MEM_WB_rd == ID_EX_rs2 && MEM_WB_regwrite) begin
               ID_EX_stall_hazard_rs2_data = MEM_WB_result;
               ID_EX_stall_hazard_rs2_data_enable = 1;
            end
            else begin
               ID_EX_stall_hazard_rs2_data = 0;
               ID_EX_stall_hazard_rs2_data_enable = 0;
            end
       end // if (EX_stall)
     else
       begin end

endmodule // ID_EX_stall_hazard_checker

