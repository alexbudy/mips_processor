.section    .start
.global     _start

_start:

addiu $s7, $0, 0x0
lui $s1, 0x8000
ori $s1, $s1, 0x4
lui $s3, 0b0110010001101111 
ori $s3, $s3, 0b0110111001100101

# Test 1

li $s0, 0x00000020
addiu $t0, $0, 0x20
addiu $s7, $s7, 1 # register to hold the test number (in case of failure)
bne $t0, $s0, Error

#Test 2
li $s0, 0x11100000
lui $t0, 0x1110
addiu $s7, $s7, 1
bne $t0, $s0, Error
j Done


Error:
# Perhaps write the test number over serial
sw $s0, 0($s1)
Done:
# Write success over serial
sw $s3, 0($s1) 
