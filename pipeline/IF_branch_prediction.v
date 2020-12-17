module IF_branch_prediction #(
                              parameter PREDICTION_TAKE = 2'b1,
                              parameter PREDICTION_TAKE_TAKE = 2'b11,
                              parameter PREDICTION_NTAKE = 2'b0,
                              parameter PREDICTION_NTAKE_NTAKE = 2'b10
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
                                 output reg   pc_prediction_take
                                 );
   reg [21:0]                                 pc_prediction_table_tag [1023:0];
   reg [1:0]                                  pc_prediction_table_take [1023:0];
   reg                                        pc_prediction_table_valid [1023:0];
   integer                                    i;

   always @ (posedge clk or posedge reset)
     if (reset)
       for (i = 0; i <= 1023; i = i + 1) begin
          pc_prediction_table_valid[i] = 0;
       end
     else
       if (pc_jmp_feedback)
         case ({pc_jmp_take,pc_prediction_table_valid[pc_stash_base[9:0]] == 0})
           2'b00 : begin
              pc_prediction_table_valid[pc_stash_base[9:0]] <= 1;
              pc_prediction_table_tag[pc_stash_base[9:0]] <= pc_stash_base[31:10];
              pc_prediction_table_take[pc_stash_base[9:0]] <= PREDICTION_NTAKE;
           end
           2'b10 : begin
              pc_prediction_table_valid[pc_stash_base[9:0]] <= 1;
              pc_prediction_table_tag[pc_stash_base[9:0]] <= pc_stash_base[31:10];
              pc_prediction_table_take[pc_stash_base[9:0]] <= PREDICTION_TAKE;
           end
           2'b01 : begin
              if (pc_prediction_table_tag[pc_jmp[9:0]] == pc_jmp[31:10])
                case (pc_prediction_table_take[pc_jmp[9:0]])
                  PREDICTION_TAKE : pc_prediction_table_take[pc_jmp[9:0]] <= PREDICTION_NTAKE;
                  PREDICTION_TAKE_TAKE : pc_prediction_table_take[pc_jmp[9:0]] <= PREDICTION_TAKE;
                  PREDICTION_NTAKE : pc_prediction_table_take[pc_jmp[9:0]] <= PREDICTION_NTAKE_NTAKE;
                  default : pc_prediction_table_take[pc_jmp[9:0]] <= PREDICTION_NTAKE_NTAKE;
                endcase
              else begin
                 pc_prediction_table_tag[pc_stash_base[9:0]] <= pc_stash_base[31:10];
                 pc_prediction_table_take[pc_stash_base[9:0]] <= PREDICTION_NTAKE;
              end
           end
           2'b11 : begin
              if (pc_prediction_table_tag[pc_jmp[9:0]] == pc_jmp[31:10])
                case (pc_prediction_table_take[pc_jmp[9:0]])
                  PREDICTION_TAKE : pc_prediction_table_take[pc_jmp[9:0]] <= PREDICTION_TAKE_TAKE;
                  PREDICTION_NTAKE_NTAKE : pc_prediction_table_take[pc_jmp[9:0]] <= PREDICTION_NTAKE;
                  PREDICTION_NTAKE : pc_prediction_table_take[pc_jmp[9:0]] <= PREDICTION_TAKE;
                  default : pc_prediction_table_take[pc_jmp[9:0]] <= PREDICTION_TAKE_TAKE;
                endcase
              else begin
                 pc_prediction_table_tag[pc_stash_base[9:0]] <= pc_stash_base[31:10];
                 pc_prediction_table_take[pc_stash_base[9:0]] <= PREDICTION_TAKE;
              end
           end
         endcase // case ({EX_zero,pc_prediction_table_valid[pc_stash_base[9:0]] == 0})
       else begin end

   always @ *
     if (pc_prediction_table_valid[pc_jmp[9:0]] &&
         pc_prediction_table_tag[pc_jmp[9:0]] == pc_jmp[31:10])
       begin
          if (pc_prediction_table_take[pc_jmp[9:0]][0] == 1)
            begin
               pc_prediction_take = 1;
            end
          else
            begin
               pc_prediction_take = 0;
            end
       end // if (pc_prediction_table_valid[pc_jmp[9:0]] &&...
     else begin
        pc_prediction_take = 1; // always take if there is no record
     end // else: !if(pc_prediction_table_valid[pc_jmp[9:0]] &&...

endmodule
