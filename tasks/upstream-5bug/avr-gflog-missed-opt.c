/*
 * avr-gflog-missed-opt.c — standalone repro for an LLVM AVR
 * missed-optimization in TruncInstCombine (AggressiveInstCombine).
 *
 * Reduce: clang --target=avr -mmcu=atmega328p -Os -std=c89 \
 *               -Wno-deprecated-non-prototype \
 *               -c avr-gflog-missed-opt.c -o gflog.o
 *
 * Observed (stock LLVM main, 2026-06-15):
 *
 *   avr-size --format=berkeley gflog.o   →  text ~70 B
 *   avr-objdump -d gflog.o               →  multiple `cp + cpc` 16-bit
 *                                            compares, `movw` register-pair
 *                                            shuffles inside the loop.
 *
 * Expected (if the narrowing fired correctly):
 *
 *   avr-size --format=berkeley gflog.o   →  text ~48 B
 *   avr-objdump -d gflog.o               →  single 8-bit `cp` compare,
 *                                            no `movw`, pure r18-r25
 *                                            register-direct ops.
 *
 * Cycle impact (Timer1 at clk/1, 256-call sweep, atmega328p, simavr):
 *
 *   observed:  825,294 cycles  (avg 3,224 cycles per gf_log call)
 *   expected:  595,773 cycles  (avg 2,327 cycles per gf_log call)
 *   delta:     −229,521 cycles  (−27.8 %)
 *
 * IR shape (`clang -emit-llvm -S` snippet, current LLVM main):
 *
 *   define i8 @gf_log(i16 noundef %0) {
 *     %2 = and i16 %0, 255              ; ← mask survives, doesn't narrow
 *     br label %3
 *   3:
 *     %5 = phi i16 [ 1, %1 ], [ %16, %8 ]  ← i16 phi carried through loop
 *     %6 = and i16 %5, 255
 *     %7 = icmp eq i16 %6, %2           ; ← outside-graph icmp user
 *     ...
 *   }
 *
 * Expected shape (if TruncInstCombine admitted the outside-graph icmp
 * users when both operands are provably narrow under KnownBits):
 *
 *   define i8 @gf_log(i16 noundef %0) {
 *     %2 = trunc i16 %0 to i8           ; narrow at entry
 *     br label %3
 *   3:
 *     %5 = phi i8 [ 1, %1 ], [ %12, %7 ] ; i8 phi
 *     %6 = icmp eq i8 %5, %2            ; i8 compare
 *     ...
 *   }
 *
 * Cause: `TruncInstCombine` (in `llvm/lib/Transforms/AggressiveInstCombine/
 * TruncInstCombine.cpp`) bails the whole graph rewrite when ANY in-graph
 * value has an outside-graph user that isn't a `ZExt`/`SExt` to the narrow
 * type.  That blanket bail forfeits substantial wins on 8-bit-native
 * targets (AVR, MSP430, 6502, Z80) where the C `int` promotion of
 * `uint8_t` arithmetic typically leaves an icmp at the loop exit that
 * KnownBits can trivially prove narrow.
 *
 * Soundness: a narrow icmp is value-preserving alongside the graph rewrite
 * iff BOTH operands provably fit in the narrow width.  Verify in-graph
 * side via `computeKnownBits(GraphValue).getMaxValue().getActiveBits() <=
 * NarrowBits`.  Verify outside side via the same KnownBits check on
 * constant or single-use variable operands.  Witnesses for the unsound
 * version: an extension carried locally by our out-of-tree Z80 backend
 * skipped the in-graph KnownBits check and produced wrong results when
 * the source value didn't fit (`test_220` / `test_221` / `test_222` in
 * llvm-z80/llvm/test/Transforms/AggressiveInstCombine/
 * trunc-narrow-icmp-graph-side-soundness.ll).  The sound version with
 * the gate works correctly.
 *
 * Provenance: extracted verbatim from the gf_log function in Ilya O. Levin's
 * public-domain AES-256 implementation (literatecode.com, 2007-2009).
 * It's the K&R-style version of the canonical Galois field logarithm
 * helper used in AES S-box computation — appears in many embedded-C
 * cryptographic implementations.
 */

#include <stdint.h>

uint8_t gf_log(x)
uint8_t x;
{
    uint8_t atb = 1, i = 0, z;

    do {
        if (atb == x) break;
        z = atb;
        atb <<= 1;
        if (z & 0x80) atb ^= 0x1b;
        atb ^= z;
    } while (++i > 0);

    return i;
}
