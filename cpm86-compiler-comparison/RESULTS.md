# CP/M-86 C compiler code-quality comparison

Compares the code efficiency (size **and** speed) of the four CP/M-86 C compilers
available in this workspace, optimized for both size and speed where the compiler
supports it. Era-authenticity is explicitly **not** a goal — this measures code
quality only.

## Headline results

Consolidated from the verified per-benchmark sections below. **stdcbench is still
blocked (#5)** and omitted. Lower is better in both tables.

**Code size** (bytes of emitted benchmark code; Watcom `-os`/`-otexan`, Aztec
3.40/4.2, DR C small/large model):

| Benchmark | Watcom -os | Watcom -otexan | Aztec 3.40 | Aztec 4.2 | DR C small | DR C large |
|-----------|-----------:|---------------:|-----------:|----------:|-----------:|-----------:|
| Sieve | **72** | 74 | 112 | 110 | 121 | 151 |
| Dhrystone | 897 | **874** | 1168 | 1179 | 1297 | 1615 |
| Whetstone (sw-float) | 2401 | **2217** | 2254 | 2425 | 2271 | 3318 |
| AES-256 | 1754 | **1675** | 3092 | 3254 | 3817 | 4523 |

**Speed** (80186 clocks per unit, Unicorn oracle + differential method; best
variant per compiler):

| Benchmark | Watcom | Aztec 3.40 | Aztec 4.2 | DR C |
|-----------|-------:|-----------:|----------:|-----:|
| Sieve (clk/iter) | **1,023,461** | 2,118,049 | 2,197,314 | 3,688,187 |
| Dhrystone (clk/run) | **5,639** | 10,964 | 10,964 | 47,819 |
| AES-256 (clk/encrypt) | **3,453,717** | 9,848,615 | 10,173,935 | 11,286,622 |
| Whetstone (clk/pass) | **19,864,674** | 62,528,360 | 60,358,162 | 39,468,291 |

**Takeaways:** Open Watcom wins every size and speed cell. Below Watcom the
integer/FP rankings **invert**: on integer work (Sieve, Dhrystone, AES) Aztec
beats DR C, but on floating point (Whetstone) DR C beats both Aztec — its
soft-float/transcendental library is tighter. Aztec 4.2 edges 3.40 on FP;
3.40 edges 4.2 on integer.

## Compilers under test

| # | Compiler | Dialect | Driver | Notes |
|---|----------|---------|--------|-------|
| 1 | **Open Watcom** (v2 fork) | ANSI | `open-watcom-v2/rel/armo64/owcc -bcpm86` | one-step production driver, first-class CP/M-86 target; `-os` size / `-otexan` speed passed via `-Wc,`; links CP/M-86 (`format cpm86`) in the same command when producing a `.CMD` |
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
- **Speed**: cycle count from the **Unicorn/QEMU 8086 executor**
  (`cpm86run_unicorn.py --ticks`), which runs the real 8086 instruction stream
  and costs it with the `cycles186.py` 80186 model. It is an 80186 cost model
  (RC759 is an 8086), so treat the numbers as **relative**, not wall-clock. To
  cancel fixed crt0/printf/libc overhead we use a **differential** method: build
  the same kernel at N=10 and N=20 iterations and report
  `(clocks(N20) − clocks(N10)) / 10` = clocks per kernel iteration. Requires each
  compiler to emit a runnable CP/M-86 `.CMD` (Watcom via the one-step
  `owcc -bcpm86` driver, which compiles + links `format cpm86` in a single
  command; Aztec via `-lc86`; DR C via the emu2 oracle).

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

### Sieve — speed (VERIFIED 2026-08-17)

80186 clocks per sieve iteration (SZ=8190), differential method (N=20 minus
N=10, divided by 10), overhead-free. Lower is faster.

| Compiler | opt | clocks / iteration |
|----------|-----|-------------------:|
| **Open Watcom** | `-os` (size) | **1,023,461** |
| Open Watcom | `-otexan` (speed) | 1,024,185 |
| Aztec C86 3.40a | default | 2,118,049 |
| Aztec C86 4.2 | default | 2,197,314 |
| DR C 1.11 | small (default) | 3,688,187 |

**Finding (speed):** the speed ranking mirrors the size ranking — Watcom is both
the smallest and the fastest (~2.1× faster than Aztec, ~3.6× faster than DR C),
DR C both the largest and the slowest. Watcom's `-otexan` speed tuning does not
help this tight byte-array loop (essentially identical to `-os`). Aztec 3.40
edges 4.2 slightly. The 3.6× Watcom-vs-DR-C gap tracks DR C's less efficient
array-index addressing.

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

### Dhrystone 2.1 — speed (VERIFIED 2026-08-17)

80186 clocks per Dhrystone loop iteration (the Proc_1..Proc_8 / Func_2 measured
region), differential method (N=20 minus N=10, divided by 10). Lower is faster.

| Compiler | opt | clocks / run |
|----------|-----|-------------:|
| **Open Watcom** | `-otexan` (speed) | **5,639** |
| Open Watcom | `-os` (size) | 6,956 |
| Aztec C86 3.40a | default | 10,964 |
| Aztec C86 4.2 | default | 10,964 |
| DR C 1.11 | small (default) | 47,819 |

**Finding (speed):** Watcom again leads. Unlike the tight Sieve loop, `-otexan`
speed tuning DOES help here (5,639 vs 6,956, ~19% faster) — Dhrystone's mix of
calls, struct copies and pointer chasing gives the optimizer room. Both Aztec
versions produce identical timing (10,964). DR C is the clear outlier at 47,819
clocks — ~8.5× slower than Watcom `-otexan` and ~4.4× slower than Aztec — tracking
its heavier struct/pointer codegen and lack of any optimizer.

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

### Whetstone — speed (VERIFIED 2026-08-17, software float)

80186 clocks per full Whetstone pass (all modules; software float + `sin/cos/
atan/sqrt/exp/log`), differential method (N=20 minus N=10, divided by 10). Lower
is faster. Runs are ~200M-1.25B clocks each — the whole cell took ~30 min of
oracle time (run in parallel across cores).

| Compiler | opt | clocks / pass |
|----------|-----|--------------:|
| **Open Watcom** | `-os` (size, `-fpc`) | **19,864,674** |
| DR C 1.11 | small (default) | 39,468,291 |
| Aztec C86 4.2 | default | 60,358,162 |
| Aztec C86 3.40a | default | 62,528,360 |

**Finding (speed):** Watcom leads again (~2× faster than DR C, ~3× faster than
Aztec) — its `__FDx` soft-float runtime + math library are the most efficient.
But the *rest* of the ranking **inverts** relative to the integer benchmarks: on
floating point DR C **beats both Aztec versions** (39.5M vs ~60M) — the reverse of
Sieve/Dhrystone/AES where DR C was slowest — because DR C's transcendental/
soft-float library is tighter than Aztec's. And here Aztec **4.2 edges 3.40**
(60.4M vs 62.5M), also the reverse of the integer pattern. So "which compiler is
faster" is workload-dependent below the Watcom top spot: DR C is weak on integer
codegen but competitive on FP library quality.

### AES-256 — code size (VERIFIED 2026-08-17)

Whole-module machine-code bytes of `aes256.c` — the literatecode tableless
byte-oriented AES-256 (GF math computed on the fly, no S-box tables), small model.
Reproduce with `./measure.sh aes256.c`.

| Compiler | opt/model | code bytes |
|----------|-----------|-----------:|
| **Open Watcom** | `-otexan` (speed) | **1675** |
| Open Watcom | `-os` (size) | 1754 |
| Aztec C86 3.40a | default | 3092 |
| Aztec C86 4.2 | default | 3254 |
| DR C 1.11 | small (default) | 3817 |
| DR C 1.11 | large (`-b`) | 4523 |

**Correctness (independent oracle):** the source is validated against the FIPS-197
AES-256 ECB known-answer vector (key `000102..1f`, pt `00112233..eeff`), whose true
ciphertext is `8ea2b7ca516745bfeafc49904b496089` — **confirmed by `openssl enc
-aes-256-ecb`**, NOT from memory. The DR C build (K&R + `char` shim) matches host
clang byte-for-byte, and decrypt round-trips to the plaintext, so the K&R
conversion and the DR C `unsigned char`->`char` shim are faithful.

**Finding:** the widest integer spread in the suite — Watcom is **~2.3x denser**
than DR C. AES is heavy on 8-bit array indexing, rotates and GF multiplies;
Watcom's register allocator and 8-bit codegen pull far ahead, while DR C's fixed
1984 codegen (every 8-bit op through memory) trails badly. Aztec sits in between,
3.40 again beating 4.2.

**Portability notes:** the corpus source uses ANSI prototypes (for z88dk SDCC);
converted back to K&R here because DR C 1.11 AND Aztec 3.40 reject ANSI prototypes
(ANSI compilers accept K&R). DR C 1.11 has no `unsigned char` type (Error 13) but
its `char` is unsigned by default (verified: `0x80` rotate -> 1, not 255), so
`measure.sh` maps `unsigned char`->`char` on the DR C path only — identical 8-bit
unsigned semantics there.

### AES-256 — speed (VERIFIED 2026-08-17)

80186 clocks per `aes256_encrypt_ecb` call (one 16-byte block, 14 rounds),
differential method (N=20 minus N=10, divided by 10). Lower is faster.

| Compiler | opt | clocks / encrypt |
|----------|-----|-----------------:|
| **Open Watcom** | `-os` (size) | **3,453,717** |
| Open Watcom | `-otexan` (speed) | 3,565,310 |
| Aztec C86 3.40a | default | 9,848,615 |
| Aztec C86 4.2 | default | 10,173,935 |
| DR C 1.11 | small (default) | 11,286,622 |

**Finding (speed):** Watcom leads by ~2.85× over Aztec 3.40 and ~3.3× over DR C.
Notably `-os` is marginally FASTER than `-otexan` here (3.45M vs 3.57M) — the
byte-array/GF-multiply inner loops favour the tighter size-tuned code, so speed
tuning does not pay off on this kernel. Aztec 3.40 again edges 4.2. Unlike
Dhrystone (where DR C was a 4× outlier), AES's byte/array-heavy work keeps DR C
and Aztec within ~15% of each other — DR C's unsigned-`char` default handles the
8-bit workload comparatively well.

### Status matrix

| Benchmark | size | speed |
|-----------|------|-------|
| Sieve | ✅ done (above) | ✅ done (above, all four) |
| Dhrystone | ✅ done (above) | ✅ done (above, all four) |
| Whetstone | ✅ done (above) | ✅ done (above, all four) |
| stdcbench | 🔴 blocked (see note) | 🔴 blocked (tracked #5) |
| AES-256 | ✅ done (above) | ✅ done (above, all four) |

**stdcbench blocker (honest status, not fabricated):** unlike the other four
benchmarks (each a single small portable K&R source), stdcbench 0.8 is a 14-module
ANSI/C90 suite. The two full-ANSI compilers (Open Watcom, Aztec 4.2) could compile
it, but the two K&R compilers (DR C 1.11, Aztec 3.40) need the whole ANSI->K&R
`unproto`+transform pipeline in `open-watcom-v2/contrib/ravn/pure-drc/stdcbench/`,
and per that dir's verified `FINDINGS.md` only **11 of 14 modules** compile — the
remaining 3 (compression, isort, lnlc) need per-file source rewrites that ALTER the
benchmark (an `unproto` func-ptr-param bug + DR C's missing pointer-to-array type),
which are not yet written. A fair 4-way cell would therefore require either those
benchmark-altering rewrites or restricting to an 11-module subset (and re-hosting the
glue off the retired `owc-drc` tree). Deferred and tracked as ravn/rc7xx-work#5;
no number is reported rather than an unfair or fabricated one.

Refinements to add: complete stdcbench (either the 11-module subset or the three
per-file rewrites, tracked #5). (Aztec `sqz` is a compressor, not an optimizer, so
there is no extra Aztec size-opt variant to add.)

## Reproducing (Makefiles)

The comparison is driven by **short per-compiler Makefiles**, one subdirectory per
compiler, all consuming the *same* C source from `src/`. No compiler is ever linked
against another's runtime — each stands alone (DR C and Aztec are standalone
oracles; Watcom is one-step `owcc -bcpm86`).

```
make compare   # per-benchmark code-size table across all four compilers
make dis       # emit every compiler's disassembly of every source
make clean
```

Layout:

| Subdir     | Compiler            | Size source                | Disassembly            |
|------------|---------------------|----------------------------|------------------------|
| `watcom/`  | one-step `owcc -bcpm86` | OMF CODE (`omfsize.py`) | `wdis -s` (source-interleaved, `-d1`) |
| `drc/`     | DR C 1.11 (emu2)    | OMF CODE (`omfsize.py`)    | `wdis` (mnemonic)      |
| `aztec42/` | Aztec C86 4.2       | max obd block-end          | `obd` (bytes + source lines + vars) |
| `aztec34/` | Aztec C86 3.40a     | max obd block-end          | `obd` (bytes + source lines + vars) |

Debug-enrichment: Watcom compiles with `-d1` so `-os` optimization is preserved
*and* `wdis -s` interleaves the original source — one object serves both true-size
measurement and rich disassembly. DR C's OMF disassembles mnemonically via the same
`wdis`. Aztec's native `obd` dump is byte-level but the richest annotated (source
line numbers, auto-var names/types, relocations).

## Files

- `Makefile`, `common.mk` — top-level orchestrator + shared config.
- `<compiler>/Makefile` — short per-compiler build (object, `.dis`, `sizes`).
- `src/*.c` — one shared source per benchmark (+ `sieve_main.c`, `aes256_main.c`
  drivers giving `main()` to the bare kernels so they can link to `.CMD`).
- `tools/omfsize.py` — Intel OMF CODE-segment byte counter (`--code` mode).
- `tools/azsize.py` — Aztec obd max-block-end sizer; `tools/table.py` — table aggregator.
- `tools/drc-build.sh` / `drc-measure.sh` — DR C under emu2.
- `measure.sh` — **RETIRED** legacy all-in-one harness, superseded by the Makefiles
  above (kept for reference only).

