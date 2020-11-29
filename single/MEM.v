module MEM(
           input wire         clk,
           input wire         reset,
           input wire [31:0]  ALU_result,
           input wire         ALU_kick_up,
           input wire [31:0]  reg_read_data_2,
           input wire         Controller_memwrite,
           input wire         Controller_memread,
           output wire        Data_mem_write_enable,
           output wire [31:0] Data_mem_write_addr,
           output wire [31:0] Data_mem_write_data,
           output wire        Data_mem_read_enable,
           output wire [31:0] Data_mem_read_addr,
           output wire        MEM_kick_up
           );
   reg                        Data_mem_write_enable_internal;
   always @ (posedge clk or posedge reset)
     if (reset)
       Data_mem_write_enable_internal <= 0;
     else
       if (ALU_kick_up && Controller_memwrite) Data_mem_write_enable_internal <= 1;
       else Data_mem_write_enable_internal <= 0;
   assign Data_mem_write_enable = Data_mem_write_enable_internal;
   assign Data_mem_write_addr = ALU_result;
   assign Data_mem_write_data = reg_read_data_2;

   assign Data_mem_read_enable = Controller_memread;
   assign Data_mem_read_addr = ALU_result;

   reg                        MEM_kick_up_internal;
   always @ (posedge clk or posedge reset)
      if (reset)
        MEM_kick_up_internal <= 0;
      else
        if (Data_mem_write_enable_internal || (~Data_mem_write_enable_internal && ALU_kick_up)) MEM_kick_up_internal <= 1;
        else MEM_kick_up_internal <= 0;
   assign MEM_kick_up = MEM_kick_up_internal;
endmodule
