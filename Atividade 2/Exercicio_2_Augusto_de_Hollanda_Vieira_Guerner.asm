# Augusto de Hollanda Vieira Guerner 22102192
.data

	BREAK: .asciiz "\n"
	SPACE: .asciiz " "
	A: .word 1, 2, 3, 0, 1, 4, 0, 0, 1
	B: .word 1, -2, 5, 0, 1, -4, 0, 0, 1
	C: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
	LINES: .word 3
	COLUMNS: .word 3
	FILE_NAME: .asciiz "matrix.txt"  # Vai gerar o arquivo onde está localizado o MARS
	
	
.text
main:

	# Carregando alguns valores chaves para a execução
	la $s0, A
	la $s1, B
	la $s2, C
	la $s3, LINES
	la $s4, COLUMNS
	
	lw $s5, 0($s3)    # Linhas
	lw $s6, 0($s4) 	  # Colunas
	mul $s7, $s6, $s5 # Nº elementos
	
	
	# Fazer a multiplicação entre a matriz A e B e armazenar em C
	move $t0, $zero   # Contador do LOOP_1
	move $t1, $zero   # Contador linha
	move $t2, $zero   # Contador coluna
	LOOP_1:
		
		# If para contar e zerar respectivamente a linha e a coluna atual
		bne $t2, $s6, IF_1
			move $t2, $zero
			addi $t1, $t1, 1
		IF_1:
		
		move $t3, $zero # Contador do LOOP_2
		move $t4, $zero # Acumulador
		LOOP_2:
		
			# Calculando indice
			mul $t5, $t1, $s6   # LINHA_ATUAL * NUMERO_DE_COLUNAS
			add $t5, $t5, $t3   # LINHA_ATUAL * NUMERO_DE_LINHAS + CONT_LOOP_2

			mul $t6, $t3, $s6   # CONT_LOOP_2 * NUMERO_DE_COLUNAS
			add $t6, $t6, $t2   # CONT_LOOP_2 * NUMERO_DE_COLUNAS + COLUNA_ATUAL
			
			# Multiplicando por quatro
			add $t5, $t5, $t5
			add $t5, $t5, $t5
			
			add $t6, $t6, $t6
			add $t6, $t6, $t6
			
			# Somando com o endereço base de A e B
			add $t5, $s0, $t5
			add $t6, $s1, $t6
			
			# Carregando valores
			lw $t5, 0($t5)
			lw $t6, 0($t6)
			
			# Multiplicando 
			mul $t5, $t5, $t6
			
			# Incrementando o acumulador
			add $t4, $t4, $t5
			
			# Incrementando contador LOOP_2
			addi $t3, $t3, 1
			bne $t3, $s6, LOOP_2
		
		# Multiplicando por 4
		add $t5, $t0, $t0
		add $t5, $t5, $t5
		
		# Somando o endereço base de C
		add $t5, $s2, $t5
		
		# Armazenando acumulador no vetor C
		sw $t4, 0($t5)
		
		# Incrementando coluna atual
		addi $t2, $t2, 1

		# Incrementando contador LOOP_1
		addi $t0, $t0, 1
		bne $t0, $s7, LOOP_1

	# Loop para traduzir o resultado para ASCII
	# Inicializando contadores
	move $t0, $zero # Contador LOOP_3
	move $t1, $zero # Contador coluna
	LOOP_3:

		# Calculando endereço do elemento em C
		add $t2, $t0, $t0
		add $t2, $t2, $t2
		add $t2, $t2, $s2

		# Carregando valor armazenado no endereço calculado acima
		lw $t3, 0($t2)
		
		# Adicionando 48 para se tornar um número em ascii
		addi $t3, $t3, 48
		
		# Armazenando em c de novo
		sw $t3, 0($t2)

		# Incrementando os contadores
		addi $t0, $t0, 1
		bne $t0, $s7, LOOP_3
	
	# Abrindo o arquivo em modo escrita
	li $v0, 13
	la $a0, FILE_NAME
	li $a1, 1
	li $a2, 0
	syscall
	move $s6, $v0

	# Loop para escrita em arquivo do resultado da multiplicação das matrizes A e B
	# Inicializando os contadores
	move $t0, $zero # Contador de quebra de linah
	move $t1, $zero # Contador do loop
	LOOP_4:

		# If para quebrar a linha do arquivo
		bne $t0, $s6, IF_2
			# Zerando contador
			move $t0, $zero
			
			# Trecho que quebra a linha no arquivo
			li $v0, 15
			move $a0, $s6
			la $a1, BREAK
			li $a2, 1
			syscall
		IF_2:

		# Calculando endereço do vetor C
		add $t2, $t1, $t1
		add $t2, $t2, $t2
		add $t2, $t2, $s2
		
		# Escrevendo o número armazenado no endereço calculado no arquivo
		li $v0, 15
		move $a0, $s6
		move $a1, $t2
		li $a2, 1
		syscall

		# Incrementando contadores
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		bne $t1, $s7, LOOP_4

	# Fechando arquivo
	li $v0, 16
	move $a0, $s6
	syscall
