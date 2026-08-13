/* hello_cpm86.c -- a user program with NO bridge pragmas at all. Selecting the
 * CP/M-86 target (cc-cpm86.sh) auto-includes _preincl.h, which supplies the DR C
 * calling convention, the DRC_MAIN entry macro, and the stdlib pragma for strlen.
 * So this is just ordinary C that calls a DR C stdlib routine. Prints "5".
 */
extern unsigned strlen(char *s);   /* prototype only; convention comes from glue */

static void conout(param) unsigned param;
{
    __asm {
        mov cl, 2
        mov dx, param
        int 0E0h
    }
}

DRC_MAIN
{
    conout('0' + strlen("HELLO"));
    conout(13);
    conout(10);
}
