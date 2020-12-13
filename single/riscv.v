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
   //  instance your module below

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 ALU_kick_up;            // From EX of EX.v
   wire [31:0]          ALU_result;             // From EX of EX.v
   wire                 ALU_zero;               // From EX of EX.v
   wire [3:0]           Controller_aluop;       // From ID of ID.v
   wire                 Controller_alusrc;      // From ID of ID.v
   wire                 Controller_branch;      // From ID of ID.v
   wire                 Controller_kick_up;     // From ID of ID.v
   wire                 Controller_memread;     // From ID of ID.v
   wire                 Controller_memtoreg;    // From ID of ID.v
   wire                 Controller_memwrite;    // From ID of ID.v
   wire                 Controller_regwrite;    // From ID of ID.v
   wire [31:0]          Data_mem_read_addr;     // From MEM of MEM.v
   wire                 Data_mem_read_enable;   // From MEM of MEM.v
   wire [31:0]          Data_mem_write_addr;    // From MEM of MEM.v
   wire [31:0]          Data_mem_write_data;    // From MEM of MEM.v
   wire                 Data_mem_write_enable;  // From MEM of MEM.v
   wire                 IF_kick_up;             // From IF of IF.v
   wire                 MEM_kick_up;            // From MEM of MEM.v
   wire                 WB_kick_up;             // From WB of WB.v
   wire [31:0]          imme;                   // From ID of ID.v
   wire [31:0]          inst_mem_read_addr;     // From IF of IF.v
   wire                 inst_mem_read_enable;   // From IF of IF.v
   wire [31:0]          reg_read_data_1;        // From RF of RF.v
   wire [31:0]          reg_read_data_2;        // From RF of RF.v
   wire [31:0]          reg_write_data;         // From WB of WB.v
   wire                 reg_write_enable;       // From WB of WB.v
   // End of automatics
   wire [31:0]                  Data_mem_read_data = data_i;
   assign data_ce_o = Data_mem_read_enable;
   assign data_we_o = Data_mem_write_enable;
   assign data_addr_o = (Data_mem_read_enable)?Data_mem_write_addr:Data_mem_read_addr;
   assign data_o = Data_mem_write_data;
   // input wire [31:0]  data_i, // load data from data_mem
   // output wire        data_we_o,
   // output wire        data_ce_o,
   // output wire [31:0] data_addr_o,
   // output wire [31:0] data_o       // store data to  data_mem


   wire                         reset = rst;
   wire [31:0]                  instruction = inst_i;

   assign inst_addr_o = inst_mem_read_addr;
   assign inst_ce_o = inst_mem_read_enable;
   wire                         ID_kick_up = Controller_kick_up;
   wire [4:0]                   reg_read_addr_1 = instruction[19:15];
   wire [4:0]                   reg_read_addr_2 = instruction[24:20];
   wire [4:0]                   reg_write_addr = instruction[11:7];

   IF IF(/*AUTOINST*/
         // Outputs
         .IF_kick_up                    (IF_kick_up),
         .inst_mem_read_enable          (inst_mem_read_enable),
         .inst_mem_read_addr            (inst_mem_read_addr[31:0]),
         // Inputs
         .clk                           (clk),
         .reset                         (reset),
         .Controller_branch             (Controller_branch),
         .ALU_zero                      (ALU_zero),
         .imme                          (imme[31:0]),
         .WB_kick_up                    (WB_kick_up));
   ID ID(/*AUTOINST*/
         // Outputs
         .Controller_branch             (Controller_branch),
         .Controller_memread            (Controller_memread),
         .Controller_memtoreg           (Controller_memtoreg),
         .Controller_aluop              (Controller_aluop[3:0]),
         .Controller_memwrite           (Controller_memwrite),
         .Controller_alusrc             (Controller_alusrc),
         .Controller_regwrite           (Controller_regwrite),
         .imme                          (imme[31:0]),
         .Controller_kick_up            (Controller_kick_up),
         // Inputs
         .clk                           (clk),
         .reset                         (reset),
         .instruction                   (instruction[31:0]),
         .IF_kick_up                    (IF_kick_up));
   EX EX(/*AUTOINST*/
         // Outputs
         .ALU_result                    (ALU_result[31:0]),
         .ALU_zero                      (ALU_zero),
         .ALU_kick_up                   (ALU_kick_up),
         // Inputs
         .clk                           (clk),
         .reset                         (reset),
         .reg_read_data_1               (reg_read_data_1[31:0]),
         .reg_read_data_2               (reg_read_data_2[31:0]),
         .imme                          (imme[31:0]),
         .Controller_alusrc             (Controller_alusrc),
         .Controller_aluop              (Controller_aluop[3:0]),
         .Controller_memwrite           (Controller_memwrite),
         .ID_kick_up                    (ID_kick_up));
   WB WB(/*AUTOINST*/
         // Outputs
         .WB_kick_up                    (WB_kick_up),
         .reg_write_enable              (reg_write_enable),
         .reg_write_data                (reg_write_data[31:0]),
         // Inputs
         .clk                           (clk),
         .reset                         (reset),
         .ALU_result                    (ALU_result[31:0]),
         .Data_mem_read_data            (Data_mem_read_data[31:0]),
         .Controller_regwrite           (Controller_regwrite),
         .Controller_memtoreg           (Controller_memtoreg),
         .MEM_kick_up                   (MEM_kick_up));
   MEM MEM(/*AUTOINST*/
           // Outputs
           .Data_mem_write_enable       (Data_mem_write_enable),
           .Data_mem_write_addr         (Data_mem_write_addr[31:0]),
           .Data_mem_write_data         (Data_mem_write_data[31:0]),
           .Data_mem_read_enable        (Data_mem_read_enable),
           .Data_mem_read_addr          (Data_mem_read_addr[31:0]),
           .MEM_kick_up                 (MEM_kick_up),
           // Inputs
           .clk                         (clk),
           .reset                       (reset),
           .ALU_result                  (ALU_result[31:0]),
           .ALU_kick_up                 (ALU_kick_up),
           .reg_read_data_2             (reg_read_data_2[31:0]),
           .Controller_memwrite         (Controller_memwrite),
           .Controller_memread          (Controller_memread));
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
