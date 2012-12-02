.section    .start
.global     _start

_start:
    li      $sp, 0x10009000
	
.if 0
	li $t1, 0x10400000
	li $t2, 0x0 #x
	li $t3, 0x0 #y
	li $t4, 800
	li $t5, 600
	li $s1, 400
	li $t9, 0xff00

	loopy:
	beq $t3, $t5, done	
	loopx:
	beq $t2, $t4, donex	
	sll $t6, $t3, 12
	sll $t7, $t2, 2
	add $t6, $t6, $t7
	add $t8, $t1, $t6
	#addiu $t9, $t9, 0x1
	sw $t9, 0($t8)

	addiu $t2, $t2, 0x1	
	j loopx

	donex:		
	li $t2, 0	
	addiu $t3, $t3, 0x1
	j loopy
	
	done:
.endif

	li $t1, 0x10400000
	li $t2, 0x30 #x
	li $t3, 0x50 #y
	li $t4, 0x41
	li $t5, 0x82
	li $t9, 0xff0000

	loopy:
	beq $t3, $t5, done	
	loopx:
	beq $t2, $t4, donex	
	sll $t6, $t3, 12
	sll $t7, $t2, 2
	add $t6, $t6, $t7
	add $t8, $t1, $t6
	#addiu $t9, $t9, 0x1
	sw $t9, 0($t8)

	addiu $t2, $t2, 0x1	
	j loopx

	donex:		
	li $t2, 0	
	addiu $t3, $t3, 0x1
	j loopy
	
	done:

