.section    .start
.global     _start

_start:
    li      $sp, 0x10000d00
    jal     main
