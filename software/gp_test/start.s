.section    .start
.global     _start

_start:
    li      $sp, 0x1000f000
	jal main
	
#	li $t0, 0x10400000 #frame
#	li $t1, 0x01000ff0 #fill color
#	li $t2, 0x80000040 #frame addr
#	li $t3, 0x80000030 #gp_code
#	li $t4, 0x10c00000 #mem addr

#	sw $t0, 0($t2)
#	sw $t1, 0($t4)
#	sw  $0, 4($t4)
#	sw $t4, 0($t3)


