# ravn/z88dk#57 — `-ffreestanding` is load-bearing on the llvmz80 classic path

**Status: investigated 2026-08-11, issue OPEN, recommended keep `-ffreestanding` (wontfix the drop).**

zcc emits `--target=z80 -S -ffreestanding -std=gnu23` on the llvmz80 path (`src/zcc/zcc.c:3582`). #57 asked what dropping `-ffreestanding` (going hosted) could bring.

## Finding — dropping it is a MISCOMPILE, not an optimization
- **Upside (verified):** hosted mode re-enables clang middle-end libcall simplifications. `printf("literal\n") -> puts("literal")` let the linker drop the printf formatter: a 4×printf constant-string banner went **7342 -> 5876 B (−1466, ~20%)**.
- **Fatal downside (verified under ntvcm):** that −20% binary printed garbage (`\ufffd\ufffd"\ufffd`), not the four lines.

## Root cause (verified at asm level)
z88dk classic stdio uses the `__smallc` (`z80_smallc`) calling convention (args pushed on stack, caller-clean); header prototypes declare it so clang bridges EXPLICIT calls right. But clang's `SimplifyLibCalls` **synthesizes** the `puts` call with LLVM's default libcall CC — no `__smallc`:
```
printf("SYNTH\n"), __smallc printf prototype:
  -ffreestanding:  ld hl,L_.str ; push hl ; call _printf ; pop af   (correct __smallc)
  -fhosted:        ld hl,L_str  ; jp _puts                          (arg in HL, NOT pushed -> classic puts reads junk)
```
Also: with real headers, hosted mode warns `z80_smallc calling convention is not supported on builtin function [-Wignored-attributes]` — but VERIFIED (2026-08-11) this fires for `strlen`/`memcpy`/`fread`/`fwrite` (recognized builtins w/ matching sig), NOT for `puts`/`fputc`. (Earlier claim that puts warns was an overclaim, corrected in #57.) There are TWO independent breakage mechanisms:

**Mechanism 1 — middle-end synthesis (SimplifyLibCalls).** printf("...\n") -> freshly created `puts` decl. The emitted call inherits the DECLARATION's CC (`BuildLibCalls.cpp` emit* helpers all do `CI->setCallingConv(F->getCallingConv())`, e.g. emitPutS ~line 2058); `getOrInsertLibFunc` (BuildLibCalls.cpp:1506) creates the decl with default C CC when none exists -> cc132/__smallc lost -> `ld hl; jp _puts` -> garbage. SEAM (verified A/B/C repros): if a `cc132 puts` decl is already present-AND-referenced in the module, getOrInsertFunction reuses it and the synth call is correct (`push hl; call _puts`). An unused extern decl is dropped before the middle-end, so its CC can't be reused.

**Mechanism 2 — frontend builtin-CC-drop (Sema).** For builtin-recognized funcs, an explicit __smallc prototype has its CC silently discarded at `clang/lib/Sema/SemaDecl.cpp` ~3902 (`Old->getBuiltinID()` branch: `NewTypeInfo = NewTypeInfo.withCallingConv(OldTypeInfo.getCC())`, comment "Calling Conventions on a Builtin aren't really useful ... warn and ignore"). VERIFIED consequence: explicit `strlen(s)` -> `jp _strlen` (wrong) in hosted vs `push hl; call _strlen` in freestanding. getBuiltinID() is non-zero only in hosted -> vanishes under -ffreestanding.

## Can we teach clang the stdlib routines' CC so hosted works? (answer to user 2026-08-11)
Yes. SCOPE: llvmz80 targets the z88dk CLASSIC clib only (newlib out of scope, user 2026-08-11), so the libc CC is unconditionally `__smallc` on the `zcc +cpm -compiler=llvmz80` path — no clib-selection matrix needed. zcc just conveys ONE always-on setting ("libc CC = __smallc") like it already passes `-mllvm -z80-float-sdcccall0` and `-ffreestanding`. That single flag drives two target-independent changes:
- Fix mechanism 1: `getOrInsertLibFunc` (BuildLibCalls.cpp:1506) stamps the libfunc CC on fresh decls; emit* helpers propagate it for free.
- Fix mechanism 2: stop discarding the CC attr on builtin redeclarations (SemaDecl.cpp:3902) when the classic-libc-CC setting is active.
Header-only trick can only paper over mechanism 1 (force cc132 decls referenced); cannot fix mechanism 2 (CC stripped at parse time). `-ffreestanding` is effectively the coarse `-fno-builtin` form -> currently the correct safe setting. `Z80_SmallC` = cc132 (`llvm/include/llvm/IR/CallingConv.h:336`); no backend `getLibcallCallingConv` exists for these (that hook only covers RTLIB/compiler-rt calls, not SimplifyLibCalls C-lib calls).

## Verification recipe
`-fhosted` overrides an earlier `-ffreestanding` (last-wins; `-fno-freestanding` is NOT a valid clang flag). So test the drop end-to-end WITHOUT rebuilding zcc: `zcc +cpm -compiler=llvmz80 -O2 -Cg-fhosted -create-app prog.c`. Env: ZCCCFG=.../z88dk/lib/config, PATH includes z88dk/bin + ntvcm, LLVMZ80EXE=llvm-z80 clang.

## Recommendation
Keep `-ffreestanding` — it is exactly what stops clang replacing/synthesizing classic clib calls that bypass the `__smallc` bridge. Capturing the ~20% printf-elimination win requires a builtin-aware `__smallc` bridge (clang won't honor CC attrs on functions it classifies as builtins), a much larger task than a flag flip. No production driver is on this path (RC702 firmware drives clang directly, not `zcc +cpm`). Suggested resolution: wontfix / document `-ffreestanding` as required.
