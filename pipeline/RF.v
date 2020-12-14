module RF(
          input wire         clk,
          input wire         reset,
          input wire [4:0]   reg_read_addr_1,
          input wire [4:0]   reg_read_addr_2,
          input wire [4:0]   reg_write_addr,
          input wire [31:0]  reg_write_data,
          input wire         reg_write_enable,
          output wire [31:0] reg_read_data_1,
          output wire [31:0] reg_read_data_2
          );
   reg [31:0]                register_file [31:0];
   always @ (posedge clk)
     if (reg_write_enable && reg_write_addr >= 1)
       register_file[reg_write_addr] <= reg_write_data;
     else begin end


   always @ *
     if (reg_read_addr_1 == 0)
       reg_read_data_1 = 0;
     else
       reg_read_data_1 = register_file[reg_read_addr_1];

   always @ *
     if (reg_read_addr_2 == 0)
       reg_read_data_2 = 0;
     else
       reg_read_data_2 = register_file[reg_read_addr_2];


endmodule
