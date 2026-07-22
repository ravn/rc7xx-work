# Plan: `printf("%f")` for `zcc +cpm -compiler=llvmz80`

**Status: IMPLEMENTED 2026-07-22 (Design B, shipped).** Supersedes
`printf-f-option2-design.md` (option 2's complexity turned out materially larger
than first estimated — see below). Outcome recorded in §9; the plan sections
below are kept as the design record.

---

## 9. Outcome (as shipped)

Design B landed exactly as recommended — **zero z88dk core changes**, all other
targets untouched.

**What shipped**
- **nanoprintf-backed shim** `llvmz80-softfloat/src/npf_printf.c`:
  `__llvmz80_printf`/`fprintf`/`sprintf`/`snprintf` (+ `__llvmz80_vfprintf`).
  The stdout/stderr callback uses `putchar` (not `fputc(stdout,…)`, which HANGS
  under CP/M ntvcm); real `FILE*` uses `fputc`. Packaged into
  `softfloat_cpm_z80.lib` via `tools/build_softfloat_lib.sh` (pulled only when a
  `printf`-family symbol is referenced).
- **Transparent opt-in header route** `z88dk/include/stdio.h` (lines ~384-408,
  guarded `#if defined(__LLVMZ80) && defined(__LLVMZ80_IEEE_PRINTF)`): compile
  with `-D__LLVMZ80_IEEE_PRINTF` and **stock** `printf/fprintf/sprintf/snprintf`
  `#define` to the shim — plain `printf("%f", x)` just works, all specifiers.
  **Opt-in, not default**: routing pulls ~3 KB nanoprintf, and the shim lives in
  the softfloat archive (auto-linked only when `LLVMZ80RTLIB` is set), so a
  double program pays nothing extra to opt in while integer-only printf programs
  (which may not link the archive) stay unaffected.
- **Golden test** `llvmz80-softfloat/tests/ft_printf.{c,expected}` +
  `printf_run.sh`, wired into `tests/run.sh` (byte-identical to glibc).
- **Integration test** `z88dk/test/clang/runtime_printf_ieee.{c,sh}`: STOCK
  `printf("%f")` under `-D__LLVMZ80_IEEE_PRINTF` → `3.141593`, ntvcm-verified.

**The `%x` bug (open question §7) was NOT a nanoprintf config issue — it was a
clang-z80 backend miscompile.** nanoprintf's conversion-char dispatch is a dense
`switch`, which the Z80 backend lowers to a jump table; a jump-table upper-bound
off-by-one (`cp <limit>` should have been `cp <limit>+1`) made the highest cases
fall through, so `%x` (and the top of the specifier range) printed literally.
Root-caused and fixed in `Z80LateOptimization.cpp`; this ALSO fixed a latent
production BIOS miscompile in `_specc` (`erase_to_eos`). Writeup:
`llvm-z80/tasks/bug-jumptable-upper-bound-offbyone.md`. Verified: lit 212/0,
runtime 930/0, MAME rc702 77-track ERR=0.

**Deviations from the plan**
- `%x` root cause was a backend bug, not the `npf_cpm.h` flag guessed in §5.1/§7.
- Shim folded INTO `softfloat_cpm_z80.lib` (not a separate
  `nanoprintf_cpm_z80.lib`) — §7 open question resolved in favor of one archive.
- Route made **opt-in** via `__LLVMZ80_IEEE_PRINTF` rather than unconditional
  under `__LLVMZ80`, to keep integer-only programs off the softfloat archive.
- The dead `CLIB_IEEE64_FLOATS` Design-A leftover (§5.5) was reverted as planned.

**Permanent exception unchanged**: `%e`/`%g` render fixed-decimal only
(nanoprintf limitation), documented in the eval doc.

---

## 1. Problem

`printf("%f", x)` prints garbage under llvmz80 (`printf("%.2f",3.14)` → `val=f`).
Integer/string/hex formatting (`%d`/`%s`/`%x`) already works — only the float
conversions (`%f`/`%e`/`%g`) are broken, because clang-z80 passes an 8-byte
IEEE-754 `double` while z88dk's classic float formatter expects math48/math32.

## 2. Ground-truth findings (verified this session)

1. **z88dk's classic printf format table has no `'f'`.**
   `__printf_format_table.asm` lists only `s c d u x o p X n B l`. Float
   conversions are added by a **separate, math-library-driven mechanism**, not
   the core table.
