---
name: project_autoload_2kb_progress
description: autoload-in-c PROM 2KB recovery work — progress log, current size, what's left
metadata:
  type: project
---

## Status (2026-10-09, afternoon)

PROM: **2142 B / 2048 B cap** — 94 B over. Was 2217 B at session start,
2444 B at morning start.

Active branch: `autoload-2kb-recovery-20261009` in llvm-z80 repo.
Four unpushed commits since 883ff9c3 (`+shadow-isr`).

**Why:** Hard 2 KB cap (no A11 address bridge on user's RC702 hardware).

## Afternoon session wins (−75 B total)

| Change | commit | PROM delta |
|---|---|---|
| CP (HL) fold (COMPARE8_IND pseudo + GR16_HL class) | 605546e | −5 B |
| NonReentrant: selective callsExternalNode (databaseret, ikke særregel) | 605546e | −28 B |
| NonReentrant: run unconditionally, check per-function +static-frame | 58245c2 | 0 B (LTO never panned out — ld.lld's LTO pipeline doesn't call addIRPasses) |
| Assembly `delay()` replaces `optnone` C version | 144b1b8 | −13 B |
| LOAD8_ABS/STORE8_ABS fold (3 B direct vs 4 B via BC/DE) | d6658ad | −29 B |

Firmware-side changes: `-flto` tried + abandoned (ld.lld skip addIRPasses →
no NonReentrant → +62 B); linker script converted to wildcard patterns anyway
(better for LTO-ready future); `__no_recurse` on `delay` declaration.

## Verification

- MAME: CP/M 2.2 rel.2.3 boots to `A>` in 3.5 s emulated.
- sw1-test PASS (banner + SW1 bits + QR on screen).
- lit suite 153/153 PASS (three tests updated to accept the new better
  codegen: `global-offset-address.ll`, `interrupt.ll`,
  `trunc-global-address-byte.ll`).

## Remaining 94 B gap — candidates in order of likely yield

1. **OR/AND/XOR/ADD/SUB (HL) fold** (analogous to CP (HL)): ~3-10 B.
   Three concrete sites in autoload (`drive_select`/`is_mfm`/`disk_type`
   ALU-after-load). Pattern: `ld a,(nn); ld c,a; ld a,b; or c` (6 B)
   → `ld a,b; ld hl,nn; or (hl)` (5 B). Issue to be filed on
   ravn/llvm-z80 (missed-optimization, not a bug).

2. **compiler-rt `memset`/`memcpy` IX frames**: last two IX-frame uses.
   Scope: compiler-rt/lib/builtins/z80/{memset,memcpy}.asm hand-written —
   not relevant to the compiler. Unlikely to help much; the frame is
   only ~8 B total and these builtins are tiny.

3. **Source-level reorganization**: FDC functions still have modest spills
   via static frames. Unlikely to yield >10 B without redesign.

## Architecture insight

The `+shadow-isr` feature (see [[reference_shadow_isr_feature]]) is needed in
autoload's Makefile because main code never uses EXX. rcbios/cpnos Makefiles do NOT
get this flag.

## LTO on autoload — why it didn't work (2026-10-09)

`ld.lld`'s LTO backend has its own pass pipeline (via `lto::LTO::run()`) and
does NOT invoke `Z80PassConfig::addIRPasses` where the NonReentrant pass is
registered. Result: compiling with `-flto -c rom.c` produced LLVM IR that
`ld.lld` later turned into machine code without ever running NonReentrant.
All FDC functions kept IX dynamic frames (14 total; 0 with per-file compile).
Net LTO size: 2233 B (vs 2171 B non-LTO = +62 B regression).

Fix would require registering NonReentrant via the LTO pass registry or
building a ModulePass that integrates with the new PM. Deferred — the gain
would be marginal relative to the complexity, and ld.lld + plug-in-API
integration is non-trivial.

## Key comparison: c863c55 baseline

c863c55 compiler commit (llvm-z80 repo) produced autoload at 2034 B with no
static frames (`+static-frame` was silently ignored). Current with full
static frame support + CP(HL) + LOAD8_ABS is 2142 B.

The 108 B gap vs c863c55 is roughly: new features added (banner, SW1 line,
QR = ~168 B intentional growth) minus compiler-side improvements we've
landed this session.
