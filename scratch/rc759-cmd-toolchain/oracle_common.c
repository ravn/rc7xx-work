/* oracle_common.c -- common-ground oracle test.
 *
 * Prints "0 TESTING C" .. "3 TESTING C" then "FINISHED", using ONLY raw BDOS
 * console output (function 2) so it is buildable by BOTH toolchains with no libc:
 *   - DR C   (the correctness oracle): __BDOS(2, ch)          entry = main()
 *   - Open Watcom (our ccrc759 path):  int 0E0h, CL=2, DL=ch  entry = cmain()
 *
 * We emit every byte explicitly (including CR/LF) so the two builds must produce
 * byte-identical console output; the DR C build is the reference.  Written in
 * K&R style so DR C 1.11 and `bwcc -0 -ms` both accept it unchanged.
 */

#ifdef DRC
#define ENTRY main
#define CONOUT(ch) __BDOS(2, (ch))
#else
#define ENTRY cmain
static void CONOUT(param) unsigned param;
{
    __asm {
        mov cl, 2
        mov dx, param
        int 0E0h
    }
}
#endif

static void puts2(s) char *s;
{
    while (*s)
        CONOUT(*s++);
}

int ENTRY()
{
    int i;

    for (i = 0; i <= 3; i++) {
        CONOUT('0' + i);
        puts2(" TESTING C\r\n");
    }
    puts2("\r\nFINISHED\r\n");
    return 0;
}
