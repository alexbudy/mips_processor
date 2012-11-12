SECTIONS
{
    . = 0x10000d00;
    .text : {
        * (.start);
        * (.text);
    }
}
