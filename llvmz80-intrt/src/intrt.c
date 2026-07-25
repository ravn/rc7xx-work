/* intrt.c -- minimal compiler-rt integer runtime for zcc +cpm -compiler=llvmz80.
 *
 * The llvm-z80 + z88dk toolchain ships NO compiler-rt: any 32-bit multiply or
 * 64-bit multiply/divide/mod is emitted as a libcall that is then undefined at
 * link. Verified missing symbols (2026-07-15):
 *     __mulsi3  __muldi3  __divdi3  __moddi3  __udivdi3   (leading '_' -> '___' in asm)
 * (32-bit signed/unsigned divide+mod __divsi3/__udivsi3/__modsi3/__umodsi3 and
 *  16-bit multiply DO link, so they are intentionally not reimplemented here.)
 *
 * Everything here is built from shift/add/subtract/compare only -- no call to
 * any other multiply/divide helper -- so the object has zero libcall deps and
 * cannot recurse into itself. 64-bit add/shift/compare DO link on this target.
 *
 * Correctness proven by the host self-test (-DINTRT_SELFTEST, native 64-bit
 * oracle) and an on-target ticks fixture (tests/ft_int.c). See tests/run.sh.
 */
#include <stdint.h>

/* ---- 32-bit multiply (low word) --------------------------------------- */
/* __mulsi3 now lives in its own TU (intrt_mulsi3.c) so the packaged archive
 * can share __mulsi3 with newlib's llvmz80_imath.lib without a duplicate
 * definition -- see intrt_mulsi3.c.  Declared here for the self-test below;
 * builds/links that want it must also compile intrt_mulsi3.c. */
extern uint32_t __mulsi3(uint32_t a, uint32_t b);

/* ---- 64-bit multiply (low 64 bits; same bits signed or unsigned) ------- */
uint64_t __muldi3(uint64_t a, uint64_t b)
{
    uint64_t r = 0;
    while (b) { if (b & 1u) r += a; a <<= 1; b >>= 1; }
    return r;
}

/* ---- 64-bit unsigned divide+remainder (restoring long division) -------- */
/* rem may be NULL. Classic bit-at-a-time: pull bits of n from the top into a
 * running remainder r, subtract d when it fits, set the matching quotient bit.
 * Worked example n=20 (0b10100), d=3: after 64 steps q=6, r=2 (20 = 3*6 + 2). */
static uint64_t udivmod64(uint64_t n, uint64_t d, uint64_t *rem)
{
    uint64_t q = 0, r = 0;
    if (d == 0) { if (rem) *rem = 0; return ~(uint64_t)0; } /* UB; avoid trap */
    for (int i = 63; i >= 0; i--) {
        r = (r << 1) | ((n >> i) & 1u);
        if (r >= d) { r -= d; q |= (uint64_t)1 << i; }
    }
    if (rem) *rem = r;
    return q;
}

uint64_t __udivdi3(uint64_t n, uint64_t d) { return udivmod64(n, d, 0); }
uint64_t __umoddi3(uint64_t n, uint64_t d) { uint64_t r; udivmod64(n, d, &r); return r; }

/* ---- 64-bit signed divide / mod (sign-magnitude around the unsigned core) */
static uint64_t abs64(int64_t x) { return x < 0 ? -(uint64_t)x : (uint64_t)x; }

int64_t __divdi3(int64_t a, int64_t b)
{
    uint64_t q = udivmod64(abs64(a), abs64(b), 0);
    return ((a < 0) ^ (b < 0)) ? -(int64_t)q : (int64_t)q;
}

int64_t __moddi3(int64_t a, int64_t b)   /* result takes the sign of a (C99) */
{
    uint64_t r;
    udivmod64(abs64(a), abs64(b), &r);
    return (a < 0) ? -(int64_t)r : (int64_t)r;
}

#ifdef INTRT_SELFTEST
/* Host build: check the cores against native 64-bit arithmetic over many
 * values (native ops are the oracle here only, never used on Z80). */
#include <stdio.h>
#include <stdlib.h>
static uint64_t rnd64(void)
{
    uint64_t x = 0;
    for (int i = 0; i < 4; i++) x = (x << 16) ^ (uint16_t)rand();
    return x;
}
int main(void)
{
    unsigned long trials = 2000000, bad = 0;
    srand(1);
    for (unsigned long i = 0; i < trials; i++) {
        uint32_t a32 = (uint32_t)rnd64(), b32 = (uint32_t)rnd64();
        if (__mulsi3(a32, b32) != (uint32_t)(a32 * b32)) {
            if (bad < 5) printf("MULSI %u*%u\n", a32, b32); bad++;
        }
        uint64_t a = rnd64(), b = rnd64();
        if (__muldi3(a, b) != (uint64_t)(a * b)) { if (bad<5) printf("MULDI\n"); bad++; }
        uint64_t d = b ? b : 1;
        if (__udivdi3(a, d) != a / d) { if (bad<5) printf("UDIV\n"); bad++; }
        if (__umoddi3(a, d) != a % d) { if (bad<5) printf("UMOD\n"); bad++; }
        int64_t sa = (int64_t)a, sd = (int64_t)d;
        if (__divdi3(sa, sd) != sa / sd) { if (bad<5) printf("DIV\n"); bad++; }
        if (__moddi3(sa, sd) != sa % sd) { if (bad<5) printf("MOD\n"); bad++; }
    }
    printf("trials=%lu  bad=%lu\n", trials, bad);
    return bad ? 1 : 0;
}
#endif
