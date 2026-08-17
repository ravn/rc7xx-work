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
- **Floating-point model**: RC759 has **no 8087**, so float benchmarks use
  **software floating point** for all four (calls, not inline 8087) — this is the
  default for DR C 1.11 and Aztec C86, and is forced on Open Watcom with `-fpc`
  (its default `-fpi` inlines 8087, which is ~28% smaller but not RC759-valid and
  not comparable to the software-FP compilers). `-fpc` has no effect on integer
  benchmarks. Verified FP models: Watcom default = inline 8087 (`fld/fmul`);
  Aztec 3.40/4.2 = software calls (`$dldp/$dml/$dst`); DR C = software (per
  `reference_drc_float_8087_abi`).
- **Speed**: cycle-accurate on **MAME rc759** (CP/M-86), via the done-signal
  harness. Requires each compiler to emit a runnable `.CMD`. (Pending per cell.)

---

## Results

### Sieve — code size (VERIFIED 2026-08-17)

`sieve()` machine-code bytes, small memory model unless noted. Reproduce with
`./measure.sh sieve.c`.

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

### Dhrystone 2.1 — code size (VERIFIED 2026-08-17)

Whole-module machine-code bytes of `dhry.c` (Proc_1..8, Func_1..3, string
helpers, driver), small model unless noted. Reproduce with `./measure.sh dhry.c`.

| Compiler | opt | code bytes |
|----------|-----|-----------:|
| **Open Watcom** | `-otexan` (speed) | **874** |
| Open Watcom | `-os` (size) | 897 |
| Aztec C86 3.40a | default | 1168 |
| Aztec C86 4.2 | default | 1179 |
| DR C 1.11 | small (default) | 1297 |
| DR C 1.11 | large (`-b`) | 1615 |

**Finding:** same ordering as Sieve — Open Watcom densest (~25% smaller than
Aztec, ~31% smaller than DR C small), DR C largest. Interestingly Watcom's speed
tuning (`-otexan`) is here 23 B *smaller* than `-os` on this control-flow-heavy
code. Aztec 3.40 edges 4.2 by 11 B on the larger program (reverse of Sieve).
`dhry.c` is the K&R/C89 port that compiles unchanged on all four; a whole-struct
copy through a pointer (`*p = *q`) was replaced by a field-copy helper because
DR C 1.11 rejects it (Error 66 "Unknown pointer size") — the same case the stock
Dhrystone guards with its `structassign` macro. A separate, Watcom-only, runnable
Dhrystone that *verifies* the published final values lives at
`open-watcom-v2/contrib/ravn/dhry.c` (uses `enum` + `#pragma aux`, so it is the
Watcom speed/correctness reference, not a portable four-way source).

Caveats: DR C 1.11 has no optimizer switch (single fixed code-gen). Aztec C86
3.40/4.2 likewise have **no code-size optimizer flag** — verified: the `sqz` tool
is an *object-file squeezer* (compresses the `.o` encoding, e.g. 309→178 B, and
leaves the machine code unchanged), NOT a code optimizer. So **only Open Watcom
has tunable size/speed optimization** (`-os`/`-otexan`); DR C and both Aztec
versions emit one fixed code sequence. Models are each compiler's natural default
(Watcom/Aztec small, DR C reported for both) — noted rather than forced identical.

### Whetstone — code size (VERIFIED 2026-08-17, software float)

Whole-module machine-code bytes of `whet.c` (Whetstone modules 1..11 + pa/p0/p3),
small model, **software floating point** (no 8087; see FP-model note above).
Reproduce with `./measure.sh whet.c`.

| Compiler | opt | code bytes |
|----------|-----|-----------:|
| **Open Watcom** | `-otexan` (speed) | **2217** |
| Aztec C86 3.40a | default | 2254 |
| DR C 1.11 | small (default) | 2271 |
| Open Watcom | `-os` (size) | 2401 |
| Aztec C86 4.2 | default | 2425 |
| DR C 1.11 | large (`-b`) | 3318 |

**Finding:** software float **reshuffles the ranking** — the field is tight
(Watcom `-otexan` 2217, Aztec 3.40 2254, DR C small 2271 within ~2.5%), unlike the
integer benchmarks where Watcom led by 25-40%. Watcom's big integer lead came
partly from tighter integer codegen; once every compiler routes doubles through
software-FP library calls the emitted *module* code converges (the bulk moves into
the shared FP runtime, which is not counted here). NB: Watcom's DEFAULT (8087
inline) would show 1740/1651 B — smaller, but assumes an FPU RC759 lacks, so it is
excluded. Aztec 3.40 again beats 4.2; DR C large is the outlier (far FP calls).

### Status matrix

| Benchmark | size | speed |
|-----------|------|-------|
| Sieve | ✅ done (above) | ⬜ MAME rc759 (all four → .CMD) |
| Dhrystone | ✅ done (above) | ⬜ (Watcom runnable ref = contrib/ravn/dhry.c) |
| Whetstone | ✅ done (above) | ⬜ (Watcom baseline exists) |
| stdcbench | ⬜ | 🟡 DR C=13, Watcom=20 measured earlier; Aztec pending |
| AES-256 | ⬜ (port kernel to CP/M-86) | ⬜ |

Refinements to add: a genuine DR C stdcbench column (not the owc-drc hybrid);
AES-256 kernel ported to the K&R/C89 subset. (Aztec `sqz` is a compressor, not an
optimizer, so there is no extra Aztec size-opt variant to add.)

## Files

- `sieve.c` — the portable K&R/C89 Byte sieve (one source, all four compilers).
- `dhry.c`  — portable K&R/C89 Dhrystone 2.1 (one source, all four compilers).
- `omfsize.py` — Intel OMF CODE-segment byte counter (Watcom & DR C).
- `measure.sh <bench.c>` — compiles the benchmark with all four and prints the
  code-size table (Watcom OMF, DR C `code:`, Aztec max cumulative obd block-end).
