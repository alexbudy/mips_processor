.section    .start
.global     _start

_start:
    li      $sp, 0x10005000
    jal     main
	
