.section    .start
.global     _start

_start:

#initialize global variables to ZEROS

li $t3, 0x1f0000c8  #timer print
li $t6, 0x1        #for the print bit
lw $t7, 0($t3)
beq $t7, $t6, continue


li $t0, 0x1f0000b0  #seconds
li $t1, 0x1f0000b4  #minutes
li $t2, 0x1f0000c4  #rtc
li $t4, 0x1f0000d0  #inIdx
li $t5, 0x1f0000d4  #outIdx

sw $0, 0($t0)
sw $0, 0($t1)
sw $0, 0($t2)
sw $t6, 0($t3)
sw $0, 0($t4)
sw $0, 0($t5)

#set seconds and minutes to ZERO
addiu $t1, $0, 0xffff
mtc0 $t1, $12

addiu $t5, $0, 0x7f
mtc0 $t5, $11
continue:



addiu $s7, $0, 0x0

#test 1 addiu
li $s0, 0x00000020
addiu $t0, $0, 0x20
addiu $s7, $0, 1
bne $t0, $s0, Error

#test mtc0
#mtc0 $s0, $12 #puts 20 into reg 12
addiu $s7, $s7, 1

#test mfc0
#mfc0 $s3, $12 #puts back into reg s3
#bne $s0, $s3, Error


j Done

Error:
# Perhaps write the test number over serial
li $s0, 0x80000008
sw $s7, 0($s0)

Done:
# Write success over serial
li $s1, 0xFD
li $s0, 0x80000008
#sw $s1, 0($s0)
