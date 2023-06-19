.data
	MAX_STR: .asciiz "MAX="
	BLOCK_SIZE_STR: .asciiz "block_size="
.text
	# pedir o MAX
	#la $a0, MAX_STR
	#li $v0, 4
	#syscall

	li $v0, 5
	syscall
	move $t0, $v0 # t0 = MAX

	# pedir o block_size
	#la $a0, BLOCK_SIZE_STR
	#li $v0, 4
	#syscall

	li $v0, 5
	syscall
	move $s7, $v0 # s7 = block_size

	# alocar A e B
	
	mul $t1, $t0, $t0 # t1 = MAX*MAX
	mul $t1, $t1, 4 # t1 = MAX*MAX*4 (tamanho de bytes de cada matriz)
	
	li $v0, 9
	move $a0, $t1
	syscall
	move $s0, $v0 # s0 = endereco de A
	
	li $v0, 9
	syscall
	move $s1, $v0 # s1 = endereco de B

	# loops do código
	li $t2, 0 # t2 = i
	for_i:
		bge $t2, $t0, for_i_end
		li $t3, 0 # t3 = j
for_j:
	bge $t3, $t0, for_j_end
	move $t9, $t2 # t9 = ii
for_ii:
	add $t8, $t2, $s7 # t8 = i+block_size
	bge $t9, $t8, for_ii_end
	move $t8, $t3  # t8 = jj
for_jj:
	add $t7, $t3, $s7  # t7 = j+block_size
	bge $t8, $t7, for_jj_end

	#t2->t9
	#t3->t8

	# calcular offset do elemento de A (max*ii + jj)*4
	mul $t4, $t9, $t0  # t4 = max*ii
	add $t4, $t4, $t8  # t4 = max*ii + jj (offset no A)
	mul $t4, $t4, 4  # t4 = 4*..
	add $t4, $s0, $t4
	
	# carregar elemento do A
	l.s $f0, 0($t4)  # f0 = elemento do A

	# calcular offset do elemento de B (max*j + i)*4
	mul $t5, $t8, $t0  # t5 = max*jj
	add $t5, $t5, $t9  # t5 = max*jj + ii
	mul $t5, $t5, 4  # t5 = 4*...
	add $t5, $s1, $t5

	# carregar elemento do B
	l.s $f1, 0($t5)  # f1 = elemento do B

	# somar	elementos
	add.s $f2, $f0, $f1

	# salvar em A
	s.s $f2, 0($t4)


	addi $t8, $t8, 1
	j for_jj
for_jj_end:
	addi $t9, $t9, 1
	j for_ii
for_ii_end:
	add $t3, $t3, $s7
	j for_j
for_j_end:
	add $t2, $t2, $s7
	j for_i
for_i_end:
	
	li $v0, 10
	syscall
