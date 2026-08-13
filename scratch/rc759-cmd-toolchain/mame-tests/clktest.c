#include "drctest.h"
#include "mamedone.h"

/* clktest.c -- isolate whether the RC759/Concurrent-CP/M-86 XIOS "16 ms counter"
 * (Int 28h fn 19) advances during a tight busy loop, or only when the program
 * makes a system call (which would let the CCP/M dispatcher run). stdcbench's
 * timing loop reads this counter in a tight loop with NO syscalls and waits for
 * it to reach +8 s; on MAME it started (banner shown) then never finished, so
 * the counter appears not to advance. This probe reads it three ways and prints
 * the raw lo/hi/per words so we can see exactly what happens. */

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

/* BDOS console status (fn 11) via CP/M-86's INT 224 (0E0h) entry -- a cheap
 * system call that yields to the Concurrent CP/M-86 dispatcher. Self-contained
 * (no library symbol): CL = function number, returns AL. */
extern unsigned cpm_status();
#pragma aux cpm_status =        \
    "mov cl,11"                 \
    "int 0E0h"                  \
    value [ax]                  \
    modify [ax bx cx dx];

static struct xios_tick t;

static void show(tag) char *tag;
{
    xios_tick16(&t);
    printf("%s lo=%u hi=%u per=%u\n", tag, t.lo, t.hi, t.per);
}

TMAIN
{
    unsigned i;
    long spin;

    printf("== CLKTEST (Int 28h fn 19) ==\n");
    show("t0    ");

    /* (A) tight busy loop, NO syscalls -- what stdcbench's timing loop does */
    for (spin = 0; spin < 2000000L; spin++) { }
    show("busy  ");

    /* (B) loop that yields via BDOS console-status each iteration */
    for (i = 0; i < 20000u; i++) (void)cpm_status();
    show("syscl ");

    /* (C) another tight busy loop to re-confirm (A) */
    for (spin = 0; spin < 2000000L; spin++) { }
    show("busy2 ");

    printf("DONE\n");
    mame_done(0xC1C1);   /* sentinel: clktest completed */
}
