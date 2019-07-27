min_heapify:
    # $a0: array base address
    # $a1: array size
    # $a2: index
    
    # $t1 = $a2 * 2 + 1
    # $t2 = $a2 * 2 + 2
    #
    # $t0 = $a2
    #
    # if($t1 < $a1 && $a0[$t1] < $a0[$t0])
    #     $t0 = $t1
    # if($t2 < $a1 && $a0[$t2] < $a0[$t0])
    #     $t0 = $t2
    #
    # if($t0 != $a2)
    #     $a0[$a2] <-> $a0[$t0]
    #     min_heapify($a0, $a1, $t0)
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    add $t0, $a2, $a2
    addi $t1, $t0, 1
    addi $t2, $t0, 2
    
    move $t0, $a2
    
    bge $t1, $a1, min_heapify_exit_if_1
	sll $t3, $t1, 2
	add $t3, $a0, $t3
	lw $t3, 0($t3)
	
	sll $t4, $t0, 2
	add $t4, $a0, $t4
	lw $t4, 0($t4)
	
        bge $t3, $t4, min_heapify_exit_if_1
            move $t0, $t1
    min_heapify_exit_if_1:
    
    bge $t2, $a1, min_heapify_exit_if_2
	sll $t3, $t2, 2
	add $t3, $a0, $t3
	lw $t3, 0($t3)
	
	sll $t4, $t0, 2
	add $t4, $a0, $t4
	lw $t4, 0($t4)
	
        bge $t3, $t4, min_heapify_exit_if_2
            move $t0, $t2
    min_heapify_exit_if_2:
    
    beq $t0, $a2, min_heapify_exit
        sll $t3, $t0, 2
        add $t3, $a0, $t3
        lw $t4, 0($t3)
    
        sll $t5, $a2, 2
        add $t5, $a0, $t5
        lw $t6, 0($t5)
    
        sw $t4, 0($t5)
        sw $t6, 0($t3)
        
        move $a2, $t0
        jal min_heapify
    
    min_heapify_exit:
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4 
    
    jr $ra
