# Option 2: surgical IEEE-754 `%f` in z88dk's printf (design)

**Goal:** make `printf("%f", x)` work for `zcc +cpm -compiler=llvmz80` by
teaching z88dk's existing printf about IEEE-754 `double`, keeping all of its
mature `%d`/`%s`/`%x`/… machinery untouched.

## Why not a simple `#ifdef __LLVMZ80` in the handler

z88dk's classic clib (`cpm_clib.lib`, `z80_crt0.lib`) is compiled **once** and
shared by sccz80, sdcc, and llvmz80.  The shared asm sources cannot see a
per-compiler C macro like `__LLVMZ80`.  Float format is instead selected at the
**user's link step** via link-time constants:

- `bit 0,(ix+6)` — runtime "is this an sccz80 build" flag
- `CLIB_32BIT_FLOATS` / `CLIB_64BIT_FLOATS` — link-time constants
  (`lib/crt/classic/crt_rules.inc`, default 0)

For llvmz80 today all three are 0, so `__printf_handle_f` falls into the
`sdcc_48bit_floats` path (`__convert_sdccf2reg`) and misreads the 8-byte
IEEE-754 double → garbage (`printf("%f",3.14159)` prints `f`).

## The four changes

### 1. New link-time constant `CLIB_IEEE64_FLOATS`
`lib/crt/classic/crt_rules.inc`, parallel to the existing two:

```
   PUBLIC CLIB_IEEE64_FLOATS
   IF !DEFINED_CLIB_IEEE64_FLOATS
       defc CLIB_IEEE64_FLOATS = 0
   ENDIF
```

### 2. New branch in `__printf_handle_f.asm`
At entry, before the `issccz80` check, add:

```
    ld   a, CLIB_IEEE64_FLOATS
    and  a
    jr   z, not_ieee64          ; fall through to existing math48/sdcc logic
    ; --- IEEE-754 path ---
    ; DE -> vararg (8-byte little-endian IEEE double)
    ; copy 8 bytes onto the stack, advance ap by 8, get prec+buffer,
    ; call __ieee_ftoa(double, prec, buf), then join print_the_buffer.
not_ieee64:
    ...existing code...
```

Because this is guarded by an `IF/and` on a link-time constant that is 0 for
sccz80/sdcc, their builds assemble the branch as dead and never reference
`__ieee_ftoa` — zero impact on non-llvmz80 targets.

### 3. IEEE-754 `ftoa` — `__ieee_ftoa(double, int prec, char *buf)`
A small routine that decodes the raw IEEE-754 bits and writes the decimal
string.  We already have this logic: it is exactly what nanoprintf's
`npf_ftoa_rev` core does (validated byte-identical to glibc by
`llvmz80-softfloat/tests/ft_fmt`).  Package it into
`softfloat_cpm_z80.lib` (the auto-linked llvmz80 runtime), so it is pulled
**only** when the %f handler references it.

Stack ABI must match what the handler pushes:
`[buf][prec][8-byte double]` (same layout the handler already builds for the
z88dk `ftoa` call).

### 4. Set `CLIB_IEEE64_FLOATS=1` for llvmz80 builds
In `src/zcc/zcc.c`, when `compiler_type == CC_LLVMZ80`, append
`-pragma-define:CLIB_IEEE64_FLOATS=1` (mirrors how `--math32` etc. set
`CLIB_32BIT_FLOATS`).  llvmz80 always uses IEEE-754 `double`, so this is
unconditional for the compiler.

## Cost / linkage

- `%f` support in z88dk printf is already **opt-in** (`asm_printf.asm`: "Level 3
  = %e %f").  A program that never enables float printf never pulls the %f
  handler, so `__ieee_ftoa` (+ ~1-2 KB nanoprintf ftoa core) is pulled **only**
  when the user actually formats a float — the same opt-in they need on any
  compiler.
- Integer-only printf programs: **zero** added bytes.
- sccz80 / sdcc: **byte-identical** (constant 0 → dead branch).

## Upstreamability

This is a clean feature addition — "IEEE-754 double support in classic printf"
— guarded by a new link-time constant, with no behavior change for existing
compilers.  Suitable for an eventual z88dk upstream PR (ravn/z88dk first).

## Risk / effort

- Intricate asm in a 220-line core printf handler (stack discipline, `ix`
  frame offsets, vararg-pointer advance).
- The `__ieee_ftoa` stack-ABI shim wrapping nanoprintf's C core.
- Must re-verify the existing printf test suite (return values, %d/%s/%x) stays
  green, plus a new %f runtime test matching `ft_fmt.expected`.

## Files touched

| File | Change |
|------|--------|
| `lib/crt/classic/crt_rules.inc` | +5 lines: `CLIB_IEEE64_FLOATS` constant |
| `libsrc/classic/stdio/__printf_handle_f.asm` | +~30 lines: IEEE branch |
| `libsrc/l/llvmz80/__ieee_ftoa.asm` (new) | stack-ABI shim → nanoprintf ftoa |
| `src/zcc/zcc.c` | +1 line: pragma-define for llvmz80 |
| `tools/build_softfloat_lib.sh` | include `__ieee_ftoa` + nanoprintf ftoa core |
| `test/clang/runtime_printf_f.sh` (new) | red-green %f runtime test |
