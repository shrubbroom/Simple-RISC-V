module WB(
          input wire [31:0] EX_result,
          input wire [31:0] data_mem_read_data,
          input wire        ID_regwrite,
          input wire        ID_memtoreg,
          input wire        ID_unconditional_jmp,
          input wire [31:0] inst_mem_read_addr,
          output wire       reg_write_enable,
          output reg [31:0] reg_write_data
          );
   always @ *
     if (ID_memtoreg)
       reg_write_data = data_mem_read_data;
     else
        if (ID_unconditional_jmp)
          reg_write_data = inst_mem_read_addr + 4;
        else
          reg_write_data = EX_result;
   assign reg_write_data = ID_memtoreg?data_mem_read_data:EX_result;
   assign reg_write_enable = ID_regwrite;
endmodule
