# CP/M-86 C compiler code-quality comparison

Compares the code efficiency (size **and** speed) of the four CP/M-86 C compilers
available in this workspace, optimized for both size and speed where the compiler
supports it. Era-authenticity is explicitly **not** a goal — this measures code
quality only.

## Compilers under test

| # | Compiler | Dialect | Driver | Notes |
|---|----------|---------|--------|-------|
| 1 | **Open Watcom** (v2 fork) | ANSI | `open-watcom-v2/rel/armo64/wcc` | `-os` size / `-otexan` speed; links CP/M-86 via `build/binbuild/bwlink` `format cpm86` |
| 2 | **Aztec C86 3.40a** | K&R | `cpm86-crossdev/bin/aztec34_cc` | DOS-hosted `.exe` under stock `dmsc/emu2` |
| 3 | **Aztec C86 4.2** (4.10d) | ANSI | `cpm86-crossdev/bin/aztec42_cc` | DOS-hosted `.exe` under stock `dmsc/emu2` |
| 4 | **DR C 1.11** | K&R/C89 | `scratch/rc759-cmd-toolchain/drc-oracle.sh` | genuine DRC.CMD, headless under forked `emu2-cpm86`; default = small, `-b` = large |

DR C is the **genuine** Digital Research C compiler (not the retired owc-drc
Watcom+DR-C-runtime hybrid, which is banned unless explicitly requested).

## Benchmark set (user-selected)

Sieve, Dhrystone, Whetstone, stdcbench, AES-256.

## Metrics

- **Code size**: bytes of machine code the compiler emitted for the benchmark
  function(s). Read from each toolchain's own dumper — Intel OMF CODE-class
  segment length (`omfsize.py`) for Watcom & DR C (DR C also self-reports
  `code: N` from its code-gen pass); Manx object "Block start, ends @ NNNN"
  extent (`aztecNN_obd`) for Aztec. Compilation only, no link/run.
- **Speed**: cycle-accurate on **MAME rc759** (CP/M-86), via the done-signal
  harness. Requires each compiler to emit a runnable `.CMD`. (Pending per cell.)

---

## Results

### Sieve — code size (VERIFIED 2026-08-17)

`sieve()` machine-code bytes, small memory model unless noted. Reproduce with
`./measure-sieve.sh`.

| Compiler | opt | code bytes |
|----------|-----|-----------:|
| **Open Watcom** | `-os` (size) | **72** |
| Open Watcom | `-otexan` (speed) | 74 |
| Aztec C86 4.2 | default | 110 |
| Aztec C86 3.40a | default | 112 |
| DR C 1.11 | small (default) | 121 |
| DR C 1.11 | large (`-b`) | 151 |

**Finding (size):** Open Watcom is by far the densest on this kernel (72 B,
~35% smaller than Aztec, ~40% smaller than DR C small). Aztec 4.2 edges 3.40 by
2 B. DR C small is the largest of the small-model set; its large model adds 30 B
(far data addressing of `flags[]`). Watcom's size vs speed tuning barely moves
this kernel (72 vs 74 B).

Caveats: DR C 1.11 has no optimizer switch (single fixed code-gen). Aztec's `sqz`
optimizer is not yet wired into the measurement (numbers are default code-gen).
Models are each compiler's natural default (Watcom/Aztec small, DR C reported for
both) — noted rather than forced identical.

### Pending cells

| Benchmark | size | speed |
|-----------|------|-------|
| Sieve | ✅ done (above) | ⬜ MAME rc759 (all four → .CMD) |
| Dhrystone | ⬜ | ⬜ |
| Whetstone | ⬜ (float libs per compiler) | ⬜ (Watcom baseline exists) |
| stdcbench | ⬜ | 🟡 DR C=13, Watcom=20 measured earlier; Aztec pending |
| AES-256 | ⬜ (port kernel to CP/M-86) | ⬜ |

Refinements to add: Aztec `sqz` optimizer variant; a genuine DR C stdcbench
column (not the owc-drc hybrid); AES-256 kernel ported to the K&R/C89 subset.

## Files

- `sieve.c` — the portable K&R/C89 Byte sieve (one source, all four compilers).
- `omfsize.py` — Intel OMF CODE-segment byte counter (Watcom & DR C).
- `measure-sieve.sh` — compiles sieve.c with all four and prints the size table.
