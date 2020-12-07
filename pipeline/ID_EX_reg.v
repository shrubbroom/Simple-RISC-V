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
                 input [31:0]  imme,
                 input [4:0]   rs1,
                 input [31:0]  rs1_data,
                 input [4:0]   rs2,
                 input [31:0]  rs2_data,
                 input [4:0]   rd,
                 output        ID_branch_out,
                 output        ID_memread_out,
                 output        ID_memtoreg_out,
                 output        ID_aluop_out,
                 output        ID_memwrite_out,
                 output        ID_alusrc_out,
                 output        ID_regwrite_out,
                 output [31:0] imme_out,
                 output [4:0]  rs1_out,
                 output [31:0] rs1_data_out,
                 output [4:0]  rs2_out,
                 output [31:0] rs2_data_out,
                 output [4:0]  rd_out
                 );
   reg                         ID_branch_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_branch_out_internal <= 0;
     else if (ID_kick_up) ID_branch_out_internal <= ID_branch;
     else ID_branch_out_internal <= ID_branch_out_internal;
   assign ID_branch_out = ID_branch_out_internal;

   reg                         ID_memread_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_memread_out_internal <= 0;
     else if (ID_kick_up) ID_memread_out_internal <= ID_memread;
     else ID_memread_out_internal <= ID_memread_out_internal;
   assign ID_memread_out = ID_memread_out_internal;

   reg                         ID_memtoreg_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_memtoreg_out_internal <= 0;
     else if (ID_kick_up) ID_memtoreg_out_internal <= ID_memtoreg;
     else ID_memtoreg_out_internal <= ID_memtoreg_out_internal;
   assign ID_memtoreg_out = ID_memtoreg_out_internal;

   reg                         ID_aluop_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_aluop_out_internal <= 0;
     else if (ID_kick_up) ID_aluop_out_internal <= ID_aluop;
     else ID_aluop_out_internal <= ID_aluop_out_internal;
   assign ID_aluop_out = ID_aluop_out_internal;

   reg                         ID_memwrite_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_memwrite_out_internal <= 0;
     else if (ID_kick_up) ID_memwrite_out_internal <= ID_memwrite;
     else ID_memwrite_out_internal <= ID_memwrite_out_internal;
   assign ID_memwrite_out = ID_memwrite_out_internal;

   reg                         ID_alusrc_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_alusrc_out_internal <= 0;
     else if (ID_kick_up) ID_alusrc_out_internal <= ID_alusrc;
     else ID_alusrc_out_internal <= ID_alusrc_out_internal;
   assign ID_alusrc_out = ID_alusrc_out_internal;

   reg                         ID_regwrite_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       ID_regwrite_out_internal <= 0;
     else if (ID_kick_up) ID_regwrite_out_internal <= ID_regwrite;
     else ID_regwrite_out_internal <= ID_regwrite_out_internal;
   assign ID_regwrite_out = ID_regwrite_out_internal;

   reg [31:0]                  imme_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       imme_out_internal <= 0;
     else if (ID_kick_up) imme_out_internal <= imme;
     else imme_out_internal <= imme_out_internal;
   assign imme_out = imme_out_internal;

   reg [4:0]                   rs1_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       rs1_out_internal <= 0;
     else if (ID_kick_up) rs1_out_internal <= rs1;
     else rs1_out_internal <= rs1_out_internal;
   assign rs1_out = rs1_out_internal;

   reg [31:0]                  rs1_data_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       rs1_data_out_internal <= 0;
     else if (ID_kick_up) rs1_data_out_internal <= rs1_data;
     else rs1_data_out_internal <= rs1_data_out_internal;
   assign rs1_data_out = rs1_data_out_internal;

   reg [4:0]                   rs2_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       rs2_out_internal <= 0;
     else if (ID_kick_up) rs2_out_internal <= rs2;
     else rs2_out_internal <= rs2_out_internal;
   assign rs2_out = rs2_out_internal;

   reg [31:0]                  rs2_data_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       rs2_data_out_internal <= 0;
     else if (ID_kick_up) rs2_data_out_internal <= rs2_data;
     else rs2_data_out_internal <= rs2_data_out_internal;
   assign rs2_data_out = rs2_data_out_internal;

   reg [4:0]                   rd_out_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       rd_out_internal <= 0;
     else if (ID_kick_up) rd_out_internal <= rd;
     else rd_out_internal <= rd_out_internal;
   assign rd_out = rd_out_internal;

endmodule
