.section    .start
.global     _start

_start:
    li      $sp, 0x1000f000
	jal main
