module IF #(
            parameter PREDICTION_TAKE = 2'b1,
            parameter PREDICTION_TAKE_TAKE = 2'b11,
            parameter PREDICTION_NTAKE = 2'b0,
            parameter PREDICTION_NTAKE_NTAKE = 2'b10
            ) (
               input         clk,
               input         reset,
               input         ID_branch,
               input         EX_zero,
               input         EX_branch,
               input         EX_flush,
               input         EX_stall, // load-use stall
               input [31:0]  imme,
               input         ID_kick_up,
               output [31:0] inst_mem_read_addr,
               output        inst_mem_read_enable,
               output        IF_kick_up
               );
   reg [31:0]                pc;
   reg [31:0]                pc_stash_base;
   reg [31:0]                pc_stash_imme;
   reg                       pc_take;
   reg [21:0]                pc_prediction_table_tag [1023:0];
   reg [1:0]                 pc_prediction_table_take [1023:0];
   reg                       pc_prediction_table_valid [1023:0];

   wire [31:0]               pc_jmp = pc - 4;
   integer                   i = 0;

   assign inst_mem_read_addr = pc;
   assign inst_mem_read_enable = 1;

   always @ (posedge clk or posedge reset)
     if (reset)
       pc <= 0;
     else
       if (EX_stall) begin
          pc <= pc; // fatal hazard
       end else
         if (EX_flush) begin
            if(pc_take) pc <= pc_stash_base + 4;
            else pc <= pc_stash_base + pc_stash_imme;
         end
         else
           if (ID_branch) begin
              pc_stash_base <= pc_jmp;
              pc_stash_imme <= imme;
              if (pc_prediction_table_valid[pc_jmp[9:0]] &&
                  pc_prediction_table_tag[pc_jmp[9:0]] == pc_jmp[31:10]) begin
                 if (pc_prediction_table_take[pc_jmp[9:0]][0] == 1) begin
                    pc <= pc_jmp + imme;
                    pc_take <= 1;
                 end
                 else begin
                    pc <= pc_jmp + 4;
                    pc_take <= 0;
                 end
              end
              else begin
                 pc <= pc_jmp + imme; // always jump if there is no record for current pc
                 pc_take <= 1;
              end
           end

   always @ (posedge clk or posedge reset)
     if (reset)
       for (i = 0; i <= 1023; i = i + 1) begin
          pc_prediction_table_valid[i] = 0;
       end
     else
       if (EX_branch)
         case ({EX_zero,pc_prediction_table_valid[pc_stash_base[9:0]] == 0})
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
         endcase // case ({EX_flush,pc_prediction_table_valid[pc_stash_base[9:0]] == 0})
       else begin end

   reg IF_kick_up_internal;
   always @ (posedge clk or posedge reset)
     if (reset) begin
        IF_kick_up_internal <= 1;
     end else
       if (ID_kick_up) IF_kick_up_internal <= 1;
       else IF_kick_up_internal <= 0;
   assign IF_kick_up = IF_kick_up_internal;

endmodule
