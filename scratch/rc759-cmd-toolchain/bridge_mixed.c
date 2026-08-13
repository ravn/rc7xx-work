/* bridge_mixed.c -- proves the DRC bridge convention applies ONLY to DR C stdlib
 * routines, leaving our own Watcom-compiled routines on the native convention.
 *
 *   strlen  -> lives in DR C's CLEARL stdlib -> #pragma aux (DRC) strlen;
 *   triple  -> our own routine (mylib_own.c) -> plain extern, NO pragma (native)
 *
 * Disassembly confirms the split: `call strlen` (bare name, DR C cdecl) vs
 * `call triple_` (Watcom-mangled, native watcall). Expect output "5 21".
 */
#include "drcbridge.h"

/* DR C stdlib routine -> DRC convention (bare name, stack cdecl, far) */
extern unsigned strlen(char *s);
#pragma aux (DRC) strlen;

/* OUR OWN routine -> plain extern, native Watcom convention, NO pragma */
extern int triple(int x);

static void conout(param) unsigned param;
{
    __asm {
        mov cl, 2
        mov dx, param
        int 0E0h
    }
}
static void putnum(n) unsigned n;
{
    if (n >= 10) putnum(n / 10);
    conout('0' + (n % 10));
}

DRC_MAIN
{
    putnum(strlen("HELLO"));   /* DR C stdlib -> 5  */
    conout(' ');
    putnum(triple(7));         /* our own      -> 21 */
    conout(13);
    conout(10);
}
