module WB(
          input             MEM_WB_regwrite,
          input [4:0]       MEM_WB_rd,
          input [31:0]      MEM_WB_result,
          output reg [4:0]  reg_write_addr,
          output reg [31:0] reg_write_data,
          output reg        reg_write_enable
          );
   always @ *
     reg_write_enable = MEM_WB_regwrite;

   always @ *
     reg_write_data = MEM_WB_result;

   always @ *
     reg_write_addr = MEM_WB_rd;
endmodule
