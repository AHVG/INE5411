.data
.text
	
	.eqv MATRIX_SIZE 4

	li $s0, MATRIX_SIZE

	# alocar A e B
	
	mul $t1, $s0, $s0 # t1 = MAX*MAX
	mul $t1, $t1, 4 # t1 = MAX*MAX*4 (tamanho de bytes de cada matriz)
	
	li $v0, 9
	move $a0, $t1
	syscall
	move $s1, $v0 # s0 = endereco de A
	
	li $v0, 9
	syscall
	move $s2, $v0 # s1 = endereco de B

	# loops do código
	li $t2, 0 # t2 = i
for_i:
	bge $t2, $s0, for_i_end
	li $t3, 0 # t3 = j
for_j:
	bge $t3, $s0, for_j_end

	# calcular offset do elemento de A (max*i + j)*4
	mul $t4, $t2, $s0  # t4 = max*i
	add $t4, $t4, $t3  # t4 = max*i + j (offset no A)
	mul $t4, $t4, 4  # t4 = 4*..
	add $t4, $s1, $t4
	
	# carregar elemento do A
	l.s $f0, 0($t4)  # f0 = elemento do A

	# calcular offset do elemento de B (max*j + i)*4
	mul $t5, $t3, $s0  # t5 = max*j
	add $t5, $t5, $t2  # t5 = max*j + i
	mul $t5, $t5, 4  # t5 = 4*...
	add $t5, $s2, $t5

	# carregar elemento do B
	l.s $f1, 0($t5)  # f1 = elemento do B

	# somar	elementos
	add.s $f2, $f0, $f1

	# salvar em A
	s.s $f2, 0($t4)

	addi $t3, $t3, 1
	j for_j
for_j_end:
	addi $t2, $t2, 1
	j for_i
for_i_end:

	li $v0, 10
	syscall
	
