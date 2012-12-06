.section    .start
.global     _start

_start:
    li      $sp, 0x1000f000
	jal main

	li $t1, 0x01000000
	li $t2, 0x10000000
	li $s1, 0x10000000
	li $s2, 0x80000030
	li $s3, 0x80000040
	li $t3, 0x10400000
	li $t3, 0x10800000

	sw 	$t3, 0($s3)
	sw 	$t1, 0($s1)
	sw 	$0, 4($s1)
	sw 	$s1, 0($s2)
	
	
	li $t7, 0x01000000
	li $s1, 0x80000040
	li $s2, 0x80000030
	

	li $t1, 0x10400000 #frame
	sw $t1, 0($s1)

	li $t2, 0x10000000
	li $t3, 0x10000000

	#fill_frame:
	sw $t7, 0($t2)
	addiu $t2, $t2, 4


	#x0 = 25:16 = bytes 5,4
	#y0 = 9:0   = bytes 1,0
	
	li $t4, 0x0200ff00
	li $t5, 0x00ff00ff #(dd,ff)
	li $t6, 0x00ff0150
	

	#draw_line:
	sw $t4, 0($t2)
	sw $t5, 4($t2)
	sw $t6, 8($t2)
	nop
	
	li $t4, 0x0200ff00
	li $t5, 0x00010001 #(dd,ff)
	li $t6, 0x00010150
	

	#draw_line:
	sw $t4, 12($t2)
	sw $t5, 16($t2)
	sw $t6, 20($t2)
	nop

	li $t4, 0x0200ff00
	li $t5, 0x01500150 #(dd,ff)
	li $t6, 0x015000ff
	

	#draw_line:
	sw $t4, 24($t2)
	sw $t5, 28($t2)
	sw $t6, 32($t2)
	nop

	li $t4, 0x0200ff00
	li $t5, 0x015000ff #(dd,ff)
	li $t6, 0x00ff00ff
	

	#draw_line:
	sw $t4, 36($t2)
	sw $t5, 40($t2)
	sw $t6, 44($t2)
	nop

	sw $0, 48($t2)
	nop
	sw $t3, 0($s2)
