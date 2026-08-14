/* Internal CP/M-86 BDOS access for the -bcpm86 C library. */
#ifndef CPMSYS_H
#define CPMSYS_H
/* BDOS: INT 0E0h, function in CL, parameter in DX, result in AL. */
extern unsigned char _bdos( unsigned char func, unsigned param );
#pragma aux _bdos =             \
    "int 0E0h"                  \
    parm [cl] [dx]              \
    value [al]                  \
    modify [ax bx cx dx es];
#define _BDOS_CONOUT   2        /* DL = char */
#define _BDOS_EXIT     0
void _conout( char c );
#endif
