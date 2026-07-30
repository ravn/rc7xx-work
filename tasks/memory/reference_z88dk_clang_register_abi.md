# z88dk clang path: ez80clang (stack ABI) vs ravn/llvm-z80 (register ABI)

**The core divergence** behind the z88dk clang string/mem breakage.

z88dk's `__CLANG` support (the `defc ___X = X` "Clang bridge" blocks in
`libsrc/string/c/sccz80/*.asm`, and `include/sys/proto.h`'s reversed-arg
`__ZPROTO*` macros) was written for **ez80-clang** — the eZ80 TI CEdev
compiler (`bin/ez80-clang` -> `cedev-eval/CEdev/bin/ez80-clang`), which is
24-bit and passes function args on the **stack**.

**ravn/llvm-z80 (`-compiler=llvmz80`) is different**: plain **z80, 16-bit,
REGISTER ABI**:
- 1st 16-bit arg in **HL**, 2nd in **DE**, 3rd+ on the **stack** above the
  return address, **callee-cleaned**.
- 16-bit pointer/int return in **DE** (`retp` = `ex de,hl`).

So the shared `defc ___X = X` aliases bind clang's reversed-arg `__X`
symbols to the sccz80 **stack-ABI** workers -> they read garbage off the
stack -> LDIR corruption / hang.

## What was done (branch rc700-gensmedet-1, z88dk repo)
Each broken clang bridge was **rewritten in-place** (not shimmed, not a new
module) to convert the register ABI to the shared `asm_X` workers, e.g.
`strcpy`: `call asm_strcpy; ex de,hl; ret`. Fixed: memset/memcpy/memmove
(commit bc1c0cd8) and strcpy/strcmp/strcat/strchr/strncpy/memcmp/memchr
(commit a452cd6c). Regression tests: `test/clang/runtime_mem.{c,sh}`,
`runtime_str.{c,sh}`. sccz80/sdcc use the `_X` symbols, unaffected.

## Key facts
- **Do NOT split the `__CLANG` macro.** Both clangs share the reversed-arg
  `proto.h` convention; the breakage is calling-convention, not macro-level.
  Genuine compiler-rt integer-helper divergence IS already correctly split
  via `-compiler=` (`libsrc/l/llvmz80.lst` vs `l/clang.lst`).
- `__z88dk_callee`/`__smallc` are **empty** under clang
  (`include/sys/compiler.h`); clang uses ONLY the reversed-arg `__X` scheme.
- Bridges are **out-of-line** (z80asm does no cross-module inlining):
  verified in `s1.com` the caller does `jp ___strcpy` -> `call asm_strcpy;
  ex de,hl; ret`. So each adds one call/ret layer (~27 T) + the `ex de,hl`.
- **`ex de,hl` exists only because llvmz80 returns in DE.** If the backend
  returned 16-bit results in **HL**, the bridges collapse to pure zero-cost
  `defc ___X = asm_X` aliases. Tracked as TODO-LATER
  (`clang-runtime-helper-return-reg`; backend `Z80CallLowering.cpp`).
- **strlen + fastcall-redirect class (FIXED):** strlen, strdup, strerror,
  strlwr, strrev, strrstrip, strstrip, strupr are single-arg funcs with ONLY a
  `#define X X_fastcall(x)` redirect (guarded `#ifndef __STDC_ABI_ONLY`) and NO
  `__ZPROTO`. Under llvmz80 `__STDC_ABI_ONLY` IS defined (sys/compiler.h:53) so
  the redirect is skipped -> clang calls the unattributed `_X` (classic clib
  STACK ABI) with the arg in HL -> garbage (strlen("Hello")=1200). Fixed by an
  `#elif defined(__LLVMZ80)` branch per block routing to `_X_fastcall`
  (`__z88dk_fastcall` == z80_fastcall, HL in/out, aliases `asm_X`). `__LLVMZ80`
  is defined only for `-compiler=llvmz80` (zcc.c:3443 `-D__CLANG -D__LLVMZ80`),
  NOT ez80clang (`-D__CLANG` only). z88dk commits 12cfa587 (strlen) + 0292af1e
  (class). Single-point alternative (gate `__STDC_ABI_ONLY` to exclude llvmz80)
  deferred -- flips every fastcall/callee redirect in ALL headers at once (blast
  radius; esp. `__ZPROTO`+`_callee` funcs like stricmp). See session todos
  `z88dk-stdc-abi-single-point`.
- **Non-trivial program works end-to-end (llvmz80):** recursion + structs +
  sieve/memset + sprintf(%s%d%ld%lu) + 32-bit mul/div/mod + strlen/strcpy all
  match the host reference exactly. The integer helpers + string/mem bridges +
  fastcall-class fixes together give a working CP/M C compiler on official
  z88dk libs.

## Native 2-step rebuild (no Docker)
From `/Users/ravn/z80/z88dk`, `PATH=$PWD/bin:$PATH ZCCCFG=$PWD/lib/config`:
1. Recompile obj: `cd libsrc && z88dk-z80asm -d -O=string/obj/z80/x
   -I$PWD/classic -mz80 -D__CLASSIC string/c/sccz80/FILE.asm`
2. Re-archive: `cd libsrc && TYPE=z80 z88dk-z80asm -d -I$ZCCCFG/../ -mz80
   -DSTANDARDESCAPECHARS -xz80_crt0 @classic/z80.lst && cp z80_crt0.lib
   ../lib/clibs/z80_crt0.lib` (z80_crt0.lib is a build artifact, untracked).

Validate with the real artifact: ntvcm `/Users/ravn/z80/ntvcm/ntvcm`;
broken-ABI programs HANG (run async + stop_bash to bound).
