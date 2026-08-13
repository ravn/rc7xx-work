#include "drctest.h"

/* longloop.c -- CONFIRM in the real RC759/MAME emulator whether the
 * "long accumulated across a loop" defect is a bridge bug (not an emu2 artifact).
 * emu2 shows r=1 instead of 10000; if MAME shows the same, the store-back bug is
 * real (bridge codegen), not CPU-emulation noise. Prints both a loop long and a
 * single-op long control so the screen tells the whole story. */

extern int printf();

TMAIN
{
    long r, s;
    int i;

    printf("== LONG-IN-LOOP PROBE ==\n");

    r = 1;
    for (i = 0; i < 4; i++) r = r * 10;      /* want 10000 */
    printf("loop  r=%ld (want 10000)\n", r);

    s = 1; s = s * 10; s = s * 10; s = s * 10; s = s * 10;  /* unrolled control */
    printf("unrol s=%ld (want 10000)\n", s);

    if (r == 10000L) printf("VERDICT: loop OK (emu2-only artifact)\n");
    else             printf("VERDICT: BRIDGE BUG confirmed r=%ld\n", r);
}
