module IF_branch_prediction_BHT #(
                                  parameter PREDICTION_TAKE = 1'b1,
                                  // parameter PREDICTION_TAKE_TAKE = 2'b11,
                                  parameter PREDICTION_NTAKE = 1'b0
                                  // parameter PREDICTION_NTAKE_NTAKE = 2'b10
                                  ) (
                                     input        clk,
                                     input        reset,
                                     input        pc_jmp_feedback,
                                     input        pc_jmp_take,
                                     // input        EX_branch,
                                     // input        EX_unconditional_jmp,
                                     // input        EX_zero,
                                     input [31:0] pc_stash_base,
                                     input [31:0] pc_jmp,
                                     output wire  pc_prediction_take
                                     );
   reg                                            pc_prediction_table_take [1023:0];
   assign pc_prediction_take = pc_prediction_table_take[pc_jmp];
   integer                                        i;

   always @ (posedge clk or posedge reset)
     if (reset)
       for (i = 0; i <= 1023; i = i + 1) begin
          pc_prediction_table_take[i] <= PREDICTION_TAKE;
       end
     else
       if (pc_jmp_feedback) begin
          case (pc_prediction_table_take[pc_stash_base])
            PREDICTION_TAKE : begin
               if (pc_jmp_take) pc_prediction_table_take[pc_stash_base] <= PREDICTION_TAKE;
               else pc_prediction_table_take[pc_stash_base] <= PREDICTION_NTAKE;
            end
            PREDICTION_NTAKE : begin
               if (pc_jmp_take) pc_prediction_table_take[pc_stash_base] <= PREDICTION_TAKE;
               else pc_prediction_table_take[pc_stash_base] <= PREDICTION_NTAKE;
            end
          endcase // case (pc_stash_base ^^ pc_prediction_GHR)
       end
       else begin end

endmodule
