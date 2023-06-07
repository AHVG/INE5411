# Augusto de Hollanda Vieira Guerner (22102192)
.data

	data: .space 1024
	size: .word 16

.text

	main:
		la $s0, data
		
		la $s1, size
		lw $s1, 0($s1)
	
		li $t0, 0
		for_1:
			beq $t0, $s1, exit_for_1
			
			li $t1, 0
			for_2:
				beq $t1, $s1, exit_for_2
					
				mul $t2, $t0, $s1
				add $t2, $t2, $t1
				
				mul $t3, $t2, 4
				add $t3, $t3, $s0
				
				sw $t2, 0($t3)
			
				addi $t1, $t1, 1
				j for_2
			exit_for_2:
		
			addi $t0, $t0, 1
			j for_1
		exit_for_1:
	
		li $v0, 10
		syscall

