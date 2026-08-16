/*
 * fw_delay.c — firmware pattern: nested byte-counter do/while loops.
 *
 * Source: autoload-in-c/rom.c delay().  Three nested do{}while(--n) loops
 * all using 'unsigned char' counters.  Classic DJNZ territory — tests whether
 * the compiler back-end uses the Z80 DJNZ instruction for the inner loop.
 *
 * Workload: call delay(4, 8) 200 times = ~200 * 4 * 8 * 256 = ~1.6M inner
 * iterations.  Output checksum prevents dead-code elimination.
 */

#include <stdio.h>

/* volatile barrier so the inner loop is not optimised away */
static volatile unsigned char barrier;

static void fw_delay(unsigned char outer, unsigned char inner)
{
    if (!outer) return;
    do {
        unsigned char mid = inner;
        do {
            unsigned char k = 0;
            do { barrier = k; } while (--k);
        } while (--mid);
    } while (--outer);
}

int main(void)
{
    int i;
    for (i = 0; i < 200; i++)
        fw_delay(4, 8);
    printf("fw_delay done: %u\n", (unsigned)barrier);
    return 0;
}
