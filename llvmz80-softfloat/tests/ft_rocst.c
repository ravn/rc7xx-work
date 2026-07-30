/* ft_rocst.c -- regression test for the ".rodata.cstN -> SECTION IGNORE"
 * bridge bug in z88dk/lib/llvmz80/llvmz80_rules.1.
 *
 * clang places a fully-constant, power-of-2-sized read-only array
 * (here static const double hi[4] = 32 bytes) in the mergeable constant
 * section `.section .rodata.cst32`.  The llvm-z80 -> z80asm copt bridge had
 * no rule for `.rodata.cstN`, so it fell through to the
 * `.section %1 -> SECTION IGNORE` catch-all and the initialiser bytes were
 * DROPPED from the binary.  At runtime the array read back as all-zero, so a
 * runtime-indexed element returned 0.0 instead of its constant.  This is what
 * made musl atan()/exp()/log() (which index static const coefficient tables)
 * return 0 on Z80.
 *
 * Bug reproduced with concrete values: hi[1] must read 20.0, whose IEEE-754
 * top 16 bits are 0x4034 = 16436.  Before the fix pick(1) returned 0.0 -> 0;
 * after the fix it returns 20.0 -> 16436.
 *
 * Self-contained: the sret return is an 8-byte memmove and the check is
 * integer bit extraction, so NO soft-float closure is required to link.
 * noinline forces a real sret call boundary (the inlined form sidesteps the
 * dropped section and would mask the bug).
 *
 * Expected output: ROCST 16436 16420   (hi[1]=20.0 -> 0x4034 ; hi[0]=10.0 -> 0x4024)
 */
#include <stdio.h>
#include <stdint.h>

static const double hi[] = { 10.0, 20.0, 30.0, 40.0 };
volatile int one = 1, zero = 0;

__attribute__((noinline)) static double pick(int s) {
    int id;
    if (s == 0) id = 0; else id = 1;   /* branch-computed index */
    return hi[id];
}

static unsigned top16(double d) {
    union { double d; uint64_t u; } v; v.d = d;
    return (unsigned)(v.u >> 48);
}

int main(void) {
    printf("ROCST %u %u\n", top16(pick(one)), top16(pick(zero)));
    return 0;
}
