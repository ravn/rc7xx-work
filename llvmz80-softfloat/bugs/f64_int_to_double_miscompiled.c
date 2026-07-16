/* f64_int_to_double_miscompiled.c
 *
 * ravn/llvm-z80 backend miscompile: `(double)int` (the __floatsidf soft-float
 * libcall) returns a CORRUPT double on Z80, while literal doubles and other
 * f64-returning shims (__adddf3 etc.) are correct.  Blocks `double` under
 * `zcc +cpm -compiler=llvmz80` + the Berkeley-SoftFloat closure.
 *
 * See bugs/f64_int_to_double_miscompiled.md for full diagnosis, controls,
 * and the exact red re-verify recipe.
 *
 * Output is emitted ONLY through the non-variadic npf_snprintf_f("%f", d)
 * formatter -- deliberately NOT variadic printf, to avoid the separate
 * ravn/llvm-z80#270 broken-va_start confounder.
 *
 * Observed (verified 2026-07-17, zcc+cpm+llvmz80, z88dk-ticks):
 *   conv5|131074.500000   <-- (double)5  WRONG, want 5.000000
 *   conv2|65537.000000    <-- (double)2  WRONG, want 2.000000
 *   lit5 |5.000000        <-- literal 5.0  CORRECT (control)
 *   div  |2.000008        <-- 5.0/2.0    WRONG, want 2.500000 (poisoned operands)
 *   dm   |2000.007629     <-- /*1000     WRONG, want 2500     (poisoned operands)
 *
 * The value is invariant across THIS TU's -O0/-O1/-O2 (the fault is in the
 * shared int->f64 path, not the caller's own codegen).  The i32_to_f64 core
 * algorithm is correct on the host (bits 0x4014000000000000 for 5).
 */
#include <stdio.h>
#include "npf_cpm.h"

static char b[96];

static void show(const char *tag, double v){
    npf_snprintf_f(b, sizeof b, "%f", v);   /* non-variadic: avoids #270 */
    printf("%s|%s\n", tag, b);
}

int main(void){
    volatile int five = 5, two = 2;   /* volatile: force a real runtime int */
    double a = (double)five;          /* __floatsidf(5) -> should be 5.0     */
    double c = (double)two;           /* __floatsidf(2) -> should be 2.0     */

    show("conv5", a);                 /* expect 5.000000     -- gets 131074.500000 */
    show("conv2", c);                 /* expect 2.000000     -- gets  65537.000000 */
    show("lit5",  5.0);               /* CONTROL: literal    -- correct 5.000000   */
    show("div",   a / c);             /* expect 2.500000     -- gets 2.000008       */
    show("dm",    a / c * 1000.0);    /* expect 2500.000000  -- gets 2000.007629    */
    return 0;
}
