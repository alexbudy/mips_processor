start EchoTestbench
file copy -force ../../../software/echo/echo.mif imem_blk_ram.mif
file copy -force ../../../software/echo/echo.mif dmem_blk_ram.mif
add wave EchoTestbench/*
add wave EchoTestbench/CPU/*
add wave EchoTestbench/CPU/imem_blk_ram/*
run 10000us
