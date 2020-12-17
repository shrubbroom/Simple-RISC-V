`include "IF.v"
`include "ID.v"
`include "EX.v"
`include "WB.v"
`include "MEM.v"
`include "RF.v"
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
   wire [31:0]          EX_result;              // From EX of EX.v
   wire                 EX_zero;                // From EX of EX.v
   wire [3:0]           ID_aluop;               // From ID of ID.v
   wire                 ID_alusrc;              // From ID of ID.v
   wire                 ID_branch;              // From ID of ID.v
   wire [31:0]          ID_imme;                // From ID of ID.v
   wire                 ID_memread;             // From ID of ID.v
   wire                 ID_memtoreg;            // From ID of ID.v
   wire                 ID_memwrite;            // From ID of ID.v
   wire                 ID_regwrite;            // From ID of ID.v
   wire                 ID_unconditional_jmp;   // From ID of ID.v
   wire [31:0]          data_mem_read_addr;     // From MEM of MEM.v
   wire                 data_mem_read_enable;   // From MEM of MEM.v
   wire [31:0]          data_mem_write_addr;    // From MEM of MEM.v
   wire [31:0]          data_mem_write_data;    // From MEM of MEM.v
   wire                 data_mem_write_enable;  // From MEM of MEM.v
   wire [31:0]          inst_mem_read_addr;     // From IF of IF.v
   wire                 inst_mem_read_enable;   // From IF of IF.v
   wire [31:0]          reg_read_data_1;        // From RF of RF.v
   wire [31:0]          reg_read_data_2;        // From RF of RF.v
   wire [31:0]          reg_write_data;         // From WB of WB.v
   wire                 reg_write_enable;       // From WB of WB.v
   // End of automatics
   wire [31:0]                  data_mem_read_data = data_i;
   assign data_ce_o = data_mem_read_enable;
   assign data_we_o = data_mem_write_enable;
   assign data_addr_o = (data_mem_read_enable)?data_mem_write_addr:data_mem_read_addr;
   assign data_o = data_mem_write_data;
   // input wire [31:0]  data_i, // load data from data_mem
   // output wire        data_we_o,
   // output wire        data_ce_o,
   // output wire [31:0] data_addr_o,
   // output wire [31:0] data_o       // store data to  data_mem


   wire                         reset = rst;
   wire [31:0]                  instruction = inst_i;

   assign inst_addr_o = inst_mem_read_addr;
   assign inst_ce_o = inst_mem_read_enable;
   wire [4:0]                   reg_read_addr_1 = instruction[19:15];
   wire [4:0]                   reg_read_addr_2 = instruction[24:20];
   wire [4:0]                   reg_write_addr = instruction[11:7];

   IF IF(/*AUTOINST*/
         // Outputs
         .inst_mem_read_enable          (inst_mem_read_enable),
         .inst_mem_read_addr            (inst_mem_read_addr[31:0]),
         // Inputs
         .clk                           (clk),
         .reset                         (reset),
         .ID_branch                     (ID_branch),
         .EX_zero                       (EX_zero),
         .ID_imme                       (ID_imme[31:0]));
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
         .ID_unconditional_jmp          (ID_unconditional_jmp),
         // Inputs
         .instruction                   (instruction[31:0]));
   EX EX(/*AUTOINST*/
         // Outputs
         .EX_result                     (EX_result[31:0]),
         .EX_zero                       (EX_zero),
         // Inputs
         .reg_read_data_1               (reg_read_data_1[31:0]),
         .reg_read_data_2               (reg_read_data_2[31:0]),
         .ID_imme                       (ID_imme[31:0]),
         .ID_alusrc                     (ID_alusrc),
         .ID_aluop                      (ID_aluop[3:0]),
         .ID_memwrite                   (ID_memwrite));
   WB WB(/*AUTOINST*/
         // Outputs
         .reg_write_enable              (reg_write_enable),
         .reg_write_data                (reg_write_data[31:0]),
         // Inputs
         .EX_result                     (EX_result[31:0]),
         .data_mem_read_data            (data_mem_read_data[31:0]),
         .ID_regwrite                   (ID_regwrite),
         .ID_memtoreg                   (ID_memtoreg),
         .ID_unconditional_jmp          (ID_unconditional_jmp),
         .inst_mem_read_addr            (inst_mem_read_addr[31:0]));
   MEM MEM(/*AUTOINST*/
           // Outputs
           .data_mem_write_enable       (data_mem_write_enable),
           .data_mem_write_addr         (data_mem_write_addr[31:0]),
           .data_mem_write_data         (data_mem_write_data[31:0]),
           .data_mem_read_enable        (data_mem_read_enable),
           .data_mem_read_addr          (data_mem_read_addr[31:0]),
           // Inputs
           .EX_result                   (EX_result[31:0]),
           .reg_read_data_2             (reg_read_data_2[31:0]),
           .ID_memwrite                 (ID_memwrite),
           .ID_memread                  (ID_memread));
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
