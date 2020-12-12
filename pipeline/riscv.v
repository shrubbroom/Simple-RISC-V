module riscv(

             input wire         clk,
             input wire         rst, // high is reset

             // inst_mem
             input wire [31:0]  inst_i,
             output wire [31:0] inst_addr_o,
             output wire        inst_ce_o,

             // data_mem
             input wire [31:0]  data_i, // load data from data_mem
             output wire        data_we_o,
             output wire        data_ce_o,
             output wire [31:0] data_addr_o,
             output wire [31:0] data_o       // store data to  data_mem

             );

   //  instance your module  below
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [31:0]          EX_ALU_result;          // From EX of EX.v
   wire [31:0]          EX_MEM_ALU_result;      // From EX_MEM_reg of EX_MEM_reg.v
   wire                 EX_MEM_branch;          // From EX_MEM_reg of EX_MEM_reg.v
   wire                 EX_MEM_flush;           // From EX_MEM_reg of EX_MEM_reg.v
   wire                 EX_MEM_memread;         // From EX_MEM_reg of EX_MEM_reg.v
   wire                 EX_MEM_memtoreg;        // From EX_MEM_reg of EX_MEM_reg.v
   wire                 EX_MEM_memwrite;        // From EX_MEM_reg of EX_MEM_reg.v
   wire [4:0]           EX_MEM_rd;              // From EX_MEM_reg of EX_MEM_reg.v
   wire                 EX_MEM_regwrite;        // From EX_MEM_reg of EX_MEM_reg.v
   wire [31:0]          EX_MEM_rs2_data;        // From EX_MEM_reg of EX_MEM_reg.v
   wire                 EX_MEM_stall;           // From EX_MEM_reg of EX_MEM_reg.v
   wire                 EX_MEM_zero;            // From EX_MEM_reg of EX_MEM_reg.v
   wire                 EX_branch;              // From EX of EX.v
   wire                 EX_memread;             // From EX of EX.v
   wire                 EX_memtoreg;            // From EX of EX.v
   wire                 EX_memwrite;            // From EX of EX.v
   wire [4:0]           EX_rd;                  // From EX of EX.v
   wire                 EX_regwrite;            // From EX of EX.v
   wire [31:0]          EX_rs1_data;            // From EX of EX.v
   wire [31:0]          EX_rs2_data;            // From EX of EX.v
   wire                 EX_stall;               // From EX of EX.v
   wire                 EX_take;                // From EX of EX.v
   wire                 EX_zero;                // From EX of EX.v
   wire [3:0]           ID_EX_aluop;            // From ID_EX_reg of ID_EX_reg.v
   wire                 ID_EX_alusrc;           // From ID_EX_reg of ID_EX_reg.v
   wire                 ID_EX_branch;           // From ID_EX_reg of ID_EX_reg.v
   wire [31:0]          ID_EX_imme;             // From ID_EX_reg of ID_EX_reg.v
   wire                 ID_EX_memread;          // From ID_EX_reg of ID_EX_reg.v
   wire                 ID_EX_memtoreg;         // From ID_EX_reg of ID_EX_reg.v
   wire                 ID_EX_memwrite;         // From ID_EX_reg of ID_EX_reg.v
   wire [4:0]           ID_EX_rd;               // From ID_EX_reg of ID_EX_reg.v
   wire                 ID_EX_regwrite;         // From ID_EX_reg of ID_EX_reg.v
   wire [4:0]           ID_EX_rs1;              // From ID_EX_reg of ID_EX_reg.v
   wire [31:0]          ID_EX_rs1_data;         // From ID_EX_reg of ID_EX_reg.v
   wire [4:0]           ID_EX_rs2;              // From ID_EX_reg of ID_EX_reg.v
   wire [31:0]          ID_EX_rs2_data;         // From ID_EX_reg of ID_EX_reg.v
   wire                 ID_EX_take;             // From ID_EX_reg of ID_EX_reg.v
   wire [3:0]           ID_aluop;               // From ID of ID.v
   wire                 ID_alusrc;              // From ID of ID.v
   wire                 ID_branch;              // From ID of ID.v
   wire [31:0]          ID_imme;                // From ID of ID.v
   wire                 ID_memread;             // From ID of ID.v
   wire                 ID_memtoreg;            // From ID of ID.v
   wire                 ID_memwrite;            // From ID of ID.v
   wire [4:0]           ID_rd;                  // From ID of ID.v
   wire                 ID_regwrite;            // From ID of ID.v
   wire [4:0]           ID_rs1;                 // From ID of ID.v
   wire [4:0]           ID_rs2;                 // From ID of ID.v
   wire                 ID_take;                // From ID of ID.v
   wire [31:0]          IF_ID_instruction;      // From IF_ID_reg of IF_ID_reg.v
   wire                 IF_ID_take;             // From IF_ID_reg of IF_ID_reg.v
   wire                 IF_take;                // From IF of IF.v
   wire [31:0]          MEM_ALU_result;         // From MEM of MEM.v
   wire [4:0]           MEM_WB_rd;              // From MEM_WB_reg of MEM_WB_reg.v
   wire                 MEM_WB_regwrite;        // From MEM_WB_reg of MEM_WB_reg.v
   wire [31:0]          MEM_WB_result;          // From MEM_WB_reg of MEM_WB_reg.v
   wire                 MEM_memtoreg;           // From MEM of MEM.v
   wire [4:0]           MEM_rd;                 // From MEM of MEM.v
   wire                 MEM_regwrite;           // From MEM of MEM.v
   wire                 data_mem_read_enable;   // From MEM of MEM.v
   wire [31:0]          data_mem_write_data;    // From MEM of MEM.v
   wire                 data_mem_write_enable;  // From MEM of MEM.v
   wire [31:0]          inst_mem_read_addr;     // From IF of IF.v
   wire                 inst_mem_read_enable;   // From IF of IF.v
   wire [31:0]          reg_read_data_1;        // From RF of RF.v
   wire [31:0]          reg_read_data_2;        // From RF of RF.v
   wire [4:0]           reg_write_addr;         // From WB of WB.v
   wire [31:0]          reg_write_data;         // From WB of WB.v
   wire                 reg_write_enable;       // From WB of WB.v
   // End of automatics

   // Implicit port definition and conversion
   wire                         reset = rst;
   wire [31:0]                  inst_mem_read_data = inst_i;
   assign inst_ce_o = inst_mem_read_enable;
   assign inst_addr_o = inst_mem_read_addr;
   wire [31:0]                  ID_rs1_data = reg_read_data_1;
   wire [31:0]                  ID_rs2_data = reg_read_data_2;
   wire [31:0]                  data_mem_read_data = data_i;
   wire [4:0]                   reg_read_addr_1;
   wire [4:0]                   reg_read_addr_2;
   assign reg_read_addr_1 = ID_rs1;
   assign reg_read_addr_2 = ID_rs2;
   wire [31:0]                  data_mem_read_addr;
   wire [31:0]                  data_mem_write_addr;
   assign data_addr_o = data_mem_read_enable?data_mem_read_addr:data_mem_write_addr;
   assign data_ce_o = data_mem_read_enable || data_mem_write_enable;
   assign data_we_o = data_mem_write_enable;
   assign data_o = data_mem_write_data;
   // End of ports

   IF IF(/*AUTOINST*/
         // Outputs
         .inst_mem_read_addr            (inst_mem_read_addr[31:0]),
         .inst_mem_read_enable          (inst_mem_read_enable),
         .IF_take                       (IF_take),
         // Inputs
         .clk                           (clk),
         .reset                         (reset),
         .ID_EX_branch                  (ID_EX_branch),
         .EX_MEM_zero                   (EX_MEM_zero),
         .EX_MEM_branch                 (EX_MEM_branch),
         .EX_MEM_flush                  (EX_MEM_flush),
         .EX_MEM_stall                  (EX_MEM_stall),
         .ID_EX_imme                    (ID_EX_imme[31:0]));
   IF_ID_reg IF_ID_reg(/*AUTOINST*/
                       // Outputs
                       .IF_ID_instruction(IF_ID_instruction[31:0]),
                       .IF_ID_take      (IF_ID_take),
                       // Inputs
                       .clk             (clk),
                       .reset           (reset),
                       .inst_mem_read_data(inst_mem_read_data[31:0]),
                       .EX_MEM_flush    (EX_MEM_flush),
                       .EX_MEM_stall    (EX_MEM_stall),
                       .IF_take         (IF_take),
                       .ID_EX_branch    (ID_EX_branch));
   ID ID(/*AUTOINST*/
         // Outputs
         .ID_branch                     (ID_branch),
         .ID_memread                    (ID_memread),
         .ID_memtoreg                   (ID_memtoreg),
         .ID_aluop                      (ID_aluop[3:0]),
         .ID_memwrite                   (ID_memwrite),
         .ID_alusrc                     (ID_alusrc),
         .ID_regwrite                   (ID_regwrite),
         .ID_imme                       (ID_imme[31:0]),
         .ID_rs1                        (ID_rs1[4:0]),
         .ID_rs2                        (ID_rs2[4:0]),
         .ID_rd                         (ID_rd[4:0]),
         .ID_take                       (ID_take),
         // Inputs
         .IF_ID_instruction             (IF_ID_instruction[31:0]),
         .IF_ID_take                    (IF_ID_take));
   ID_EX_reg ID_EX_reg(/*AUTOINST*/
                       // Outputs
                       .ID_EX_branch    (ID_EX_branch),
                       .ID_EX_memread   (ID_EX_memread),
                       .ID_EX_memtoreg  (ID_EX_memtoreg),
                       .ID_EX_aluop     (ID_EX_aluop[3:0]),
                       .ID_EX_memwrite  (ID_EX_memwrite),
                       .ID_EX_alusrc    (ID_EX_alusrc),
                       .ID_EX_regwrite  (ID_EX_regwrite),
                       .ID_EX_imme      (ID_EX_imme[31:0]),
                       .ID_EX_rs1       (ID_EX_rs1[4:0]),
                       .ID_EX_rs1_data  (ID_EX_rs1_data[31:0]),
                       .ID_EX_rs2       (ID_EX_rs2[4:0]),
                       .ID_EX_rs2_data  (ID_EX_rs2_data[31:0]),
                       .ID_EX_rd        (ID_EX_rd[4:0]),
                       .ID_EX_take      (ID_EX_take),
                       // Inputs
                       .clk             (clk),
                       .reset           (reset),
                       .EX_MEM_flush    (EX_MEM_flush),
                       .EX_MEM_stall    (EX_MEM_stall),
                       .ID_branch       (ID_branch),
                       .ID_memread      (ID_memread),
                       .ID_memtoreg     (ID_memtoreg),
                       .ID_aluop        (ID_aluop[3:0]),
                       .ID_memwrite     (ID_memwrite),
                       .ID_alusrc       (ID_alusrc),
                       .ID_regwrite     (ID_regwrite),
                       .ID_imme         (ID_imme[31:0]),
                       .ID_rs1          (ID_rs1[4:0]),
                       .ID_rs1_data     (ID_rs1_data[31:0]),
                       .ID_rs2          (ID_rs2[4:0]),
                       .ID_rs2_data     (ID_rs2_data[31:0]),
                       .ID_rd           (ID_rd[4:0]),
                       .ID_take         (ID_take));
   EX EX(/*AUTOINST*/
         // Outputs
         .EX_ALU_result                 (EX_ALU_result[31:0]),
         .EX_zero                       (EX_zero),
         .EX_rd                         (EX_rd[4:0]),
         .EX_stall                      (EX_stall),
         .EX_branch                     (EX_branch),
         .EX_memread                    (EX_memread),
         .EX_memtoreg                   (EX_memtoreg),
         .EX_memwrite                   (EX_memwrite),
         .EX_regwrite                   (EX_regwrite),
         .EX_rs1_data                   (EX_rs1_data[31:0]),
         .EX_rs2_data                   (EX_rs2_data[31:0]),
         .EX_take                       (EX_take),
         // Inputs
         .ID_EX_rs1                     (ID_EX_rs1[4:0]),
         .ID_EX_rs1_data                (ID_EX_rs1_data[31:0]),
         .ID_EX_rs2                     (ID_EX_rs2[4:0]),
         .ID_EX_rs2_data                (ID_EX_rs2_data[31:0]),
         .ID_EX_rd                      (ID_EX_rd[4:0]),
         .ID_EX_branch                  (ID_EX_branch),
         .ID_EX_alusrc                  (ID_EX_alusrc),
         .ID_EX_aluop                   (ID_EX_aluop[3:0]),
         .ID_EX_imme                    (ID_EX_imme[31:0]),
         .ID_EX_memread                 (ID_EX_memread),
         .ID_EX_memtoreg                (ID_EX_memtoreg),
         .ID_EX_memwrite                (ID_EX_memwrite),
         .ID_EX_regwrite                (ID_EX_regwrite),
         .ID_EX_take                    (ID_EX_take),
         .EX_MEM_ALU_result             (EX_MEM_ALU_result[31:0]),
         .EX_MEM_memtoreg               (EX_MEM_memtoreg),
         .EX_MEM_rd                     (EX_MEM_rd[4:0]),
         .EX_MEM_regwrite               (EX_MEM_regwrite),
         .MEM_WB_rd                     (MEM_WB_rd[4:0]),
         .MEM_WB_regwrite               (MEM_WB_regwrite),
         .MEM_WB_result                 (MEM_WB_result[31:0]));
   EX_MEM_reg EX_MEM_reg(/*AUTOINST*/
                         // Outputs
                         .EX_MEM_ALU_result     (EX_MEM_ALU_result[31:0]),
                         .EX_MEM_branch         (EX_MEM_branch),
                         .EX_MEM_flush          (EX_MEM_flush),
                         .EX_MEM_memtoreg       (EX_MEM_memtoreg),
                         .EX_MEM_rd             (EX_MEM_rd[4:0]),
                         .EX_MEM_regwrite       (EX_MEM_regwrite),
                         .EX_MEM_stall          (EX_MEM_stall),
                         .EX_MEM_zero           (EX_MEM_zero),
                         .EX_MEM_memread        (EX_MEM_memread),
                         .EX_MEM_memwrite       (EX_MEM_memwrite),
                         .EX_MEM_rs2_data       (EX_MEM_rs2_data[31:0]),
                         // Inputs
                         .clk                   (clk),
                         .reset                 (reset),
                         .EX_ALU_result         (EX_ALU_result[31:0]),
                         .EX_branch             (EX_branch),
                         .EX_zero               (EX_zero),
                         .EX_take               (EX_take),
                         .EX_memtoreg           (EX_memtoreg),
                         .EX_rd                 (EX_rd[4:0]),
                         .EX_regwrite           (EX_regwrite),
                         .EX_stall              (EX_stall),
                         .EX_memread            (EX_memread),
                         .EX_memwrite           (EX_memwrite),
                         .EX_rs1_data           (EX_rs1_data[31:0]),
                         .EX_rs2_data           (EX_rs2_data[31:0]));
   MEM MEM(/*AUTOINST*/
           // Outputs
           .data_mem_write_data         (data_mem_write_data[31:0]),
           .data_mem_write_addr         (data_mem_write_addr[31:0]),
           .data_mem_read_addr          (data_mem_read_addr[31:0]),
           .data_mem_read_enable        (data_mem_read_enable),
           .data_mem_write_enable       (data_mem_write_enable),
           .MEM_regwrite                (MEM_regwrite),
           .MEM_rd                      (MEM_rd[4:0]),
           .MEM_memtoreg                (MEM_memtoreg),
           .MEM_ALU_result              (MEM_ALU_result[31:0]),
           // Inputs
           .EX_MEM_memtoreg             (EX_MEM_memtoreg),
           .EX_MEM_memread              (EX_MEM_memread),
           .EX_MEM_memwrite             (EX_MEM_memwrite),
           .EX_MEM_regwrite             (EX_MEM_regwrite),
           .EX_MEM_rd                   (EX_MEM_rd[4:0]),
           .EX_MEM_rs2_data             (EX_MEM_rs2_data[31:0]),
           .EX_MEM_ALU_result           (EX_MEM_ALU_result[31:0]));
   MEM_WB_reg MEM_WB_reg(/*AUTOINST*/
                         // Outputs
                         .MEM_WB_rd             (MEM_WB_rd[4:0]),
                         .MEM_WB_regwrite       (MEM_WB_regwrite),
                         .MEM_WB_result         (MEM_WB_result[31:0]),
                         // Inputs
                         .clk                   (clk),
                         .reset                 (reset),
                         .data_mem_read_data    (data_mem_read_data[31:0]),
                         .MEM_regwrite          (MEM_regwrite),
                         .MEM_rd                (MEM_rd[4:0]),
                         .MEM_memtoreg          (MEM_memtoreg),
                         .MEM_ALU_result        (MEM_ALU_result[31:0]));
   WB WB(/*AUTOINST*/
         // Outputs
         .reg_write_addr                (reg_write_addr[4:0]),
         .reg_write_data                (reg_write_data[31:0]),
         .reg_write_enable              (reg_write_enable),
         // Inputs
         .MEM_WB_regwrite               (MEM_WB_regwrite),
         .MEM_WB_rd                     (MEM_WB_rd[4:0]),
         .MEM_WB_result                 (MEM_WB_result[31:0]));
   RF RF(/*AUTOINST*/
         // Outputs
         .reg_read_data_1               (reg_read_data_1[31:0]),
         .reg_read_data_2               (reg_read_data_2[31:0]),
         // Inputs
         .clk                           (clk),
         .reset                         (reset),
         .reg_read_addr_1               (reg_read_addr_1[4:0]),
         .reg_read_addr_2               (reg_read_addr_2[4:0]),
         .reg_write_addr                (reg_write_addr[4:0]),
         .reg_write_data                (reg_write_data[31:0]),
         .reg_write_enable              (reg_write_enable));



endmodule
