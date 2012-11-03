.section 	.start
.global		_start

_start:

mfc0 $k0, $13 
mfc0 $k1, $12 
andi $k1, 0xfc00
and  $k0, $k0, $k1
andi $k1, $k0, 0x8000
bne  $k1, $0, timer_ISR
andi $k1, $k0, 0x4000
bne  $k1, $0, RTC_ISR
andi $k1, $k0, 0x0400
bne  $k1, $0, UART_ISR
j done
nop

timer_ISR:
mfc0 $k1, $13
lui $k0, 0x02FA
ori $k0, $k0, 0xF080
addu $k0, $k0, $k1
mtc0 $k0, $13
J done

RTC_ISR:
lw $k0, 0x1ccccccc
nop
addi $k0, $k0, 1
sw $k0, 0x1ccccccc
mfc0 $k1, $12
andi $k1, $k1, !(1<<14)
mtc0 $k1, $12
j done

UART_ISR:

j done

done:
mfc0 $k1, $12
ori $k1, $k1, 1
mfc0 $k0, $14
jr $k0
mtc0 $k1, $12
