module ID_EX_reg(
                 input             clk,
                 input             reset,
                 // input             EX_flush,
                 input             EX_stall,
                 input             ID_branch,
                 input             ID_memread,
                 input             ID_memtoreg,
                 input [3:0]       ID_aluop,
                 input             ID_memwrite,
                 input             ID_alusrc,
                 input             ID_regwrite,
                 input [31:0]      ID_imme,
                 input [4:0]       ID_rs1,
                 // input [31:0]      ID_rs1_data,
                 input [4:0]       ID_rs2,
                 // input [31:0]      ID_rs2_data,
                 input [4:0]       ID_rd,
                 input             ID_unconditional_jmp,
                 input [31:0]      ID_pc,
                 // input             ID_take,
                 output reg        ID_EX_branch,
                 output reg        ID_EX_memread,
                 output reg        ID_EX_memtoreg,
                 output reg [3:0]  ID_EX_aluop,
                 output reg        ID_EX_memwrite,
                 output reg        ID_EX_alusrc,
                 output reg        ID_EX_regwrite,
                 output reg [31:0] ID_EX_imme,
                 output reg [4:0]  ID_EX_rs1,
                 // output reg [31:0] ID_EX_rs1_data,
                 output reg [4:0]  ID_EX_rs2,
                 // output reg [31:0] ID_EX_rs2_data,
                 output reg [4:0]  ID_EX_rd,
                 output reg        ID_EX_unconditional_jmp,
                 output reg [31:0] ID_EX_pc
                 // output reg        ID_EX_take
                 /*AUTOINPUT*/
                 );
   /*AUTOWIRE*/
   // ID_EX_stall_hazard_checker ID_EX_stall_hazard_checker(/*AUTOINST*/
   //                                                       // Outputs
   //                                                       .ID_EX_stall_hazard_rs1_data(ID_EX_stall_hazard_rs1_data[31:0]),
   //                                                       .ID_EX_stall_hazard_rs2_data(ID_EX_stall_hazard_rs2_data[31:0]),
   //                                                       .ID_EX_stall_hazard_rs1_data_enable(ID_EX_stall_hazard_rs1_data_enable),
   //                                                       .ID_EX_stall_hazard_rs2_data_enable(ID_EX_stall_hazard_rs2_data_enable),
   //                                                       // Inputs
   //                                                       .EX_stall              (EX_stall),
   //                                                       .ID_EX_rs1             (ID_EX_rs1[4:0]),
   //                                                       .ID_EX_rs2             (ID_EX_rs2[4:0]),
   //                                                       .MEM_WB_rd             (MEM_WB_rd[4:0]),
   //                                                       .MEM_WB_regwrite       (MEM_WB_regwrite),
   //                                                       .MEM_WB_result         (MEM_WB_result[31:0]),
   //                                                       .EX_MEM_rd             (EX_MEM_rd[4:0]),
   //                                                       .EX_MEM_ALU_result     (EX_MEM_ALU_result[31:0]),
   //                                                       .EX_MEM_memread        (EX_MEM_memread),
   //                                                       .EX_MEM_regwrite       (EX_MEM_regwrite));
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_branch <= 0;
     else
       if (EX_stall) ID_EX_branch <= ID_EX_branch;
       else
         ID_EX_branch <= ID_branch;

   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_memread <= 0;
     else
       if (EX_stall) ID_EX_memread <= ID_EX_memread;
       else
         ID_EX_memread <= ID_memread;

   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_memtoreg <= 0;
     else
       if (EX_stall) ID_EX_memtoreg <= ID_EX_memtoreg;
       else
         ID_EX_memtoreg <= ID_memtoreg;

   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_aluop <= 0;
     else
       if (EX_stall) ID_EX_aluop <= ID_EX_aluop;
       else
         ID_EX_aluop <= ID_aluop;

   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_memwrite <= 0;
     else
       if (EX_stall) ID_EX_memwrite <= ID_EX_memwrite;
       else
         ID_EX_memwrite <= ID_memwrite;

   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_alusrc <= 0;
     else
       if (EX_stall) ID_EX_alusrc <= ID_EX_alusrc;
       else
         ID_EX_alusrc <= ID_alusrc;

   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_regwrite <= 0;
     else
       if (EX_stall) ID_EX_regwrite <= ID_EX_regwrite;
       else
         ID_EX_regwrite <= ID_regwrite;

   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_imme <= 0;
     else
       if (EX_stall) ID_EX_imme <= ID_EX_imme;
       else
         ID_EX_imme <= ID_imme;

   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_rs1 <= 0;
     else
       if (EX_stall)
         ID_EX_rs1 <= ID_EX_rs1;
       else
         ID_EX_rs1 <= ID_rs1;

   // always @ (posedge clk or posedge reset)
   //   if (reset)
   //     ID_EX_rs1_data <= 0;
   //   else
   //     if (EX_stall) begin
   //        if (ID_EX_stall_hazard_rs1_data_enable)
   //          ID_EX_rs1_data <= ID_EX_stall_hazard_rs1_data;
   //        else
   //          ID_EX_rs1_data <= ID_EX_rs1_data;
   //     end
   //     else
   //       ID_EX_rs1_data <= ID_rs1_data;

   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_rs2 <= 0;
     else
       if (EX_stall)
         ID_EX_rs2 <= ID_EX_rs2;
       else
         ID_EX_rs2 <= ID_rs2;

   // always @ (posedge clk or posedge reset)
   //   if (reset)
   //     ID_EX_rs2_data <= 0;
   //   else
   //     if (EX_stall) begin
   //        if (ID_EX_stall_hazard_rs2_data_enable)
   //          ID_EX_rs2_data <= ID_EX_stall_hazard_rs2_data;
   //        else
   //          ID_EX_rs2_data <= ID_EX_rs2_data;
   //     end
   //     else
   //       ID_EX_rs2_data <= ID_rs2_data;


   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_rd <= 0;
     else
       if (EX_stall)
         ID_EX_rd <= ID_EX_rd;
       else
         ID_EX_rd <= ID_rd;

   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_unconditional_jmp <= 0;
     else
       if (EX_stall)
         ID_EX_unconditional_jmp <= ID_EX_unconditional_jmp;
       else
         ID_EX_unconditional_jmp <= ID_unconditional_jmp;

   always @ (posedge clk or posedge reset)
     if (reset)
       ID_EX_pc <= 0;
     else
       if (EX_stall)
         ID_EX_pc <= ID_EX_pc;
       else
         ID_EX_pc <= ID_pc;

   // always @ (posedge clk or posedge reset)
   //   if (reset)
   //     ID_EX_take <= 0;
   //   else
   //     if (EX_stall)
   //       ID_EX_take <= ID_EX_take;
   //     else
   //       ID_EX_take <= ID_take;

endmodule
