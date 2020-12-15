module MEM(
           input             EX_MEM_memtoreg,
           input             EX_MEM_memread,
           input             EX_MEM_memwrite,
           input             EX_MEM_regwrite,
           input [31:0]      EX_MEM_pc,
           input             EX_MEM_unconditional_jmp,
           // input             EX_MEM_zero,
           input [4:0]       EX_MEM_rd,
           // input [31:0]      EX_MEM_rs1_data,
           input [31:0]      EX_MEM_rs2_data,
           input [31:0]      EX_MEM_ALU_result,
           // input [31:0]      data_mem_read_data,
           output reg [31:0] data_mem_write_data,
           output reg [31:0] data_mem_write_addr,
           output reg [31:0] data_mem_read_addr,
           output reg        data_mem_read_enable,
           output reg        data_mem_write_enable,
           output reg        MEM_regwrite,
           // output reg        MEM_zero,
           output reg [4:0]  MEM_rd,
           output reg        MEM_memtoreg,
           output reg [31:0] MEM_ALU_result,
           output reg [31:0] MEM_pc,
           output reg        MEM_unconditional_jmp
           );

   always @ *
     data_mem_write_addr = EX_MEM_ALU_result;

   always @ *
     data_mem_read_addr = EX_MEM_ALU_result;

   always @ *
     data_mem_write_data = EX_MEM_rs2_data;

   always @ *
     if (EX_MEM_memwrite || EX_MEM_memread)
       data_mem_read_enable = 1;
     else
       data_mem_read_enable = 0;

   always @ *
     if (EX_MEM_memwrite)
       data_mem_write_enable = 1;
     else
       data_mem_write_enable = 0;

   // always @ *
   //   MEM_zero = EX_MEM_zero;

   always @ *
     MEM_memtoreg = EX_MEM_memtoreg;

   always @ *
     MEM_regwrite = EX_MEM_regwrite;

   always @ *
     MEM_rd = EX_MEM_rd;

   always @ *
     MEM_ALU_result = EX_MEM_ALU_result;

   always @ *
     MEM_unconditional_jmp = EX_MEM_unconditional_jmp;

   always @ *
     MEM_pc = EX_MEM_pc;

endmodule // MEM
