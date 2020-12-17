        addi x1, x0, 0
        addi x2, x0, 50
        addi x3, x0, 100
        addi x4, x0, 2
        addi x5, x0, 0
makeseq:
        sw x3, 0(x5)
        sub x3, x3, x4
        addi x5, x5, 4
        addi x1, x1, 1
        blt x1, x2, makeseq
        addi x5, x5, -4
