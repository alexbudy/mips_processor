start EchoTestbenchCaches
file copy -force ../../../software/test_hw/test_hw.mif imem_blk_ram.mif
file copy -force ../../../software/test_hw/test_hw.mif dmem_blk_ram.mif
file copy -force ../../../software/test_hw/test_hw.mif bios_mem.mif
file copy -force ../../../software/isr_basic/isr.mif isr_mem.mif

add wave EchoTestbenchCaches/DUT/*
add wave EchoTestbenchCaches/DUT/COP0150/*
add wave EchoTestbenchCaches/DUT/isr_mem/*
add wave EchoTestbenchCaches/DUT/RegFile/*
run 3000us
