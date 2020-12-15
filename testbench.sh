#!/bin/bash
set -e
TESTBENCH=riscv_soc_tb
srcs=(pipeline single)
for src in ${srcs[*]}; do
    echo "+-------------------------------------------------------------------------------------------+"
    echo -n "Testing "
    echo -n $src
    echo
    rm -rf testbench
    mkdir testbench
    cp assembler/assembler_linux testbench/
    cp ./$src/*.v testbench/
    cp ./emulator/emulator.cpp testbench/
    cp ./test/*.asm testbench/
    cd testbench
    echo "Begin test"
    g++ -o emulator ./emulator.cpp
    for a in *.asm; do
        echo "---------------------------------------------------------------------------------------"
        echo -n "Testing "
        echo -n $a
        echo
        rm -f data_mem_emu.txt data_mem_verilog.txt register_file_emu.txt register_file_verilog.txt test_data_mem.txt
        mv $a assembly.asm
        echo | ./assembler_linux
        echo
        mv assembly.asm $a
        for i in {1..1024}; do echo "00" >> test_data_mem.txt; done
        cp test_data_mem.txt data_mem_emu.txt
        cp test_data_mem.txt data_mem.txt
        iverilog -o $TESTBENCH.vvp $TESTBENCH.v
        vvp $TESTBENCH.vvp > vvp.log
        ./emulator x
        diff data_mem_emu.txt data_mem_verilog.txt
        diff register_file_emu.txt register_file_verilog.txt
        echo -n "Testing "
        echo -n $a
        echo -n " done"
        echo
        echo "---------------------------------------------------------------------------------------"
    done
    cd ../
    echo -n "Testing "
    echo -n $src
    echo -n " Done"
    echo
    echo "+-------------------------------------------------------------------------------------------+"
done
