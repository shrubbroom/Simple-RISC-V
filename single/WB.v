module WB(
          input wire         clk,
          input wire         reset,
          input wire [31:0]  ALU_result,
          input wire [31:0]  mem_read_data,
          input wire         Controller_regwrite,
          input wire         Controller_memtoreg,
          input wire         MEM_kick_up,
          output wire        WB_kick_up,
          output wire        reg_write_enable,
          output wire [31:0] reg_write_data
          );
   assign reg_write_data = Controller_memtoreg?mem_read_data:ALU_result;

   reg                       reg_write_enable_internal;
   always @ (posedge clk or negedge reset)
     if (~reset)
       reg_write_enable_internal <= 0;
     else begin
        if (MEM_kick_up) reg_write_enable_internal <= 1;
        else reg_write_enable_internal <= 0;
     end
   assign reg_write_enable = (reg_write_enable_internal)&&Controller_regwrite;

   reg WB_kick_up_internal;
   always @ (posedge clk or negedge reset)
     if (~reset)
       WB_kick_up_internal <= 0;
     else
       if (reg_write_enable_internal) WB_kick_up_internal <= 1;
       else WB_kick_up_internal <= 0;
   assign WB_kick_up = WB_kick_up_internal;

endmodule
