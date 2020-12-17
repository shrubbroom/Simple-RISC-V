TESTBENCH = riscv_soc_tb
SRCS	  = data_mem.v EX.v EX_hazard_checker.v EX_MEM_reg.v \
            ID.v ID_ALU_OP.v ID_EX_reg.v IF.v \
            IF_ID_reg.v inst_mem.v MEM.v MEM_WB_reg.v \
            RF.v riscv.v WB.v

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

test:
	rm -f machinecode.txt
	rm -f test_data_mem.txt
	rm -f data_mem_verilog.txt
	rm -f register_file_verilog.txt
	echo | ./assembler_linux
	for i in {1..1024}; do echo "00" >> test_data_mem.txt; done
	make simulate

gtkwave:
	gtkwave $(RESULT).vcd &

clean:
	rm -rf $(TESTBENCH).vvp $(RESULT).vcd $(TESTBENCH)_log.txt $(TESTBENCH)/*_log.txt  $(TESTBENCH)/*.vvp
