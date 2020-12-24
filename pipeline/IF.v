`include "IF_branch_prediction_static.v"
`include "IF_branch_prediction_BHT.v"
`include "IF_branch_prediction_GShare.v"
module IF (
           input         clk,
           input         reset,
           input         ID_branch,
           input         ID_unconditional_jmp,
           input         EX_zero,
           input         EX_branch,
           input         EX_unconditional_jmp,
           input         EX_stall, // load-use stall
           input [31:0]  ID_imme,
           output [31:0] inst_mem_read_addr,
           output        inst_mem_read_enable,
           output        IF_take
           );
   reg [31:0]            pc;
   reg [31:0]            pc_stash_base;
   reg [31:0]            pc_stash_imme;
   reg                   pc_take;
   wire [31:0]           pc_jmp = pc - 4;

   wire                  pc_jmp_feedback = EX_branch && !EX_unconditional_jmp;
   wire                  pc_jmp_take = EX_zero;
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                  pc_prediction_take;     // From IF_branch_prediction_static of IF_branch_prediction_static.v
   // End of automatics
   IF_branch_prediction_GShare IF_branch_prediction(/*AUTOINST*/
                                                    // Outputs
                                                    .pc_prediction_take  (pc_prediction_take),
                                                    // Inputs
                                                    .clk                 (clk),
                                                    .reset               (reset),
                                                    .pc_jmp_feedback     (pc_jmp_feedback),
                                                    .pc_jmp_take         (pc_jmp_take),
                                                    .pc_stash_base       (pc_stash_base[31:0]),
                                                    .pc_jmp              (pc_jmp[31:0]));


   assign inst_mem_read_addr = pc;
   assign inst_mem_read_enable = 1;
   assign IF_take = pc_take;

   always @ (posedge clk or posedge reset)
     if (reset)
       pc <= 0;
     else
       if (EX_stall) begin
          pc <= pc; // fatal hazard, e.g. use after load
       end else
         if (pc_jmp_feedback) begin
            if (pc_take == pc_jmp_take) pc <= pc + 4;
            else
              if(pc_take) pc <= pc_stash_base + 4;
              else pc <= pc_stash_base + pc_stash_imme;
         end
         else
           if (ID_branch && !ID_unconditional_jmp) begin
              pc_stash_base <= pc_jmp;
              pc_stash_imme <= ID_imme;
              if (pc_prediction_take)
                begin
                   pc <= pc_jmp + ID_imme;
                   pc_take <= 1;
                end
              else
                begin
                   pc <= pc_jmp + 4;
                   pc_take <= 0;
                end
           end // if (ID_branch && !ID_unconditional_jmp)
           else begin
              pc_stash_base <= pc_stash_base;
              pc_stash_imme <= pc_stash_imme;
              if (ID_unconditional_jmp) begin
                 pc_take <= 1;
                 pc <= pc_jmp + ID_imme;
              end
              else begin
                 pc <= pc + 4;
              end
           end // else: !if(ID_branch)
endmodule
