start BIOSTestbench
file copy -force ../../../software/bios150v3/bios150v3.mif imem_blk_ram.mif
file copy -force ../../../software/bios150v3/bios150v3.mif dmem_blk_ram.mif
add wave BIOSTestbench/*
add wave BIOSTestbench/CPU/*
add wave BIOSTestbench/CPU/RegFile/*
run 10000us
