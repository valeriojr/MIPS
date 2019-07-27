print_array:
    # $a0: array base address
    # $a1: array size
        
    li $t1, 0
    move $t0, $s0
    main_loop_print:
        lw $a0, 0($t0)
        li $v0, 1
        syscall

        li $v0, 11
        li $a0, 32
        syscall

	addi $t0, $t0, 4
	addi $t1, $t1, 1
        blt $t1, $a1, main_loop_print   
    
    li $v0, 11
    li $a0, 10
    syscall
    
    jr $ra
