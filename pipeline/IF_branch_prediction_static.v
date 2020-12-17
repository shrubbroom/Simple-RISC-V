module IF_branch_prediction_static(
                                 input        clk,
                                 input        reset,
                                 input        pc_jmp_feedback,
                                 input        pc_jmp_take,
                                 // input        EX_branch,
                                 // input        EX_unconditional_jmp,
                                 // input        EX_zero,
                                 input [31:0] pc_stash_base,
                                 input [31:0] pc_jmp,
                                 output reg   pc_prediction_take
                                   );
   always @ *
     pc_prediction_take = 1;
endmodule
