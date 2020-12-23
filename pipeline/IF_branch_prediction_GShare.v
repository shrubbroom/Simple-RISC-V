module IF_branch_prediction_GShare#(
                                    parameter PREDICTION_TAKE = 2'b1,
                                    parameter PREDICTION_TAKE_TAKE = 2'b11,
                                    parameter PREDICTION_NTAKE = 2'b0,
                                    parameter PREDICTION_NTAKE_NTAKE = 2'b10
                                    ) (
                                       input        clk,
                                       input        reset,
                                       input        pc_jmp_feedback,
                                       input        pc_jmp_take,
                                       input [31:0] pc_stash_base,
                                       input [31:0] pc_jmp,
                                       output wire  pc_prediction_take
                                       );
   reg [9:0]                                        pc_prediction_GHR;
   reg [1:0]                                        pc_prediction_PHT [1023:0];
   integer                                          i;
   assign pc_prediction_take = pc_prediction_PHT[pc_jmp ^ pc_prediction_GHR][0];
   always @ (posedge clk or posedge reset)
      if (reset) begin
         pc_prediction_GHR <= 10'b0;
         for(i = 0; i <= 1023; i = i + 1) begin
            pc_prediction_PHT[i] <= PREDICTION_TAKE_TAKE;
         end
      end else
        begin
           if (pc_jmp_feedback) begin
                case (pc_prediction_PHT[pc_stash_base ^ pc_prediction_GHR])
                  PREDICTION_TAKE : begin
                     if (pc_jmp_take) pc_prediction_PHT[pc_stash_base ^ pc_prediction_GHR] <= PREDICTION_TAKE_TAKE;
                     else pc_prediction_PHT[pc_stash_base ^ pc_prediction_GHR] <= PREDICTION_NTAKE;
                  end
                  PREDICTION_TAKE_TAKE : begin
                     if (pc_jmp_take) pc_prediction_PHT[pc_stash_base ^ pc_prediction_GHR] <= PREDICTION_TAKE_TAKE;
                     else pc_prediction_PHT[pc_stash_base ^ pc_prediction_GHR] <= PREDICTION_TAKE;
                  end
                  PREDICTION_NTAKE : begin
                     if (pc_jmp_take) pc_prediction_PHT[pc_stash_base ^ pc_prediction_GHR] <= PREDICTION_TAKE;
                     else pc_prediction_PHT[pc_stash_base ^ pc_prediction_GHR] <= PREDICTION_NTAKE_NTAKE;
                  end
                  PREDICTION_NTAKE_NTAKE : begin
                     if (pc_jmp_take) pc_prediction_PHT[pc_stash_base ^ pc_prediction_GHR] <= PREDICTION_NTAKE;
                     else pc_prediction_PHT[pc_stash_base ^ pc_prediction_GHR] <= PREDICTION_NTAKE_NTAKE;
                  end
                endcase // case (pc_stash_base ^^ pc_prediction_GHR)
           end else begin end
        end
endmodule // IF_branch_prediction_GShare
