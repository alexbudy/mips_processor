.section    .start
.global     _start

_start:
	
li $t0, 0x1f0000b0  #seconds
li $t1, 0x1f0000b4  #minutes
li $t2, 0x1f0000c4  #rtc
li $t4, 0x1f0000d0  #inIdx
li $t5, 0x1f0000d4  #outIdx
li $t6, 1 #timer enable 
li $t3, 0x1f0000c8  #time bit
li $t7, 0x1f0000bc  #total seconds

sw $0, 0($t0)
sw $0, 0($t1)
sw $0, 0($t2)
sw $t6, 0($t3)
sw $0, 0($t4)
sw $0, 0($t5)
sw $0, 0($t7)

# initializes state to 0
li $t3, 0x1f0000c0  #time bit
sw $0, 0($t3)

#set seconds and minutes to ZERO
mfc0 $t1, $9
addu $t1, $t1, 0x02faf080
mtc0 $t1, $11

li $t0, 0x8c01 #timer, tx, rx and global
mtc0 $t0, $12

inf_loop:
	
	li $t3, 0x1f0000c0
	lw $t4, 0($t3)	
	li $t5, 0x72
	bne $t4, $t5, inf_loop
	
		li $t0, 0x1f0000c8 #timer, tx, rx and global
	sw $0, 0($t0) 
	jal r100M	
		li $t0, 0x1f0000c8 #timer, tx, rx and global
		li $t1, 0x1
	sw $t1, 0($t0) 

	li $t3, 0x1f0000c0
	sw $0, 0($t3)	
	
	j inf_loop

	r100M:	
		add $t7, $0, $0
		lui  $t8, 0x05f5 #100M
		ori $t8, $t8, 0xe100
		#li $t8, 0x05f5e100
		loop:
		#send_time('a');
		addiu $t7, $t7, 0x1
		bne $t7, $t8, loop
		jr $ra
