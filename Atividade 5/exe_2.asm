# Augusto de Hollanda Vieira Guerner (22102192)
# Fabricio Duarte Júnior (22100615)

.data
.text

	.eqv MATRIX_SIZE 4
	.eqv BLOCK_SIZE 4

	li $s0, MATRIX_SIZE
	li $s1, BLOCK_SIZE

	# alocar A e B
	mul $t0, $s0, $s0 # t0 = MATRIX_SIZE * MATRIX_SIZE
	mul $t0, $t0, 4   # t0 = MATRIX_SIZE * MATRIX_SIZE * 4 (tamanho de bytes de cada matriz)
	
	li $v0, 9
	move $a0, $t0
	syscall
	move $s2, $v0 # s2 = endereco de A
	
	li $v0, 9
	syscall
	move $s3, $v0 # s3 = endereco de B

	# loops do código
	li $t0, 0 # t0 = i = 0
for_i:
	bge $t0, $s0, for_i_end # i < matrix_size
	li $t1, 0 		# t1 = j = 0
for_j:
	bge $t1, $s0, for_j_end # j < matrix_size
	move $t2, $t0 		# t2 = ii = i
for_ii:
	add $t4, $t0, $s1 	 # t4 = i+block_size
	bge $t2, $t4, for_ii_end # ii < i + block_size
	move $t3, $t1  		 # t3 = jj = j
for_jj:
	add $t5, $t1, $s1  # t5 = j+block_size
	bge $t3, $t5, for_jj_end # jj < j + block_size

	# calcular offset do elemento de A (max*ii + jj)*4
	mul $t6, $t2, $s0  # t6 = max*ii
	add $t6, $t6, $t3  # t6 = max*ii + jj (offset no A)
	mul $t6, $t6, 4    # t6 = 4*(max*ii + jj)
	add $t6, $s2, $t6  # t6 += endereco_a
	
	# carregar elemento do A
	l.s $f0, 0($t6)  # f0 = elemento do A

	# calcular offset do elemento de B (max*j + i)*4
	mul $t7, $t3, $s0  # t7 = max*jj
	add $t7, $t7, $t2  # t7 = max*jj + ii
	mul $t7, $t7, 4    # t7 = 4*(max*jj + ii)
	add $t7, $s3, $t7  # t7 += endereco_b

	# carregar elemento do B
	l.s $f1, 0($t7)  # f1 = elemento do B

	# somar	elementos
	add.s $f2, $f0, $f1

	# salvar em A
	s.s $f2, 0($t6)


	addi $t3, $t3, 1 # jj += 1
	j for_jj
for_jj_end:
	addi $t2, $t2, 1 # ii += 1
	j for_ii
for_ii_end:
	add $t1, $t1, $s1 # j += block_size
	j for_j
for_j_end:
	add $t0, $t0, $s1 # i += block_size
	j for_i
for_i_end:
	
	# Saindo do programa
	li $v0, 10
	syscall
