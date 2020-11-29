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

   always @ (posedge clk or posedge reset)
     register_file[0] <= 0;

   assign reg_read_data_1 = register_file[reg_read_addr_1];
   assign reg_read_data_2 = register_file[reg_read_addr_2];
endmodule
