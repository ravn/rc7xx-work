/* bridge_min.c -- the SIMPLEST possible Watcom -> DR C bridge program.
 *
 * Per-program surface is just: include the header, one #pragma per DR C routine,
 * and DRC_MAIN. Everything else (calling convention, bare-name aliasing, entry
 * export, -zu pointer fix) lives in drcbridge.h + the build recipe (bridge-min.sh).
 *
 * Calls the genuine DR C 1.11 CLEARL `strlen`; prints strlen("HELLO") == 5.
 */
#include "drcbridge.h"

extern unsigned strlen(char *s);
#pragma aux (DRC) strlen;

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
