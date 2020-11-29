`timescale 1ns/1ns
module IF_tb();
   reg clk;
   reg reset;
   wire Controller_branch;
   wire Controller_branch_kick_up;
   wire ALU_Zero;
   wire              ALU_Zero_kick_up;
   wire [31:0]       imme;
   wire              imme_kick_up;
   wire              instruction_kick_up;
   wire              inst_mem_read_enable;
   wire [31:0]       inst_mem_read_addr;

   IF IF(/*AUTOINST*/
         // Outputs
         .instruction_kick_up           (instruction_kick_up),
         .inst_mem_read_enable          (inst_mem_read_enable),
         .inst_mem_read_addr            (inst_mem_read_addr[31:0]),
         // Inputs
         .clk                           (clk),
         .reset                         (reset),
         .Controller_branch             (Controller_branch),
         .Controller_branch_kick_up     (Controller_branch_kick_up),
         .ALU_Zero                      (ALU_Zero),
         .ALU_Zero_kick_up              (ALU_Zero_kick_up),
         .imme                          (imme[31:0]),
         .imme_kick_up                  (imme_kick_up));
   assign  Controller_branch = 0;
   assign     ALU_Zero = 0;
   assign     Controller_branch_kick_up = 0;
   assign     ALU_Zero_kick_up = 0;
   assign     imme = 0;
   assign     imme_kick_up = 0;


   always #5 clk = ~clk;
   initial begin
      clk = 0;
      reset = 0;
      # 10 reset = 1;
   end

endmodule
