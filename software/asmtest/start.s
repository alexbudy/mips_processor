.section    .start
.global     _start

_start:

addiu $s7, $0, 0x0

#test 1 addiu
li $s0, 0x00000020
addiu $t0, $0, 0x20
addiu $s7, $0, 1
bne $t0, $s0, Error

#test  2 lw
li $s0, 0x12345670
addiu $t1, $0, 0x0000beef
sw $t1, 0($s0)
lw $t2, 0($s0)
addiu $s7, $s7, 1
bne $t2, $t1, Error

#test 3 sw
li $s0, 0x7a
li $s1, 0x10000008
sw $s0, 0($s1)
lw $t0, 0($s1)
addiu $s7, $s7, 1
bne $t0, $s0, Error

#test 4 lb/sb
li $s0, 0x10000000
li $s2, 0x00000008
sb $s2, 0($s0)
lb $s3, 0($s0)
addiu $s7, $s7, 1
bne $s2, $s3, Error

#test 5 sll
addiu $s0, $0, 0x0001
addiu $t0, $0, 0x0008
sll $s0, $s0, 0x3
addiu $s7, $s7, 1
bne $t0, $s0, Error


j Done

Error:
# Perhaps write the test number over serial
li $s0, 0x80000008
sw $s7, 0($s0)

Done:
# Write success over serial
li $s1, 0xFF
li $s0, 0x80000008
sw $s1, 0($s0)
