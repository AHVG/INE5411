.data
.text
	
	.eqv MATRIX_SIZE 4

	li $s0, MATRIX_SIZE

	# alocar A e B
	mul $t0, $s0, $s0 # t0 = MATRIX_SIZE * MATRIX_SIZE
	mul $t0, $t0, 4   # t0 = MATRIX_SIZE * MATRIX_SIZE * 4 (tamanho de bytes de cada matriz)
	
	li $v0, 9
	move $a0, $t0
	syscall
	move $s1, $v0 # s0 = endereco de A
	
	li $v0, 9
	syscall
	move $s2, $v0 # s1 = endereco de B

	# loops do código
	li $t0, 0 # t0 = i = 0
for_i:
	bge $t0, $s0, for_i_end
	li $t1, 0 # t1 = j = 0
for_j:
	bge $t1, $s0, for_j_end

	# calcular offset do elemento de A (max*i + j)*4
	mul $t2, $t0, $s0  # t2 = max*i
	add $t2, $t2, $t1  # t2 = max*i + j (offset no A)
	mul $t2, $t2, 4    # t2 = 4*(max*i + j)
	add $t2, $s1, $t2
	
	# carregar elemento do A
	l.s $f0, 0($t2)  # f0 = elemento do A

	# calcular offset do elemento de B (max*j + i)*4
	mul $t3, $t1, $s0  # t3 = max*j
	add $t3, $t3, $t0  # t3 = max*j + i
	mul $t3, $t3, 4    # t3 = 4*(max*j + i)
	add $t3, $s2, $t3

	# carregar elemento do B
	l.s $f1, 0($t3)  # f1 = elemento do B

	# somar	elementos
	add.s $f2, $f0, $f1

	# salvar em A
	s.s $f2, 0($t2)

	addi $t1, $t1, 1 # j += 1
	j for_j
for_j_end:
	addi $t0, $t0, 1 # i += 1
	j for_i
for_i_end:

	# Saindo do programa
	li $v0, 10
	syscall
	
