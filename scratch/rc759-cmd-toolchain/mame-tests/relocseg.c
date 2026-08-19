/* relocseg.c -- minimal CP/M-86 load-time relocation repro for emu2.
 *
 * A global FAR pointer to a function.  In the large model this is 4 bytes
 * (offset:2, segment:2).  The SEGMENT word is written by LINK-86 as a
 * GROUP-RELATIVE paragraph and carries a load-time fixup record (header
 * byte 127 bit 7 set + ch_fixrec table): the genuine Concurrent CP/M-86
 * loader ADDS the code group's real load segment to it.
 *
 * So the printed segment must equal the program's actual CS-family code
 * segment (a large value the loader chose, e.g. 0x0900+).  emu2 does not
 * read ch_fixrec / apply fixups, so it leaves the word group-relative
 * (a tiny value, typically 0x0000) -- a far pointer to code that would
 * jump into the interrupt-vector area instead of the program.
 *
 * Build:  ./cc-cpm86.sh -m l -o RELOCSEG.CMD relocseg.c
 * Run  :  emu2 RELOCSEG.CMD   (or on genuine CCP/M-86 / RC759 MAME)
 * Watch:  "code seg = XXXX"   -- tiny under emu2 (BUG), large on real HW.
 */

#include "drcbridge.h"

extern void code_target(void);

void code_target(void)
{
    /* nothing -- we only take its address */
}

/* Global initialiser -> the SEG of code_target lands in the DATA image and
 * gets a relocation fixup (target group = code). */
void (*fp)(void) = code_target;

static void emit(param) unsigned param;         /* BDOS C_WRITE (func 2) */
{
    __asm {
        mov cl, 2
        mov dx, param
        int 0E0h
    }
}

static void puts_(char *s)
{
    while(*s)
        emit((unsigned)(unsigned char)*s++);
}

static void puthex4(unsigned v)                 /* 16-bit value as 4 hex digits */
{
    static const char h[] = "0123456789abcdef";
    emit((unsigned)(unsigned char)h[(v >> 12) & 0xf]);
    emit((unsigned)(unsigned char)h[(v >> 8) & 0xf]);
    emit((unsigned)(unsigned char)h[(v >> 4) & 0xf]);
    emit((unsigned)(unsigned char)h[v & 0xf]);
}

DRC_MAIN
{
    unsigned seg = ((unsigned *)&fp)[1];        /* segment word of the far ptr */
    puts_("code seg = ");
    puthex4(seg);
    puts_("\r\n");
}
