module RF(
          input wire clk,
          input wire [4:0]   reg_addr_read_1,
          input wire [4:0]   reg_addr_read_2,
          input wire [4:0]   reg_addr_write,
          input wire [31:0]  reg_data_write,
          input wire         reg_enable_write,
          output wire [31:0] reg_data_read_1,
          output wire [31:0] reg_data_read_2
          );
   reg [31:0]                register_file [31:0];
   always @ (posedge clk)
      if (reg_enable_write)
        register_file[reg_addr_write] <= reg_data_write;
      else begin end

   assign reg_data_read_1 = register_file[reg_addr_read_1];
   assign reg_data_read_2 = register_file[reg_addr_read_2];
endmodule
