# BUG: 64-bit global initializers truncated to 32 bits (`.quad` → `DEFQ`)

- **Upstream issue:** [ravn/z88dk#27](https://github.com/ravn/z88dk/issues/27)
- **Repro:** [`bugs/quad_global_init_truncated.c`](quad_global_init_truncated.c)
- **Status:** filed 2026-07-15, unfixed. **Blocks** Phase 3 (double precision).
- **Component:** `z88dk/lib/llvmz80/llvmz80_rules.1` (the `-compiler=llvmz80` copt bridge).
  **NOT** the llvm-z80 backend — raw clang is correct (see §3).
- **Severity:** high / silent data corruption. Any 8-byte global whose initializer
  has bits above bit 31 is wrong, at **every** optimization level, with **no
  diagnostic**.

---

## 1. One-line

Under `zcc +cpm -compiler=llvmz80`, a `long long` / `unsigned long long` / `double`
(any 8-byte type) **global with a static initializer** loses its high 32 bits.
Runtime stores to the same variable are correct.

## 2. Symptom (verified on target)

Build & run `bugs/quad_global_init_truncated.c` under the cycle-accurate CP/M
harness (`z88dk-ticks` + BDOS stub, `scratch/dcc-clang-bench/ticks_cpm.py`).
Each line prints the low and high 32-bit dwords of a `uint64_t` global:

| var (init)                    | expected (lo hi)  | actual (lo hi) | verdict                       |
|-------------------------------|-------------------|----------------|-------------------------------|
| `g_big  = 0x4008000000000000` | `0 1074266112`    | `0 0`          | ❌ high 32 bits lost           |
| `g_small= 0x0000000000000007` | `7 0`             | `7 0`          | ✓ (value fits in low 32 bits) |
| `g_mid  = 0x0000000100000000` | `0 1`             | `0 0`          | ❌ byte at offset 4 lost        |
| `g_run` (assigned at runtime) | `0 1074266112`    | `0 1074266112` | ✓ (runtime store, not init)   |

`g_small` survives only because its value lives entirely in the low 32 bits.
`g_run` proves the code path for *stores* is fine — only the *static initializer*
data emission is broken.

## 3. Root cause (verified three independent ways)

### (a) The LLVM backend is correct
`clang --target=z80 -O2 -S` emits a proper 8-byte `.quad` directive:

```asm
_g:
    .quad   4613937818241073152      ; 0x4008000000000000
```

`.quad` in GNU-flavoured assembly is **8 bytes**. So the bug is *downstream* of
clang, in the pipeline stage that rewrites clang's GNU asm into z88dk `z80asm`
syntax.

### (b) z88dk's `DEFQ` directive is only 4 bytes
Proof — assemble `DEFQ 0x11223344` followed by a `DEFB 0xAA` sentinel:

```
$ z88dk-z80nm code_compiler  ->  5 bytes
$ raw bytes                  ->  44 33 22 11 aa
```

`DEFQ` produced **4** bytes (`44 33 22 11`, little-endian `0x11223344`) before the
`aa`. So `DEFQ` is a 32-bit directive, **not** the 8-bit-times-8 "quad" its name
suggests. (For scale: z88dk `DEFB`=1, `DEFW`=2, `DEFQ`=4.)

### (c) The bridge rule maps `.quad` → a single 4-byte `DEFQ` + padding
`z88dk/lib/llvmz80/llvmz80_rules.1` (around line 99) — the `z88dk-copt` rewrite rule:

```
    .quad   %1
=
    DEFQ    %1
    DEFQ    0
```

`z88dk-copt` does **textual** pattern substitution: it cannot split the 64-bit
literal `%1` into two 32-bit halves arithmetically. So it emits `%1` into one
4-byte `DEFQ` (which `z80asm` silently truncates to the low 32 bits) and pads the
remaining 4 bytes with a literal `DEFQ 0`. For `g_big` the emitted bridge output is:

```asm
_g_big:
    DEFQ 4613937818241073152      ; 0x4008000000000000 -> z80asm truncates -> 0x00000000
    DEFQ 0
```

Result in memory: `00 00 00 00  00 00 00 00` → reads back as `0`. The **true high
32 bits (`0x40080000`) are never emitted** — they are replaced by the padding `0`.

For contrast, the neighbouring rule `.long %1 → DEFQ %1` is **correct**, because
GNU `.long` = 4 bytes = z88dk `DEFQ` = 4 bytes.

## 4. Why it matters here (discovery context)

Found while bringing up an IEEE-754 **double** runtime (vendored Berkeley
SoftFloat) for `zcc +cpm -compiler=llvmz80` (Phase 3). Independent checks proved
the SoftFloat core is correct on target — `f64_add` on hand-built bit patterns
returns exactly `10.0` (`0x40240000` high dword) — and the whole f64 closure links
in ~49 KB. But the on-target double test read wrong values and, in some paths,
hung: `volatile double` globals initialized to non-trivial constants (e.g. `3.0`,
`7.0`, `1000000.0`) had their high 32 bits zeroed by this bug, feeding garbage
bit patterns into the float routines.

Broader impact: this is **not** float-specific. Any program using `long long`
globals with values above `0xFFFFFFFF` — timers, 64-bit masks, hashes, large
enums — is miscompiled with no warning.

## 5. Correct fix (for the maintainer — NOT attempted here)

`.quad %1` must emit the two 32-bit halves in little-endian order:

```
_g_big:
    DEFQ 0            ; low  32 of 0x4008000000000000
    DEFQ 1074266112   ; high 32 = 0x40080000
```

`z88dk-copt`'s text substitution cannot compute `%1 >> 32` / `%1 & 0xFFFFFFFF`, so
the fix must live where arithmetic is available, e.g.:

- teach the bridge (`bridge_postproc.sh`) to split 8-byte values before copt, or
- have clang emit paired `.long` directives for 64-bit data on this target, or
- add a real 8-byte assembler directive and map `.quad` to it.

Per project policy we **file, not fix** — the issue documents the diagnosis; the
fix decision is the maintainer's.

## 6. Workarounds (until fixed)

- **Initialize 64-bit globals at runtime** instead of with a static initializer
  (a store is unaffected — see `g_run`). E.g. set them in an init function called
  from `main`/startup rather than `= 0x....ULL` at file scope.
- Keep 64-bit *constants* as **locals** or **immediates** (both fine); only
  file-scope/`static` 8-byte *initializers* are affected.
- For SoftFloat tables that are genuinely `const` 8-byte data, prefer expressing
  them as arrays of 32-bit halves, or relocate/copy them at runtime.

## 7. How to re-verify (red)

```bash
export PATH="/Users/ravn/z80/z88dk/bin:$PATH"; export ZCCCFG=/Users/ravn/z80/z88dk/lib/config/
cd /Users/ravn/z80/llvmz80-softfloat
zcc +cpm -compiler=llvmz80 -Cg-O2 -o /tmp/quad bugs/quad_global_init_truncated.c
python3 /Users/ravn/z80/scratch/dcc-clang-bench/ticks_cpm.py /tmp/quad
# BIG/MID lines print "0 0" (buggy). After a fix they must print "0 1074266112" / "0 1".
```

The DEFQ-width proof:

```bash
printf '        SECTION code_compiler\n_t:\n        DEFQ 0x11223344\n        DEFB 0xAA\n' > /tmp/d.asm
zcc +cpm -compiler=llvmz80 -c -o /tmp/d.o /tmp/d.asm
z88dk-z80nm /tmp/d.o | grep code_compiler        # -> "5 bytes"  (4 for DEFQ + 1 for DEFB)
```
