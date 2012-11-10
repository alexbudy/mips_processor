.section 	.start
.global		_start

_start:

mfc0 $k0, $13 #CAUSE
mfc0 $k1, $12 #STATUS
andi $k1, 0xfc00
and  $k0, $k0, $k1
andi $k1, $k0, 0x8000
bne  $k1, $0, timer_ISR
j done

timer_ISR:



done:
mfc0 $k1, $12
ori $k1, $k1, 1
mfc0 $k0, $14
mtc0 $k1, $12
jr $k0
