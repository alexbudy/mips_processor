.section 	.start
.global		_start

_start:

mfc0 $k0, $13 #CAUSE
mfc0 $k1, $12 #STATUS
andi $k1, 0xfc00
and  $k0, $k0, $k1
andi $k1, $k0, 0x8000
bne  $k1, $0, timer_ISR
andi $k1, $k0, 0x0800
bne  $k1, $0, UART_TX
j done



timer_ISR:
mfc0 $k1, $11 #COMPARE
li   $k0, 0x100 #
#li   $k0, 0x02faf080 #50_000_000
addu  $k0, $k0, $k1
mtc0 $k0, $11
li   $k0, 0x100000b0 #load seconds passed
lw   $k1, 0($k0)
addiu $k1, $k1, 1
sw   $k1, 0($k0)
li   $k0, 0x3c  #check if seconds is 60
bne  $k0, $k1, print_time #go to print time if seconds < 60
addu $k1, $0, $0
li   $k0, 0x100000b0 
sw   $k1, 0($k0)
li   $k0, 0x100000b4
lw   $k1, 0($k0)
addiu $k1, $k1, 1
sw   $k1, 0($k0)
j print_time

print_time:
li $k0, 0x100000c8 #address for print bit
lw $k1, 0($k0)
li $k0, 0x00000001
bne $k0, $k1, done
#if we get here, need to send time to uart/fifo
#for now, send a byte (no fifo implemented yet)
li $k0, 0x4d #letter = M
li $k1, 0x80000008
sw $k0, 0($k1)
j done



UART_TX:
li $k0, 0x80000000
lw $k1, 0($k0)
andi $k1, $k1, 0x1
beq  $k1, $0, done #if DataInReady is low, go to done
li $k0, 0x100000d0
lw $k0, 0($k0) #inIdx
li $k1, 0x100000d4
lw $k1, 0($k1) #outIdx
beq $k1, $k0, done #if indexes are equal, jump to done
li $k0, 0x100000d4 #outIdx
li $k1, 0x100000d8 #buffer
add $k1, $k1, $k0
lb $k0, 0($k1)
li $k1, 0x80000008
sw $k0, 0($k1) #send byte over UART
li $k0, 0x100000d4
lw $k1, 0($k0) #load outIdx to incr
addiu $k1, $k1, 1
sw $k1, 0($k0) #store incremented outIdx
li #k0, 0x14 #buf size = 20
bne $k1, $k0, done
li $k0, 0x100000d4
sw $0, 0($k0)
j done


done:
mfc0 $k1, $12
ori $k1, $k1, 1
mfc0 $k0, $14
mtc0 $k1, $12
jr $k0
