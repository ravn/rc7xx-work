/*
 * avr-minimal-repro-DEAD-END.c — DEAD END attempt at reducing the
 * gf_log repro to something simpler.
 *
 * DOES NOT reproduce the bug.  Kept for the record so future
 * minimisation attempts don't repeat this dead end.
 *
 * 2026-06-15: built with both fork main (bug 4 fix landed) AND the
 * baseline state (TruncInstCombine reverted to 05d44629e717,
 * pre-sound-version).  RESULT: byte-identical 28-byte output for
 * both f_knr and f_ansi on BOTH states.  The narrowing here fires
 * WITHOUT bug 4 — argument-leaf narrowing (`#158`, a separate
 * extension) handles this shape alone.
 *
 * Why this shape isn't a bug 4 reduction: the simplified body
 *   do { ... while (atb != x); return atb;
 * has the icmp `atb != x` as the sole outside-graph user, AND the
 * trunc graph's root happens to be the function's return.  Bug 2
 * (argument-leaf) narrows the i16 parameter `x` to i8 at function
 * entry, and the trunc graph collapses through the return with the
 * outside-graph icmp incidentally narrowed by InstCombine on the
 * already-narrow operands.
 *
 * For the bug 4 path to fire, the trunc graph must have an
 * outside-graph user that:
 *   - is not a ZExt/SExt to the destination type, AND
 *   - sits in a position where InstCombine sees a wide outside
 *     operand at the time TruncInstCombine runs, AND
 *   - is not catchable by argument-leaf narrowing alone
 *
 * The gf_log helper (see avr-gflog-missed-opt.c) satisfies this
 * because:
 *   - `atb == x` is an in-loop break check, not the loop terminator
 *   - the `i` counter is a SEPARATE i8 phi whose interaction with
 *     `atb` keeps the trunc graph rooted at the return path
 *   - the trunc graph spans the entire loop body
 *
 * Removing any of these (the counter, the in-loop break, the
 * separate phi structure) folds via bug 2 alone — which is what
 * happens below.
 *
 * Net: avr-gflog-missed-opt.c IS the minimal repro at 32 lines.
 * That's the floor for this missed-opt class.
 *
 * --- original (incorrect) framing follows ---
 *
 * Build: clang --target=avr -mmcu=atmega328p -Os -std=c89 \
 *              -Wno-deprecated-non-prototype \
 *              -c avr-minimal-repro.c -o min.o
 *        avr-objdump -d min.o
 *
 * Two paired functions with bodies designed to mirror the K&R
 * AES gf_log loop shape:
 *   - f_knr  : K&R declaration; x default-promotes to int (i16);
 *              the loop body operates on `uint8_t acc` but the
 *              comparison `acc == x` is the outside-graph icmp
 *              whose KnownBits-narrow proof admits narrowing.
 *   - f_ansi : ANSI prototype with explicit uint8_t parameter;
 *              the i16 carriage never appears.
 *
 * Stock LLVM observation (clang --target=avr -mmcu=atmega328p -Os,
 * 2026-06-15): f_knr emits 16-bit register-pair operations
 * (cp+cpc compares, movw shuffles, paired AND masks) inside the
 * loop; f_ansi emits straight 8-bit ops.  Size delta between the
 * two forms is the missed-opt.
 *
 * Cause: TruncInstCombine bails the whole graph rewrite when an
 * in-graph value has an outside-graph user that isn't a ZExt/SExt.
 * Here the outside-graph icmp `acc == x` (and the helper bit-test
 * `z & 0x80`) gate the narrowing of the phi-rooted graph.  Both
 * outside operands are KnownBits-narrow (icmp's `x` is K&R-
 * promoted from uint8_t — `and y, 255` shape; the and-mask 0x80
 * trivially fits the narrow type).
 *
 * Provenance: structurally identical to the K&R gf_log helper in
 * Ilya O. Levin's public-domain AES-256 (literatecode.com,
 * 2007-2009), with the iteration counter dropped so the shape
 * fits in a small repro.
 */

#include <stdint.h>

uint8_t f_knr(x)
uint8_t x;
{
    uint8_t atb = 1, z;
    do {
        if (atb == x) break;          /* outside-graph icmp eq */
        z = atb;
        atb <<= 1;
        if (z & 0x80) atb ^= 0x1b;    /* outside-graph and-mask */
        atb ^= z;
    } while (1);
    return atb;
}

uint8_t f_ansi(uint8_t x)
{
    uint8_t atb = 1, z;
    do {
        if (atb == x) break;
        z = atb;
        atb <<= 1;
        if (z & 0x80) atb ^= 0x1b;
        atb ^= z;
    } while (1);
    return atb;
}
