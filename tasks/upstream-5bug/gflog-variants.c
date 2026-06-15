/*
 * gf_log variants — probe what source-level change unblocks the
 * TruncInstCombine outside-user bail on stock LLVM (no fork patches).
 *
 * Build: clang --target=avr -mmcu=atmega328p -Os -std=c89 \
 *              -Wno-deprecated-non-prototype \
 *              -c gflog-variants.c -o variants.o
 *        avr-objdump -d variants.o
 *        avr-size --format=berkeley variants.o
 *
 * Measured on baseline (no bug 4) vs main (bug 4 fix landed):
 *   - V0 (K&R baseline) -- compiles to 70 B / 48 B
 *   - V1 (ANSI proto)   -- compiles to ?? B / ?? B (this experiment)
 *   - V2 (cast in icmp) -- compiles to ?? B / ?? B
 *   - V3 (local copy)   -- compiles to ?? B / ?? B
 */

#include <stdint.h>

/* V0 — the original K&R repro. */
uint8_t gf_log_v0(x)
uint8_t x;
{
    uint8_t atb = 1, i = 0, z;
    do {
        if (atb == x) break;
        z = atb; atb <<= 1; if (z & 0x80) atb ^= 0x1b; atb ^= z;
    } while (++i > 0);
    return i;
}

/* V1 — same body, ANSI prototype.  Hypothesis: parameter arrives as
 * i8 directly, no i16 carriage, narrowing succeeds without bug 4. */
uint8_t gf_log_v1(uint8_t x)
{
    uint8_t atb = 1, i = 0, z;
    do {
        if (atb == x) break;
        z = atb; atb <<= 1; if (z & 0x80) atb ^= 0x1b; atb ^= z;
    } while (++i > 0);
    return i;
}

/* V2 — K&R prototype, but cast x to uint8_t in the comparison.
 * Hypothesis: the cast forces the icmp to be i8, eliminating the
 * outside-graph i16 user that triggers the bail. */
uint8_t gf_log_v2(x)
uint8_t x;
{
    uint8_t atb = 1, i = 0, z;
    do {
        if (atb == (uint8_t)x) break;
        z = atb; atb <<= 1; if (z & 0x80) atb ^= 0x1b; atb ^= z;
    } while (++i > 0);
    return i;
}

/* V3 — K&R prototype, but copy x to a local uint8_t before the loop.
 * Hypothesis: SROA+InstCombine establishes the local as i8 early,
 * same effect as V2 but via a different IR path. */
uint8_t gf_log_v3(x)
uint8_t x;
{
    uint8_t xb = x;
    uint8_t atb = 1, i = 0, z;
    do {
        if (atb == xb) break;
        z = atb; atb <<= 1; if (z & 0x80) atb ^= 0x1b; atb ^= z;
    } while (++i > 0);
    return i;
}

/* V4 — ANSI prototype AND replace the bit-test with sign-bit test
 * via cast to int8_t.  Hypothesis: (int8_t)z < 0 forces InstCombine
 * to fold the bit-test as a signed comparison on i8 directly,
 * removing the `and i16 %z, 128` outside-graph and-mask shape. */
uint8_t gf_log_v4(uint8_t x)
{
    uint8_t atb = 1, i = 0, z;
    do {
        if (atb == x) break;
        z = atb; atb <<= 1; if ((int8_t)z < 0) atb ^= 0x1b; atb ^= z;
    } while (++i > 0);
    return i;
}

/* V5 — ANSI prototype AND inline the bit-test as branchless arithmetic.
 * Hypothesis: removing the conditional entirely eliminates any
 * outside-graph user of the in-graph value. */
uint8_t gf_log_v5(uint8_t x)
{
    uint8_t atb = 1, i = 0, z, m;
    do {
        if (atb == x) break;
        z = atb;
        m = (z & 0x80) ? 0x1b : 0;   /* materialize the mask */
        atb = (atb << 1) ^ m ^ z;
    } while (++i > 0);
    return i;
}

/* V6 — K&R DEFINITION syntax kept, but with a separate ANSI prototype
 * declaration in scope.  Hypothesis: the prototype overrides default-
 * int-promotion at the call site (parameter arrives as i8 in IR), but
 * the body still uses K&R's `uint8_t x;` parameter-declaration syntax.
 * Tests whether ANSI's effect can be obtained without abandoning K&R. */
uint8_t gf_log_v6(uint8_t);   /* prototype */
uint8_t gf_log_v6(x)            /* K&R definition */
uint8_t x;
{
    uint8_t atb = 1, i = 0, z;
    do {
        if (atb == x) break;
        z = atb; atb <<= 1; if (z & 0x80) atb ^= 0x1b; atb ^= z;
    } while (++i > 0);
    return i;
}

/* V7 — V6 PLUS the sign-bit form for the bit-test.  Combines the v4
 * fix with v6's "keep K&R definition" approach.  Hypothesis: prototype
 * + sign-bit form together fully unblock the narrowing while keeping
 * the K&R definition syntax. */
uint8_t gf_log_v7(uint8_t);
uint8_t gf_log_v7(x)
uint8_t x;
{
    uint8_t atb = 1, i = 0, z;
    do {
        if (atb == x) break;
        z = atb; atb <<= 1; if ((int8_t)z < 0) atb ^= 0x1b; atb ^= z;
    } while (++i > 0);
    return i;
}
