main:
    # [(11, 5), (8, 3), (4, 15), (7, 9), (1, 0)]
	
    addi $sp, $sp, -44
    move $s0, $sp

    li $v0, 5
    syscall
    li $s1, $a0
    
    li $v0, 5
    syscall
    li $s2, $a0
    
    move $a0, $s0
    li $a1, $s1
    li $a2, $s2
    jal min_heap_insert

    
    # Exit
    
    li $v0, 10
    syscall

mem_word_copy:
    # $a0: first base address
    # $a1: buffer
    # $a2: size
    
    li $t0, 0
    
    mem_word_copy_loop:
    	lw $t1, 0($a0)
   	sw $t1, 0($a1)
    	
    	addi $a0, $a0, 4
    	addi $a1, $a1, 4
    	
    	addi $t0, $t0, 1		
        blt $t0, $a2, mem_word_swap_loop
        
    jr $ra
    

mem_word_swap:
    # $a0: first base address
    # $a1: second base address
    # $a2: size
    
    li $t0, 0
    
    mem_word_swap_loop:
    	lw $t1, 0($a0)
    	lw $t2, 0($a1)
    	
    	sw $t1, 0($a1)
    	sw $t2, 0($a0)
    	
    	addi $a0, $a0, 4
    	addi $a1, $a1, 4
    	
    	addi $t0, $t0, 1		
        blt $t0, $a2, mem_word_swap_loop
        
    jr $ra

# Min-Heap{
#     size,
#     data
# }

min_heap_remove:
    # $a0: heap address
    
    # $v0: priority
    # $v1: index
    
    # $v0 = $s0[1]
    # $v1 = $s0[2]
    # $s[1...2] <-> $s[$s[0] - 2...$s[0]]
    # $s[0]--

    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    move $s0, $a0
    
    lw $s1, 0($s0)
    lw $v0, 4($s0)
    lw $v1, 8($s0)

    addi $t1, $s1, -1
    sll $t1, $t1, 3
    add $t1, $s0, $t1
    addi $t1, $t1, 4
    
    addi $s2, $s0, 4
    
    move $a0, $s2
    move $a1, $t1
    li $a2, 2
    jal mem_word_swap

    addi $s1, $s1, -1
    sw $s1, 0($s0)

    move $a0, $s2
    move $a1, $s1
    li $a2, 0
    jal min_heapify
 
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8

    jr $ra

min_heap_insert:
    # $a0: heap address
    # $a1: priority
    # $a2: vertex
    
    # $s0: heap data
    # $t0: heap size
    # $t1: inserted address
    # $s1: child index
    # $s2: parent index
    
    # $s0[$t0] = {$a1, $a2}
    # $s1 = $t0
    # $s2 = ($t0 - 1)/2
    # 
    # while($s0[$s2][0] > $s0[$s1][0]){
    #     $s0[$s2] <-> $s0[$s1]
    #     $s1 = $s2
    #     $s2 = ($s2 - 1) / 2
    # }
    #
    # size++
    
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $a0, 16($sp)
       
    lw $s3, 0($a0)
    move $s0, $a0
    addi $s0, $s0, 4
    
    sll $t1, $s3, 3
    add $t1, $t1, $s0
    sw $a1, 0($t1)
    sw $a2, 4($t1)
    
    move $s1, $s3
    addiu $s2, $s3, -1
    blez $s2, min_heap_insert_loop
    srl $s2, $s2, 1
    
    min_heap_insert_loop:
    bltz $s2, min_heap_insert_exit_loop
    
    sll $t2, $s2, 3
    add $t2, $t2, $s0
    lw $t3, 0($t2)
    sll $t4, $s1, 3
    add $t4, $t4, $s0
    lw $t5, 0($t4)
    
    ble $t3, $t5, min_heap_insert_exit_loop
        move $a0, $t2 
        move $a1, $t4
        li $a2, 2
        jal mem_word_swap
        
        lw $a0, 16($sp)
        move $s1, $s2
        addi $s2, $s2, -1
        blez $s2, min_heap_insert_loop
        srl $s2, $s2, 1
                        
    j min_heap_insert_loop
    min_heap_insert_exit_loop:
    
    addi $s3, $s3, 1
    sw $s3, 0($a0)
    
   
    lw $s2, 12($sp)
    lw $s1, 8($sp)
    lw $s0, 4($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    
    jr $ra

min_heapify:
    # $a0: base address
    # $a1: size
    # $a2: index
    
    # $t1 = $a2 * 2 + 1
    # $t2 = $a2 * 2 + 2
    #
    # $t0 = $a2
    #
    # if($t1 < $a1 && $a0[$t1][0] < $a0[$t0][0])
    #     $t0 = $t1
    # if($t2 < $a1 && $a0[$t2][0] < $a0[$t0][0])
    #     $t0 = $t2
    #
    # if($t0 != $a2)
    #     $a0[$a2] <-> $a0[$t0]
    #     min_heapify($a0, $a1, $t0)
    
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    
    
    add $t0, $a2, $a2
    addi $t1, $t0, 1
    addi $t2, $t0, 2
    
    move $t0, $a2
    
    bge $t1, $a1, min_heapify_exit_if_1
	sll $t3, $t1, 3
	add $t3, $a0, $t3
	lw $t3, 0($t3)
	
	sll $t4, $t0, 3
	add $t4, $a0, $t4
	lw $t4, 0($t4)
	
        bge $t3, $t4, min_heapify_exit_if_1
            move $t0, $t1
    min_heapify_exit_if_1:
    
    bge $t2, $a1, min_heapify_exit_if_2
	sll $t3, $t2, 3
	add $t3, $a0, $t3
	lw $t3, 0($t3)
	
	sll $t4, $t0, 3
	add $t4, $a0, $t4
	lw $t4, 0($t4)
	
        bge $t3, $t4, min_heapify_exit_if_2
            move $t0, $t2
    min_heapify_exit_if_2:
    
    beq $t0, $a2, min_heapify_exit
        sll $t3, $t0, 3
        add $t3, $a0, $t3
    
        sll $t5, $a2, 3
        add $t5, $a0, $t5
        
        move $a0, $t3
        move $a1, $t5
       	li $a2, 2
        jal mem_word_swap
        
        lw $a2, -12($sp)
        lw $a1, -8($sp)
        lw $a0, -4($sp)
        
        move $a2, $t0
        jal min_heapify
    
    min_heapify_exit:
    
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    
    jr $ra
  
print_array:
    # $a0: base address
    # $a1: size
        
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
