/* ft_i2d.c -- regression oracle for int->double (__floatsidf) via LOSSLESS %f.
 *
 * WHY THIS EXISTS (ravn/llvm-z80#273):
 *   Our softfloat config once set -DSOFTFLOAT_BUILTIN_CLZ with 32-bit-int
 *   assumptions, so softfloat_countLeadingZeros32 lowered to __builtin_clz,
 *   which on clang-z80 (`int` = 16-bit) counts only 16 bits -> shiftDist in
 *   i32_to_f64 was 16 too small -> (double)5 formatted as 131074.500000.
 *
 *   The pre-existing ft_dbl test DID call __floatsidf ((double)-42) but only
 *   OBSERVED it through (long)di == __fixdfsi -- a LOSSY truncation that happened
 *   to recover -42 from the corrupt double, so it never caught the bug.  The
 *   lesson: an int->double oracle must observe the FULL value (a %f string),
 *   not a truncation, or a factor-of-2^16 corruption slips through.
 *
 * This test converts real runtime ints/longs to double and formats each with
 * nanoprintf's variadic npf_snprintf("%f", ...) -- the lossless path that
 * exposes the bug.  Values span several clz(absA) buckets so a wrong shiftDist
 * shows up.  Built for host (native clang+stdio) and Z80 (zcc+cpm+llvmz80);
 * both must match tests/ft_i2d.expected byte-for-byte.
 * (Previously used non-variadic npf_snprintf_f to avoid ravn/llvm-z80#270;
 * removed 2026-07-21 now that va_start works via z88dk bb914a18.)
 */
#include <stdio.h>
#include "npf_cpm.h"

static char buf[96];

static void show(const char *tag, double v)
{
    npf_snprintf(buf, sizeof buf, "%f", v);
    printf("%s|%s\n", tag, buf);
}

int main(void)
{
    /* volatile forces a genuine runtime __floatsidf call (no constant-fold). */
    volatile int  i1 = 1, i2 = 2, i5 = 5, i100 = 100, in42 = -42, i32767 = 32767;
    volatile long l70000 = 70000L, ln100000 = -100000L;

    show("i1",     (double)i1);        /* 1.000000                */
    show("i2",     (double)i2);        /* 2.000000  (was 65537)   */
    show("i5",     (double)i5);        /* 5.000000  (was 131074.5)*/
    show("i100",   (double)i100);      /* 100.000000              */
    show("in42",   (double)in42);      /* -42.000000              */
    show("i32767", (double)i32767);    /* 32767.000000            */
    show("l70000", (double)l70000);    /* 70000.000000  (>16-bit) */
    show("ln100k", (double)ln100000);  /* -100000.000000          */

    /* arithmetic on int-derived operands: 5/2 = 2.5 (poisoned before the fix) */
    show("div52",  (double)i5 / (double)i2);   /* 2.500000 */
    return 0;
}
