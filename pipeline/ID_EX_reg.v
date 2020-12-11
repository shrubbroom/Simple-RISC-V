module ID_EX_reg(
                 input         clk,
                 input         reset,
                 input         ID_kick_up,
                 input         ID_branch,
                 input         ID_memread,
                 input         ID_memtoreg,
                 input         ID_aluop,
                 input         ID_memwrite,
                 input         ID_alusrc,
                 input         ID_regwrite,
                 input [31:0]  ID_imme,
                 input [4:0]   ID_rs1,
                 input [31:0]  ID_rs1_data,
                 input [4:0]   ID_rs2,
                 input [31:0]  ID_rs2_data,
                 input [4:0]   ID_rd,
                 output        ID_EX_branch,
                 output        ID_EX_memread,
                 output        ID_EX_memtoreg,
                 output        ID_EX_aluop,
                 output        ID_EX_memwrite,
                 output        ID_EX_alusrc,
                 output        ID_EX_regwrite,
                 output [31:0] ID_EX_imme,
                 output [4:0]  ID_EX_rs1,
                 output [31:0] ID_EX_rs1_data,
                 output [4:0]  ID_EX_rs2,
                 output [31:0] ID_EX_rs2_data,
                 output [4:0]  ID_EX_rd
                 );
   reg                         ID_branch_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_branch_out_internal <= 0;
     else if (ID_kick_up) ID_branch_out_internal <= ID_branch;
     else ID_branch_out_internal <= ID_branch_out_internal;
   assign ID_EX_branch = ID_branch_out_internal;

   reg                         ID_memread_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_memread_out_internal <= 0;
     else if (ID_kick_up) ID_memread_out_internal <= ID_memread;
     else ID_memread_out_internal <= ID_memread_out_internal;
   assign ID_EX_memread = ID_memread_out_internal;

   reg                         ID_memtoreg_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_memtoreg_out_internal <= 0;
     else if (ID_kick_up) ID_memtoreg_out_internal <= ID_memtoreg;
     else ID_memtoreg_out_internal <= ID_memtoreg_out_internal;
   assign ID_EX_memtoreg = ID_memtoreg_out_internal;

   reg                         ID_aluop_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_aluop_out_internal <= 0;
     else if (ID_kick_up) ID_aluop_out_internal <= ID_aluop;
     else ID_aluop_out_internal <= ID_aluop_out_internal;
   assign ID_EX_aluop = ID_aluop_out_internal;

   reg                         ID_memwrite_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_memwrite_out_internal <= 0;
     else if (ID_kick_up) ID_memwrite_out_internal <= ID_memwrite;
     else ID_memwrite_out_internal <= ID_memwrite_out_internal;
   assign ID_EX_memwrite = ID_memwrite_out_internal;

   reg                         ID_alusrc_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_alusrc_out_internal <= 0;
     else if (ID_kick_up) ID_alusrc_out_internal <= ID_alusrc;
     else ID_alusrc_out_internal <= ID_alusrc_out_internal;
   assign ID_EX_alusrc = ID_alusrc_out_internal;

   reg                         ID_regwrite_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_regwrite_out_internal <= 0;
     else if (ID_kick_up) ID_regwrite_out_internal <= ID_regwrite;
     else ID_regwrite_out_internal <= ID_regwrite_out_internal;
   assign ID_EX_regwrite = ID_regwrite_out_internal;

   reg [31:0]                  imme_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       imme_out_internal <= 0;
     else if (ID_kick_up) imme_out_internal <= ID_imme;
     else imme_out_internal <= imme_out_internal;
   assign ID_EX_imme = imme_out_internal;

   reg [4:0]                   rs1_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       rs1_out_internal <= 0;
     else if (ID_kick_up) rs1_out_internal <= ID_rs1;
     else rs1_out_internal <= rs1_out_internal;
   assign ID_EX_rs1 = rs1_out_internal;

   reg [31:0]                  rs1_data_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       rs1_data_out_internal <= 0;
     else if (ID_kick_up) rs1_data_out_internal <= ID_rs1_data;
     else rs1_data_out_internal <= rs1_data_out_internal;
   assign ID_EX_rs1_data = rs1_data_out_internal;

   reg [4:0]                   rs2_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       rs2_out_internal <= 0;
     else if (ID_kick_up) rs2_out_internal <= ID_rs2;
     else rs2_out_internal <= rs2_out_internal;
   assign ID_EX_rs2 = rs2_out_internal;

   reg [31:0]                  rs2_data_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       rs2_data_out_internal <= 0;
     else if (ID_kick_up) rs2_data_out_internal <= ID_rs2_data;
     else rs2_data_out_internal <= rs2_data_out_internal;
   assign ID_EX_rs2_data = rs2_data_out_internal;

   reg [4:0]                   rd_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       rd_out_internal <= 0;
     else if (ID_kick_up) rd_out_internal <= ID_rd;
     else rd_out_internal <= rd_out_internal;
   assign ID_EX_rd = rd_out_internal;

endmodule
