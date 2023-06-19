.data
.text

	.eqv MATRIX_SIZE 4
	.eqv BLOCK_SIZE 4

	li $s0, MATRIX_SIZE
	li $s1, BLOCK_SIZE

	# alocar A e B
	mul $t1, $s0, $s0 # t1 = MAX*MAX
	mul $t1, $t1, 4 # t1 = MAX*MAX*4 (tamanho de bytes de cada matriz)
	
	li $v0, 9
	move $a0, $t1
	syscall
	move $s2, $v0 # s2 = endereco de A
	
	li $v0, 9
	syscall
	move $s3, $v0 # s3 = endereco de B

	# loops do código
	li $t2, 0 # t2 = i
for_i:
	bge $t2, $s0, for_i_end
	li $t3, 0 # t3 = j
for_j:
	bge $t3, $s0, for_j_end
	move $t9, $t2 # t9 = ii
for_ii:
	add $t8, $t2, $s1 # t8 = i+block_size
	bge $t9, $t8, for_ii_end
	move $t8, $t3  # t8 = jj
for_jj:
	add $t7, $t3, $s1  # t7 = j+block_size
	bge $t8, $t7, for_jj_end

	#t2->t9
	#t3->t8

	# calcular offset do elemento de A (max*ii + jj)*4
	mul $t4, $t9, $s0  # t4 = max*ii
	add $t4, $t4, $t8  # t4 = max*ii + jj (offset no A)
	mul $t4, $t4, 4  # t4 = 4*..
	add $t4, $s2, $t4
	
	# carregar elemento do A
	l.s $f0, 0($t4)  # f0 = elemento do A

	# calcular offset do elemento de B (max*j + i)*4
	mul $t5, $t8, $s0  # t5 = max*jj
	add $t5, $t5, $t9  # t5 = max*jj + ii
	mul $t5, $t5, 4  # t5 = 4*...
	add $t5, $s3, $t5

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
	add $t3, $t3, $s1
	j for_j
for_j_end:
	add $t2, $t2, $s1
	j for_i
for_i_end:
	
	li $v0, 10
	syscall
