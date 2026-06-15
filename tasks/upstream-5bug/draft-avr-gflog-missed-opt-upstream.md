# [DRAFT — not filed] Upstream issue: AVR missed-opt — TruncInstCombine bails on K&R uint8_t with outside-graph icmp user

**Status:** local draft for user review, 2026-06-15.  Not posted.
**Target venue:** issue at `llvm/llvm-project`, label `missed-optimization`, `backend:AVR`, `llvm:transforms` (AggressiveInstCombine).
**Per [[feedback_explain_before_filing]]:** user gives explicit per-filing go-ahead before this leaves the project.
**Per [[feedback_file_bugs_not_fixes]]:** this is a missed-optimization bug filing — issue body proposes the *direction*, links the cause, includes runtime + size witnesses; does NOT include a fix patch.

---

## Title (one line)

> `[AVR][AggressiveInstCombine]` `TruncInstCombine` bails on whole graph when an outside-graph `icmp` user observes a provably-narrow value — emits 16-bit code for K&R `uint8_t` loops

## TL;DR

On AVR (`atmega328p`, `-Os`), `clang` compiles the K&R-style `gf_log` Galois-field logarithm helper from a public-domain AES-256 implementation to **70 bytes** when **48 bytes** is achievable, and executes ~28 % more cycles than needed on a 256-input sweep.  The cause is the all-or-nothing bail in `TruncInstCombine` (in `lib/Transforms/AggressiveInstCombine/TruncInstCombine.cpp`) when any in-graph value has an outside-graph user that isn't a `ZExt`/`SExt`.  The outside-graph user here is an `icmp eq` whose other operand is the K&R-promoted `uint8_t` parameter — both operands trivially fit the narrow type under KnownBits.

## Reproducer

Standalone, single-file: [`avr-gflog-missed-opt.c`](avr-gflog-missed-opt.c).

```bash
clang --target=avr -mmcu=atmega328p -Os -std=c89 \
      -Wno-deprecated-non-prototype \
      -c avr-gflog-missed-opt.c -o gflog.o
avr-size --format=berkeley gflog.o
avr-objdump -d gflog.o
```

Provenance: extracted verbatim from `gf_log` in Ilya O. Levin's public-domain `aes256.c` (literatecode.com, 2007-2009).  The K&R-style declaration is preserved from the upstream source.

## Observed output (stock LLVM)

```
text    data     bss     dec     hex     filename
  70       0       0      70      46     gflog.o
```

Disassembly (annotations added):

```
00000000 <gf_log>:
   0:  andi r25, 0x00          ; clear high byte for zext
   2:  ldi  r30, 0x01
   4:  ldi  r31, 0x00
   6:  ldi  r20, 0x1B
   8:  mov  r19, r1
   a:  movw r22, r30           ; ← 16-bit register-pair shuffle
   c:  mov  r18, r1
   e:  andi r23, 0x00
  10:  cp   r22, r24           ; ← 16-bit compare (cp + cpc)
  12:  cpc  r23, r25           ;     against the K&R-promoted i16 arg
  14:  breq +42
  ...
  22:  add  r26, r26           ; i8 atb << 1
  24:  andi r30, 0x80
  26:  andi r31, 0x00          ; ← unnecessary i16 mask
  28:  cp   r30, r1            ; ← another 16-bit compare
  2a:  cpc  r31, r1
  ...
  3a:  movw r30, r22           ; ← another 16-bit register-pair shuffle
  3c:  brne -48                ; loop back
  44:  ret
```

## Expected output

```
text    data     bss     dec     hex     filename
  48       0       0      48      30     gflog.o
```

```
00000000 <gf_log>:
   0:  ldi  r18, 0x01
   2:  ldi  r20, 0x1B
   4:  mov  r19, r1
   6:  cp   r18, r24           ; ← 8-bit compare; both operands i8
   8:  breq +32
   a:  inc  r19
   ...
  18:  add  r22, r22           ; ← straight 8-bit shift, no movw
  1a:  mov  r23, r18
  1c:  and  r23, r23
  1e:  brpl +2
  20:  eor  r22, r20           ; xor 0x1B
  22:  eor  r18, r22
  24:  cpi  r21, 0x01
  26:  brne -34
  2e:  ret
```

## IR shape (`clang -emit-llvm -S -Os`)

Stock LLVM produces the form where `TruncInstCombine` bails:

```llvm
define i8 @gf_log(i16 noundef %0) {
  %2 = and i16 %0, 255                  ; ← the K&R promotion's mask survives
  br label %3
3:
  %4 = phi i8 [ 0, %1 ], [ %17, %8 ]
  %5 = phi i16 [ 1, %1 ], [ %16, %8 ]   ; ← i16 phi carried through loop
  %6 = and i16 %5, 255
  %7 = icmp eq i16 %6, %2               ; ← outside-graph user of the graph
  br i1 %7, label %19, label %8
8:
  %9 = trunc i16 %5 to i8
  %10 = shl i8 %9, 1
  %11 = and i16 %5, 128
  %12 = icmp eq i16 %11, 0              ; ← another outside-graph icmp user
  ...
}
```

The graph rooted at the `trunc i16 %5 to i8` *would* narrow except for the outside-graph icmp users (`%7` and `%12`).  Both are width-compatible: `%6` and `%2` are explicitly `and i16 ..., 255` (KnownBits-narrow); `%11` is `and i16 %5, 128` against constant 0 (provably narrow on both sides).

## Expected IR shape

```llvm
define i8 @gf_log(i16 noundef %0) {
  %2 = trunc i16 %0 to i8               ; narrow at entry
  br label %3
3:
  %5 = phi i8 [ 1, %1 ], [ %12, %7 ]    ; i8 phi
  %6 = icmp eq i8 %5, %2                ; i8 compare — narrowed alongside
  ...
}
```

