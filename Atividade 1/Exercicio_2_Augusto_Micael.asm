# Micael Angelo Sabadin Presotto 22104063
# Augusto de Hollanda Vieira Guerner 22102192
.data
	MSG_ENTRADA: .asciiz "Digite um valor de B: "
	MSG_RESULTADO: .asciiz "Resultado �: "
	A: .word 0
	C: .word 0
	D: .word 0
	E: .word 0
	
.text
main:
	la $s0, A
	la $s2, C
	la $s3, D
	la $s4, E
	
	li $v0, 4
	la $a0, MSG_ENTRADA
	syscall
	
	li $v0, 5
	syscall
	move $t1 , $v0
	
	lw $t0, 0($s0)
	lw $t2, 0($s2)
	lw $t3, 0($s3)
	lw $t4, 0($s4)
	
	addi $t0, $t1, 35
	add $t2, $t3, $t4
	sub $t2, $t2, $t0
	
	sw $t2, 0($s2)
	
	li $v0, 4
	la $a0, MSG_RESULTADO
	syscall
	
	li $v0, 1
	la $a0, ($t2)
	syscall
