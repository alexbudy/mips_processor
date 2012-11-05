.section 	.start
.global		_start

_start:

mfc0 $k0, $13 //CAUSE
mfc0 $k1, $12 //STATUS
andi $k1, 0xfc00
and  $k0, $k0, $k1
andi $k1, $k0, 0x8000
bne  $k1, $0, timer_ISR
nop
andi $k1, $k0, 0x4000
bne  $k1, $0, RTC_ISR
nop
andi $k1, $k0, 0x0400 
bne  $k1, $0, UARTRX_ISR //UART receive interrupt, DataOutValid high, (read using the ISR)
nop
andi $k1, $k0, 0x0800 
bne  $k1, $0, UARTTX_ISR //UART transmit interrupt, DataInReady high, (write into the FIFO, by app)
nop
j done
nop

timer_ISR:
mfc0 $k1, $11 //COMPARE
lui $k0, 0x02FA
ori $k0, $k0, 0xF080
addu $k0, $k0, $k1
mtc0 $k0, $11 //COMPARE
j done
nop

RTC_ISR:
lw $k0, 0x100000c4
nop
addi $k0, $k0, 1
sw $k0, 0x100000c4
mfc0 $k1, $13 //CAUSE - sample code is wrong!! (NOT status)
andi $k1, $k1, !(1<<14) //disable timer cause
mtc0 $k1, $13
j done
nop

UARTRX_ISR: //read from FIFO
lw $k0, 0x1ddddddc //buffer starts at this address
nop
lw $k1, 0x1dddddd4 //outIdx
nop
add $k0, $k1, $k0 //buffer incremented to start of dequeue
lw $k0, 0($k0)




UARTTX_ISR:




r100M:
addi $t0, $0, 0
lui $t1, 0x0098
ori $t1, $t1, 0x9680
loop:
addi $t0, $t0, 1
bne $t0, $t1, loop
nop
j done
nop
 
v100M: 
lw $t0, 0x1dd0
nop
addi $t0, $t0, 1
sw $t0, 0x1dd0
bne $t0, $t1, v100M
nop
j done
nop

R100M:
addi $a0, $t0, 0
jal addone
nop
addi $t0, $v0,0
bne $t0, $t1, R100M
nop
j done
nop

V100M:
jal loadaddone
nop
addi $t0, $v0, 0
bne $t0, $t1, V100M
nop
j done
nop

loadaddone:
lw $t0, 0x1dd0
nop
addi $t0, $t0, 1
sw $t0, 0x1dd0
bne $t0, $t1, loadaddone
nop
jr $ra
nop

addone:
addi $v0, $t0, 1
jr $ra
nop

done:
mfc0 $k1, $12
ori $k1, $k1, 1
mfc0 $k0, $14
jr $k0
mtc0 $k1, $12
