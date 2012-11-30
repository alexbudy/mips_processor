SECTIONS
{
    . = 0x10005000;
    .text : {
        * (.start);
        * (.text);
    }
}
