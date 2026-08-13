/* clock_test.c -- minimal check that the RC759 XIOS Int 28h fn 19 clock is
 * wired and advances.  Reads the 16 ms counter three times with a busy loop
 * between reads; prints "clock: PASS" if each read is strictly greater than the
 * previous (lexicographically over seconds-hi, seconds-lo, 16 ms periods) and
 * "clock: FAIL" otherwise.  This is the fast regression for the emu2 clock
 * (src/cpm86.c intr_cpm_int28 + src/cpu.c emu_code_bytes); the full cross-check
 * is stdcbench, which scores 7/5/12 identically under emu2 and the Unicorn
 * runner.  Build small: ./cc-cpm86.sh -m s -o CLOCK.CMD clock_test.c
 */
#include "drcbridge.h"

/* XIOS fn 19: AL=19, INT 28h -> DX:AX = seconds, CX = 16 ms periods.  Copy the
 * three result words into the struct via BX (small model: DS-relative). */
struct xios_tick { unsigned lo, hi, per; };
extern void xios_tick16(struct xios_tick *t);
#pragma aux xios_tick16 =       \
    "mov al,19"                 \
    "int 28h"                   \
    "mov [bx],ax"               \
    "mov [bx+2],dx"             \
    "mov [bx+4],cx"             \
    parm [bx]                   \
    modify [ax cx dx];

static void emit(param) unsigned param;          /* BDOS C_WRITE (func 2) */
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

/* strictly-greater over (hi, lo, per) -- the full time ordering */
static int later(struct xios_tick *b, struct xios_tick *a)
{
    if(b->hi != a->hi)
        return b->hi > a->hi;
    if(b->lo != a->lo)
        return b->lo > a->lo;
    return b->per > a->per;
}

static void spin(void)
{
    volatile unsigned i, s = 0;
    for(i = 0; i < 20000u; i++)
        s += i;
}

DRC_MAIN
{
    struct xios_tick t0, t1, t2;

    xios_tick16(&t0);
    spin();
    xios_tick16(&t1);
    spin();
    xios_tick16(&t2);

    if(later(&t1, &t0) && later(&t2, &t1))
        puts_("clock: PASS\r\n");
    else
        puts_("clock: FAIL\r\n");
}
