SECTIONS
{
    . = 0x30001000;
    .text : {
        * (.start);
        * (.text);
    }
}