## Runtime cycle witness

A self-contained AVR cycle harness ([`gf_log` 256-call sweep, Timer1
at clk/1 — see `tasks/upstream-5bug/avr-gflog-runtime.c`]) reports:

| | Stock LLVM | Expected (if narrowed) |
|---|---|---|
| Total cycles, 256 sweep | **825,294** | **595,773** |
| Cycles per call (avg) | **3,224** | **2,327** |

Delta: **−229,521 cycles (−27.8 %)**.

(For comparison: the analogous `gf_log` on Z80 with our out-of-tree backend also shows the win — 70 B → 48 B is mirrored at proportional scale on a different ISA, suggesting the missed-opt is target-independent at the IR level and shows on any 8-bit-native target where C int-promotion of `uint8_t` loops is idiomatic.)

## Cause

In `lib/Transforms/AggressiveInstCombine/TruncInstCombine.cpp` (function `getBestTruncatedType` or its current name), the outside-user iteration over each in-graph instruction's users:

```cpp
for (auto *U : I->users())
  if (auto *UI = dyn_cast<Instruction>(U))
    if (UI != CurrentTruncInst && !InstInfoMap.count(UI)) {
      if (IsExtInst) { ... continue; }
      return nullptr;     // <-- bails here
    }
```

bails the whole graph rewrite when any in-graph value has an outside user that isn't a `ZExt`/`SExt`.  The result is conservative-correct but leaves wins on the floor for the most common idiomatic shape on 8-bit-native targets: a `uint8_t` arithmetic loop whose only escape is a comparison.

## Direction (not a patch)

Admit the outside-graph user when:

1. it is an `ICmpInst`, and
2. both operands provably fit in the narrow width under KnownBits (and the predicate is value-preserving at the narrow width — eq/ne always; unsigned predicates when both `getMaxValue().getActiveBits() <= NarrowBits`; samesign-signed when both `<= NarrowBits − 1` so the sign bit stays clear at the narrow width).

Rewrite the admitted icmp as `icmp <pred> (trunc lhs to NarrowTy), (trunc rhs to NarrowTy)` before the phi-erase loop.

Soundness boundary: the graph-side KnownBits check is *load-bearing*.  Without it the narrowed icmp can disagree with the wide icmp when the source value has high bits set.  Concrete witness: an out-of-tree extension we carried for ~6 weeks omitted the in-graph KnownBits check and produced wrong results on `%add = add i32 %x, 1; icmp ult i32 %add, (and y, 255)` when `%x = 65636` (low 16 bits of `%add` = 100 < 200 but full `%add` = 65637 > 200).  Witnesses are in our out-of-tree lit suite at `llvm/test/Transforms/AggressiveInstCombine/trunc-narrow-icmp-graph-side-soundness.ll` (304 lines) — happy to share if useful for upstream review.

A parallel direction admits outside-graph `(and X, Const)` users where `Const` fits the narrow type — sound regardless of in-graph KnownBits because the mask consumes high bits unconditionally.  Covered by the same out-of-tree lit suite.

## Notes for reviewers

- We carry both directions as out-of-tree extensions (sound versions; commits `fa1606f34c6b` and `c4f52eb17a76` on `llvm-z80/llvm-z80` — happy to extract diffs / lit tests / runtime witnesses on request).
- The optimization fires on AVR / Z80 / MSP430 in idiomatic embedded-C cryptographic and protocol-parser code where `uint8_t` arithmetic is carried through int-promoted `i16` phis.
- This is not a Z80-only issue.  AVR shows clean cross-target evidence (this report).  The pass is target-independent middle-end and the bail is target-independent too.
- We are filing this AVR-targeted report independently of any Z80 RFC because the AVR repro is self-contained and the AVR codegen evidence is concrete enough to stand alone.

## Provenance + acknowledgements

- Reproducer derived from Ilya O. Levin's public-domain AES-256 (literatecode.com, 2007-2009).
- Out-of-tree Z80 backend: `https://github.com/llvm-z80/llvm-z80` (fork of LLVM, experimental).

---

## What to check before posting (internal-use, not part of the issue body)

- [x] **Verify bug is not fixed upstream** (2026-06-15):
  - Source code on `llvm/llvm-project/main` (`llvm/lib/Transforms/AggressiveInstCombine/TruncInstCombine.cpp`) still has the all-or-nothing bail: `if (!IsExtInst) return nullptr;` at the outside-user iteration in `getBestTruncatedType`.  Unchanged.
  - No open PRs touch `TruncInstCombine.cpp` at all.
  - Only open TruncInstCombine-related issue is `#202112` — our own previously-filed bug 2 (argument-leaf narrowing), which targets a different code path.
  - Last functional commit to the file was 2025-10-09 (`profcheck` profile-metadata propagation); the bail logic has been untouched for ~8 months.
- [ ] Build the repro with stock LLVM tip-of-tree clang to confirm the 70-byte / 825K-cycle baseline reproduces end-to-end (we've verified against our out-of-tree fork's reverted-to-baseline state, and source-checked upstream to confirm the relevant code is identical; an empirical end-to-end run is belt-and-braces).
- [ ] Confirm the AVR pass pipeline matches what stock LLVM runs at `-Os` for `--target=avr -mmcu=atmega328p`.
- [ ] Confirm an `llvm/llvm-project` issue under `missed-optimization + backend:AVR + llvm:transforms` is the right venue (vs Discourse RFC).
- [ ] Decide whether to include the runtime cycle witness in the issue body, link it, or leave it out (it strengthens the report but adds setup cost for the reviewer).
- [ ] User go-ahead per `feedback_explain_before_filing` before filing.
