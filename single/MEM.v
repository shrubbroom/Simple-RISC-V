module MEM(
           input wire [31:0]  EX_result,
           input wire [31:0]  reg_read_data_2,
           input wire         ID_memwrite,
           input wire         ID_memread,
           output reg         data_mem_write_enable,
           output wire [31:0] data_mem_write_addr,
           output wire [31:0] data_mem_write_data,
           output wire        data_mem_read_enable,
           output wire [31:0] data_mem_read_addr
           );

   always @ *
     if (ID_memwrite) data_mem_write_enable = 1;
     else data_mem_write_enable = 0;

   assign data_mem_write_addr = EX_result;
   assign data_mem_write_data = reg_read_data_2;
   assign data_mem_read_enable = ID_memread | data_mem_write_enable;
   assign data_mem_read_addr = EX_result;
endmodule
