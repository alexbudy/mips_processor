.section    .start
.global     _start

_start:

addiu $t1, $0, 0xffff
mtc0 $t1, $12

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
sw $s1, 0($s0)
