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
Also: with real headers, hosted mode warns `z80_smallc calling convention is not supported on builtin function [-Wignored-attributes]` for puts/fread/fwrite — clang treats them as builtins and drops the CC attr. Explicit `__smallc` calls clang does NOT treat as builtins still bridge fine in both modes; breakage is specifically clang synthesizing/builtin-substituting a classic clib call without the bridge.

## Exact upstream-clang source of the CC-drop (verified, SemaDecl.cpp:3902)
The warning is generic clang Sema, NOT backend. In `clang/lib/Sema/SemaDecl.cpp` `mergeFunctionTypes()` (~line 3902): when a function is re-declared with a different CC AND the prior decl is a recognized builtin (`Old->getBuiltinID()` non-zero), clang deliberately discards the new CC: `NewTypeInfo = NewTypeInfo.withCallingConv(OldTypeInfo.getCC())` (comment: "Calling Conventions on a Builtin aren't really useful ... warn and ignore"). `getBuiltinID()` is non-zero only in hosted mode -> the warning vanishes under `-ffreestanding` (there `puts` is not a builtin). Consequence sharpened: even an EXPLICIT `puts(...)` whose header prototype carries `__smallc` has the attribute silently overwritten in hosted mode. So a per-prototype `__smallc` fix cannot work in hosted mode; the CC must come from the backend's default libcall lowering, not source attributes.

## Verification recipe
`-fhosted` overrides an earlier `-ffreestanding` (last-wins; `-fno-freestanding` is NOT a valid clang flag). So test the drop end-to-end WITHOUT rebuilding zcc: `zcc +cpm -compiler=llvmz80 -O2 -Cg-fhosted -create-app prog.c`. Env: ZCCCFG=.../z88dk/lib/config, PATH includes z88dk/bin + ntvcm, LLVMZ80EXE=llvm-z80 clang.

## Recommendation
Keep `-ffreestanding` — it is exactly what stops clang replacing/synthesizing classic clib calls that bypass the `__smallc` bridge. Capturing the ~20% printf-elimination win requires a builtin-aware `__smallc` bridge (clang won't honor CC attrs on functions it classifies as builtins), a much larger task than a flag flip. No production driver is on this path (RC702 firmware drives clang directly, not `zcc +cpm`). Suggested resolution: wontfix / document `-ffreestanding` as required.
