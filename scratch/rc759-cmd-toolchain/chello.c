static void bdos(unsigned char func, unsigned param)
{
    __asm {
        mov cl, func
        mov dx, param
        int 0E0h
    }
}
void cmain(void)
{
    static const char msg[] = "\r\nHELLO-FROM-COMPILED-C\r\n$";
    const char *p = msg;
    while (*p != '$')
        bdos(2, (unsigned)(unsigned char)*p++);
}