2. **`%f` is opt-in via a math library.** `zcc +cpm --math32` (or `--math-*`)
   links a float library that supplies `asm_fpclassify` / `__dtoa_base10` /
   `__dtoa_digits` and wires the `%f` conversion.
   - sccz80 **default** (no math flag): `printf("%.2f")` **link-errors**
     (`undefined symbol: asm_fpclassify, __dtoa_base10`).
   - sccz80 `--math32`: prints `val=3.14` correctly.
3. **Two different float-converter paths exist** in z88dk:
   `classic/stdio/__printf_handle_f.asm` → `ftoa`/`ftoe`, and
   `stdlib/z80/__dtoa__.asm` → `__dtoa_base10`. The active path for sccz80 is
   `__dtoa__` (that's where the link error fired), which receives the float in
   the **shadow register set** (`exx`), precision in `de`, buffer in `hl`.
4. **llvmz80 and sccz80 dispatch `%f` differently.** llvmz80 never reaches a
   float handler (`%f` prints literally, no `__dtoa__` pulled, no link error);
   sccz80 pulls `__dtoa__` and link-errors without a math lib. So for llvmz80,
   `%f` support must both **register the conversion** and **provide an IEEE
   converter** — z88dk's math libs do neither for IEEE-754 binary64.
5. **Link order is** `-lcpm_clib -lz80_crt0 -l<softfloat>` — the llvmz80 runtime
   archive is searched **after** crt0, so a crt0 "default + lib override" trick
   would need a zcc.c link-order change.
6. **nanoprintf already formats IEEE-754 `%f` correctly** — `ft_fmt` is
   byte-identical to glibc across 50 cases. The `va_start` bug that blocked
   variadic use is fixed (ravn/llvm-z80#270).

## 3. Two candidate designs

### Design A — surgical IEEE mode inside z88dk's classic printf
Add `CLIB_IEEE64_FLOATS`, teach the z88dk float path to read an 8-byte IEEE
double and route to an IEEE converter, package that converter for llvmz80.

**Now-known cost (revised up):**
- The `%f` machinery is multi-layered (format-table registration is NOT in the
  core table; two converter paths; shadow-register float passing;
  math-lib-supplied `fpclassify`/`dtoa_base10`). Correctly hooking IEEE-754 in
  means reverse-engineering and modifying **shared** z88dk core used by every
  target and compiler.
- Requires a **zcc.c link-order change** (rtlib before crt0) for the
  default/override symbol resolution to work.
- Risk of subtle regressions across z88dk's many targets; hard to fully verify.
- Upstream-friendly in principle, but large and invasive.

**Verdict:** correct in spirit, high risk/effort, touches shared core.

### Design B — self-contained nanoprintf `printf` for llvmz80  ★ recommended
Under `__LLVMZ80`, route the `printf` family to a nanoprintf-backed
implementation packaged in the llvmz80 support layer.

**Why it's cleaner:**
- **Zero z88dk core changes.** No format-table, `__dtoa__`, `ftoa`,
  `fpclassify`, shadow-register, or link-order surgery. sccz80/sdcc/all other
  targets **completely unaffected**.
- nanoprintf handles `%d/%s/%x/%c/%o/%u/%f/…` in one IEEE-correct formatter,
  already validated byte-identical to glibc for `%f`.
- Self-contained in `llvmz80-softfloat` + a header route; opt-in and only pulled
  when `printf` is used.

**Known issues to resolve:**
- **`%x` parse bug**: in my prototype `%x` printed literally while
  `%d/%u/%o/%c` worked. Must root-cause (likely an `npf_cpm.h` config flag or a
  fixlabels/bridge mangle) and fix so all specifiers match C stdio.
- **Behavior parity**: nanoprintf's output/return values must match the existing
  passing tests (`runtime_printf_ret.sh`, integer/string cases).
- **Size**: ~3 KB for the nanoprintf core; acceptable on CP/M (54 KB TPA),
  pulled only by `printf` users.
- **`fprintf` to a `FILE*`**: nanoprintf's `npf_pprintf` callback writes via
  `fputc`, so `fprintf` is supported; `sprintf`/`snprintf` map to
  `npf_vsnprintf`.

**Verdict:** self-contained, low-risk, reuses validated IEEE formatting.

## 4. Recommendation

**Design B.** The z88dk `%f` machinery is too entangled with shared core and
math-lib assumptions to modify safely for a single compiler's IEEE-754 doubles,
and llvmz80 already diverges from the sccz80 float dispatch. A self-contained
nanoprintf `printf` gives correct `%f` (and everything else) without risking any
other target, and reuses the already-validated nanoprintf IEEE path.

Design A stays documented as the "upstream-correct, someday" route if z88dk
maintainers want native IEEE-754 printf across the toolchain.

## 5. Design B — concrete steps

1. **Root-cause the `%x` parse bug.**
   Minimal repro (`my_printf("[%x]",255)` → `[%x]`). Bisect the `npf_cpm.h`
   `NANOPRINTF_USE_*` flags vs nanoprintf defaults; confirm `%x/%X/%o/%p`
   parse+render. Fix config (or usage) so all C-stdio specifiers work.

2. **Write the printf family shim** (`llvmz80-softfloat/src/npf_printf.c`):
   - `printf`  → `npf_vpprintf(conout_cb, 0, fmt, ap)` (CONOUT via BDOS 2)
   - `fprintf` → `npf_vpprintf(fputc_cb, FILE*, fmt, ap)`
   - `sprintf` → `npf_vsnprintf(s, SIZE_MAX, fmt, ap)`
   - `snprintf`→ `npf_vsnprintf(s, n, fmt, ap)`
   - Correct return values (chars-written count).
   Guarded so it only compiles under llvmz80.

3. **Header routing** (`z88dk/include/stdio.h`, `#if defined(__LLVMZ80)`):
   route `printf`/`fprintf`/`sprintf`/`snprintf` to the shim names. Keep the
   existing `vfprintf`/`vsnprintf`/`scanf` handling (already fixed for #31).
   Confirm no clash with the working variadic-return-value path.

4. **Packaging**: compile the shim + nanoprintf impl TU into
   `softfloat_cpm_z80.lib` (or a sibling `nanoprintf_cpm_z80.lib`), pulled only
   when `printf` is referenced. Update `tools/build_softfloat_lib.sh`.

5. **Revert the dead `CLIB_IEEE64_FLOATS` constant** added to
   `lib/crt/classic/crt_rules.inc` this session (Design A leftover), so z88dk
   core is untouched.

## 6. Test plan

- **New** `z88dk/test/clang/runtime_printf_f.sh`: `printf`/`sprintf`/`snprintf`
  of a spread of doubles; compare against `ft_fmt.expected`-style golden
  (byte-identical to glibc).
- **Regression**: full `test/clang/run_all.sh` stays green — especially
  `runtime_printf_ret.sh` (return values), integer/string formatting, and the
  `%x/%o/%u/%c/%p` specifiers.
- **Negative/parity**: a mixed `printf("%d %s %x %f %c", …)` line matches glibc.
- **sccz80/sdcc untouched**: no z88dk core change, so no rebuild needed; spot
  check one sccz80 `--math32 printf("%f")` still works.

## 7. Open questions

- Exact `%x` root cause (config vs bridge mangle) — resolve in step 1 before
  committing to the shim shape.
- Whether to fold the shim into `softfloat_cpm_z80.lib` or ship a separate
  `nanoprintf_cpm_z80.lib` (cleaner separation, one more `-l` to document).
- `%e`/`%g`: nanoprintf renders fixed-decimal only (documented permanent
  upstream exception). Acceptable — same limitation as today; note in the eval.

## 8. Files (Design B)

| File | Change |
|------|--------|
| `llvmz80-softfloat/src/npf_cpm.h` | fix `%x` config flag |
| `llvmz80-softfloat/src/npf_printf.c` (new) | printf/fprintf/sprintf/snprintf shim |
| `z88dk/include/stdio.h` | `__LLVMZ80` route to shim |
| `llvmz80-softfloat/tools/build_softfloat_lib.sh` | package the shim |
| `z88dk/test/clang/runtime_printf_f.{c,sh}` (new) | golden %f test |
| `z88dk/lib/crt/classic/crt_rules.inc` | **revert** the CLIB_IEEE64_FLOATS add |
| `tasks/z88dk-llvmz80-evaluation-2026-07-21.md` | mark %f fixed |
