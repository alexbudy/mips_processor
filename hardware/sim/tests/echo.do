start EchoTestbench
file copy -force ../../../software/echo/echo.mif imem_blk_ram.mif
file copy -force ../../../software/echo/echo.mif dmem_blk_ram.mif
add wave BIOSTestbench/*
add wave BIOSTestbench/CPU/*
add wave BIOSTestbench/CPU/RegFile/*
run 10000us
