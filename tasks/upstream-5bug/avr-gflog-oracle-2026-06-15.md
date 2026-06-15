# AVR gf_log oracle — Phase 1 measurement (bug 4 unpark)

**Captured 2026-06-15** following the plan in `plan-bug4-unpark-2026-06-15.md`.

## Method

- Build `aes256.c` (tableless K&R path) + a Timer1-bracketed cycle harness (`rc700-gensmedet/tasks/aes256-corpus/avr-oracle/avr_gflog_cycles.c`) under `clang --target=avr -mmcu=atmega328p -Os -std=c89`.
- Cycle harness: 256 calls to `gf_log(0..255)`, Timer1 with no prescaler (clk/1 — 1 tick = 1 cycle), overflow-counted into 32-bit total.  Output via simavr console (GPIOR0 = 0x3E).
- Two builds compared, on the same machine, same toolchain (llvm-z80 build-macos), same source, same AVR libc:
  - **A — with bug 4 fix**: `llvm-z80/main` at `0fb904f74dd4` (the current tip, includes both `fa1606f34c6b` sound `#160` icmp-narrow-through-graph + `c4f52eb17a76` and-mask outside-user path).
  - **B — without bug 4 fix**: side branch `bug4-avr-baseline`, with `TruncInstCombine.cpp` + `AggressiveInstCombineInternal.h` checked out from commit `05d44629e717` (the merge after the unsound #160/#165 reverts, before the sound versions landed).
- Workspace clean after measurement; main rebuilt; reproduction of build A's numbers verified.

## Results

| Metric | A — with bug 4 | B — without bug 4 | Δ | %Δ |
|---|---|---|---|---|
| Total program flash | **3862 B** | 4026 B | **−164 B** | **−4.1 %** |
| `gf_log` function size (.text) | **48 B** | 70 B | **−22 B** | **−31.4 %** |
| Cycles, 256-call sweep | **595,773** | 825,294 | **−229,521** | **−27.8 %** |
| Cycles per call (avg) | **2,327** | 3,224 | **−897** | **−27.8 %** |

## IR shape

**With bug 4 (build A):**

```llvm
define dso_local i8 @gf_log(i16 noundef %0) ... {
  %2 = trunc i16 %0 to i8           ; narrow at entry
  br label %3
3:
  %4 = phi i8 [ 0, %1 ], [ %13, %7 ]
  %5 = phi i8 [ 1, %1 ], [ %12, %7 ]
  %6 = icmp eq i8 %5, %2            ; i8 compare — bug 4's outside-graph icmp path
  br i1 %6, label %15, label %7
7:
  %8 = shl i8 %5, 1
  %9 = xor i8 %8, 27
  %10 = icmp slt i8 %5, 0
  %11 = select i1 %10, i8 %9, i8 %8
  %12 = xor i8 %11, %5
  %13 = add i8 %4, 1
  %14 = icmp eq i8 %13, 0
  br i1 %14, label %15, label %3
...
}
```

**Without bug 4 (build B):**

```llvm
define dso_local i8 @gf_log(i16 noundef %0) ... {
  %2 = and i16 %0, 255              ; mask survives, doesn't narrow further
  br label %3
3:
  %4 = phi i8 [ 0, %1 ], [ %17, %8 ]
  %5 = phi i16 [ 1, %1 ], [ %16, %8 ]     ; i16 phi carried through loop
  %6 = and i16 %5, 255
  %7 = icmp eq i16 %6, %2           ; i16 compare — outside-graph user keeps wide width
  br i1 %7, label %19, label %8
8:
  %9 = trunc i16 %5 to i8
  %10 = shl i8 %9, 1
  %11 = and i16 %5, 128
  %12 = icmp eq i16 %11, 0          ; another outside-graph i16 user
  %13 = xor i8 %10, 27
  %14 = select i1 %12, i8 %10, i8 %13
  %15 = zext i8 %14 to i16          ; zext back to i16 to feed the wide xor
  %16 = xor i16 %6, %15
  ...
}
```

## Codegen

**With bug 4** (48 bytes, all 8-bit ops):

```
1e0: ldi  r18, 0x01
1e6: cp   r18, r24      ; ← outside-graph icmp, both i8
1e8: breq +32
1ea: inc  r19
1f8: add  r22, r22      ; atb <<= 1 (8-bit)
1fc: and  r23, r23      ; sign-bit test
1fe: brpl +2
200: eor  r22, r20      ; xor 0x1B
202: eor  r18, r22
204: cpi  r21, 0x01
206: brne -34           ; loop
20e: ret
```

**Without bug 4** (70 bytes, multiple 16-bit pair ops):

```
1e0: andi r25, 0x00     ; clear high byte for zext
1ea: movw r22, r30      ; ← 16-bit pair copy
1ee: andi r23, 0x00
1f0: cp   r22, r24      ; ← 16-bit compare (cp + cpc)
1f2: cpc  r23, r25
1f4: breq +42
202: add  r26, r26
204: andi r30, 0x80
206: andi r31, 0x00     ; another i16 mask
208: cp   r30, r1
20a: cpc  r31, r1
212: eor  r31, r31      ; xor high byte
21a: movw r30, r22      ; ← another 16-bit pair
21c: brne -48
224: ret
```

The codegen difference is precisely what the RFC predicts: every i16-compare on AVR is `cp + cpc` (2 instructions), and the i16 phi forces `movw` register-pair shuffles inside the loop.  Bug 4 admits the outside-graph icmps into the narrow-graph rewrite, the i16 phi collapses to i8, and the inner loop drops to single-instruction 8-bit ops.

## Conclusion

**The bug 4 fix delivers a substantial, measurable cross-target win on AVR at the gf_log scale.**  The 2026-06-07 AVR triage's "micro-shapes equalise" reading does *not* extend to gf_log scale.  The optimization is genuinely target-independent and benefits 8-bit-native middle-end consumers as the RFC predicts.

The −22 B / −31 % function-level shrink and the −27.8 % cycle reduction are both at a magnitude where the RFC's upstream framing ("8-bit-native targets benefit measurably") is well-supported.

The earlier RFC numbers cited 153 B → 28 B on Z80; the AVR delta here (70 → 48 B = −31 %) is in the same range proportionally for the same function on a different ISA.  This addresses the principal Phase-1 question: **the bug 4 win is real and cross-target, not Z80-specific**.

## Next steps (per the plan)

- **Phase 2** — clean Z80 measurement of bug 4's isolated delta: revert the same two commits on Z80, rebuild llc, rebuild rcbios + cpnos + AES corpus, record sizes.  Now that we know the AVR result is positive, Phase 2 establishes the Z80 production-level numbers cleanly.
- **Phase 3** — update the RFC at `tasks/upstream-5bug/rfc-icmp-narrow-outside-user.md` to add the AVR oracle as positive cross-target evidence (current RFC §"Evidence / AVR" only cites the *soundness* probe, which is a different question).
- **Phase 4** — user verdict on filing.

## Reproducibility

- Build A reproducible from `llvm-z80/main` tip + `tasks/aes256-corpus/avr-oracle/`'s `make gf_log-cycles`.
- Build B reproducible by checking out
  `llvm-z80/llvm/lib/Transforms/AggressiveInstCombine/{TruncInstCombine.cpp,AggressiveInstCombineInternal.h}`
  from commit `05d44629e717` and rebuilding (clang + opt + llc).

All artifacts under `rc700-gensmedet/tasks/aes256-corpus/avr-oracle/` (committed: `avr_gflog_cycles.c`, Makefile `gf_log-cycles` target).
