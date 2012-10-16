start ASMTestbench
file copy -force ../../../software/asmtest/asmtest.mif imem_blk_ram.mif
file copy -force ../../../software/asmtest/asmtest.mif dmem_blk_ram.mif
add wave ASMTestbench/*
add wave ASMTestbench/CPU/*
add wave ASMTestbench/CPU/RegFile/*
run 10000us
