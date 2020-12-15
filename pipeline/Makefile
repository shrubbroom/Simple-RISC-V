TESTBENCH = riscv_soc_tb
SRCS	  = data_mem.v EX.v EX_hazard_checker.v EX_MEM_reg.v \
            ID.v ID_ALU_OP.v ID_EX_reg.v IF.v \
            IF_ID_reg.v inst_mem.v MEM.v MEM_WB_reg.v \
            RF.v riscv.v test.v WB.v

RESULT    = riscv_soc_tb
V_FLAG    = -g2005-sv

#------------------------------------------------------------------------------
# You should't be changing what is below
#------------------------------------------------------------------------------
all: simulate

lint:
	verilator --lint-only $(SRCS)

simulate:
	iverilog -o $(TESTBENCH).vvp $(TESTBENCH).v
	vvp $(TESTBENCH).vvp

test_%:
	@echo "test: $*"
	iverilog -o $(TESTBENCH)/$*_tb.vvp $(SRCS) $(TESTBENCH)/$*_tb.v
	vvp $(TESTBENCH)/$*_tb.vvp > $(TESTBENCH)/$*_log.txt
	@grep "ALEX_TEST_SUCCESS" $(TESTBENCH)/$*_log.txt

# test: test_SignExt test_ZeroExt test_ALU test_ALUOp test_DataMemory test_InstMemory test_IsShift test_RegisterFile test_IsShift test_ExtMode
	# @echo "Test Complete."

gtkwave:
	gtkwave $(RESULT).vcd &

# scansion: simulate
# 	open /Applications/Scansion.app $(RESULT).vcd

clean:
	rm -rf $(TESTBENCH).vvp $(RESULT).vcd $(TESTBENCH)_log.txt $(TESTBENCH)/*_log.txt  $(TESTBENCH)/*.vvp
