/* Repro: 64-bit (long long) GLOBAL static initializers are truncated to 32 bits
 * under `zcc +cpm -compiler=llvmz80`.  Root cause is the copt rule in
 * z88dk/lib/llvmz80/llvmz80_rules.1 mapping GNU `.quad %1` (8 bytes) to
 * `DEFQ %1 / DEFQ 0`, but z88dk's DEFQ directive is only 4 bytes -> %1 is
 * truncated to its low 32 bits and the true high 32 bits become the padding 0.
 *
 * Build: zcc +cpm -compiler=llvmz80 -Cg-O2 -o quad quad_global_init_truncated.c
 * Run  : python3 scratch/dcc-clang-bench/ticks_cpm.py quad
 *
 * Expected (correct IEEE / two's-complement byte layout):
 *   BIG  0 1074266112     ( 0x4008000000000000 )
 *   SMLL 7 0              ( 0x0000000000000007 )
 *   MID  0 1             ( 0x0000000100000000 )
 *   RUN  0 1074266112     (same value, but assigned at RUN time -> a store)
 * Actual (buggy):
 *   BIG  0 0             <- high 32 bits lost
 *   SMLL 7 0             <- ok (value fits in low 32 bits)
 *   MID  0 0             <- byte at offset 4 lost
 *   RUN  0 1074266112    <- ok (runtime store is unaffected)
 */
#include <stdio.h>
unsigned long long g_big   = 0x4008000000000000ULL;
unsigned long long g_small = 0x0000000000000007ULL;
unsigned long long g_mid   = 0x0000000100000000ULL;
unsigned long long g_run;
static void pr(const char *t, unsigned long long q){
    union { unsigned long long q; unsigned long d[2]; } u; u.q = q;
    printf("%s %lu %lu\n", t, u.d[0], u.d[1]);
}
int main(void){
    pr("BIG ", g_big);
    pr("SMLL", g_small);
    pr("MID ", g_mid);
    g_run = 0x4008000000000000ULL;
    pr("RUN ", g_run);
    return 0;
}
