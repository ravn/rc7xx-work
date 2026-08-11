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

## Correction + "default __smallc?" thought experiment (2026-08-11)
CORRECTION: TargetLibraryInfo has NO scalar-libcall CC hook. The `std::optional<CallingConv::ID> CC` in TLI belongs to `VecDesc` (vector-function ABI, libmvec/SLEEF), not scalar libcalls. The relevant existing gate is `TargetLibraryInfoImpl::isCallingConvCCompatible` (TargetLibraryInfo.cpp:66): cc132 hits `default: return false` so LLVM refuses to simplify a call *carrying* cc132 — but the gate checks the INPUT call (printf = ccc, passes), not the synthesized OUTPUT (puts), which is why the win leaks.

"Can llvmz80 just default to __smallc?" -> NO (verified against classic headers):
1. Global flip breaks production sdcccall ELF ABI (firmware drives clang directly; -z80-float-sdcccall0/CallLowering/CC tests).
2. Classic clib is a per-function CC MIX, not one CC: 502 __smallc, 228 __z88dk_fastcall, 211 __z88dk_callee, 12 __vasmallc, rest bare. Even within the synthesized set: puts/fputc/putchar=__smallc, printf=__vasmallc, memcpy/strcpy via *_callee=__smallc+__z88dk_callee. NOTE re strlen: its header prototype is UNANNOTATED but the real `_strlen` routine IS stack-ABI/__smallc (verified libsrc/string/c/sccz80/strlen.asm: pops arg off stack). z88dk normally macro-redirects source `strlen(x)`->`strlen_fastcall(x)` (__z88dk_fastcall, HL) so clang's HL-passing matches; but SimplifyLibCalls synthesizes `strlen` BY NAME, bypassing the header macro -> hits stack-ABI `_strlen` -> garbage (strlen("Hello")=1200). So a per-libfunc table maps strlen to its real stack ABI (or the fastcall alias), NOT "unconventioned default". One default fixes puts but breaks the fastcall routines -> just trades one mismatch for another.
That heterogeneity is why classic uses per-function bridge shims (__ZPROTO/_callee); synthesized libcalls bypass those shims and -ffreestanding blocks that path. CONSEQUENCE: no "one default CC" fix; only (a) keep -ffreestanding, or (b) a PER-LIBFUNC CC table stamped by getOrInsertLibFunc + the SemaDecl.cpp:3902 fix (needs a real clang frontend flag; -mllvm doesn't reach Sema).

## Fix scope: backend CCs ALREADY exist -> flag-driven per-libfunc table (2026-08-11)
GOOD NEWS: no backend work needed. CallingConv.h already defines the full classic set and Z80CallLowering.cpp lowers all: Z80_SmallC=132 (__smallc), Z80_SmallCCallee=133 (__smallc __z88dk_callee / *_callee), Z80_Z88dkFastCall=130 (__z88dk_fastcall, strlen redirect), Z80_SDCCCall0=128, Z80_Z88dkCallee=131. Missing = only middle-end/frontend plumbing to STAMP the tag on synthesized/builtin libcalls.
A "which attribute on these routines" flag must be a PER-LIBFUNC PROFILE SELECTOR, not one uniform attribute (heterogeneous clib). Built-in table maps e.g. puts->132, fputc->132, strlen->130 (fastcall alias, matches clang HL), memcpy/strcpy->133. __vasmallc NOT needed (printf->puts drops variadic; synthesized puts is plain Z80_SmallC).
Delivery = ONE driver flag expanding to TWO sites: (1) middle-end: new LibFunc->CallingConv::ID map in TargetLibraryInfo (analogous to CustomNames; VecDesc CC is vector-ABI, unrelated) that getOrInsertLibFunc stamps via F->setCallingConv (same pattern as setArgExtAttr/ShouldExtI32Param); emit* helpers propagate for free. (2) frontend: Sema builtin-CC-drop (SemaDecl.cpp:3902) gated by a real clang LangOpt — -mllvm does NOT reach Sema (so -z80-float-sdcccall0's -mllvm-only precedent is insufficient). Net: (a) TLI per-libfunc CC table, (b) driver flag (always-on on zcc classic path) populating it, (c) matching Sema LangOpt. Then -ffreestanding can be dropped safely for the ~20% printf win. Still gated on whether the win is worth upstream churn vs keeping -ffreestanding.

## Hosted-optimization catalog + SAFE group-C folds (2026-08-11)
Dropping -ffreestanding unlocks (SimplifyLibCalls.cpp optimizeCall + optimizeStringMemoryLibCall, all gated by isCallingConvCCompatible):
- A. printf/stdio: printf->puts/putchar/iprintf/__small_printf, sprintf/snprintf/fprintf, fwrite/fputs->fputc, perror, exit.
- B. string/mem: strcat strncat strchr strrchr strcmp strncmp strcpy stpcpy strlcpy stpncpy strncpy strlen strnlen strpbrk strndup strspn strcspn strstr memchr memrchr bcmp memcmp memcpy memccpy mempcpy memmove memset realloc wcslen bcopy.
- C. int/char folds (fold to inline/constant, NO libcall): abs/labs/llabs, ffs/fls, isdigit/isascii/toascii, atoi/atol + strtol/strtoul on constant string.
- D. math: pow exp2 log sqrt + unary FP.
DECISIVE SPLIT: group C folds to inline/constant -> NO clib call -> CC-SAFE on classic today. Groups A/B/D substitute a DIFFERENT clib call with the wrong CC -> runtime garbage -> need the per-libfunc CC table. The big printf->puts ~20% win is in the UNSAFE half.
MEASURED group-C gain (clang 23.0.0git, --target=z80 -Os, testcase saved in session files issue57_foldtest.c): banner_len strlen("Hello, world!") freestanding `ld hl,str; jp _strlen` -> hosted `ld de,13; ret`; strcmp("abc","abc") -> `ld de,0`. .text 21->12 B, .rodata 25->0 B, own-object 46->12 B (-74%), plus eliminated _strlen/_strcmp/asm_strlen at link. IMPLICATION: group-C folds could be enabled selectively (they're safe) even while keeping the group-A/B substitutions off — a partial win with zero CC work.

## CORRECTION: per-libfunc table NOT required — uniform __smallc suffices (2026-08-11)
Over-generalized earlier. A synthesized/substituted libcall links the BASE symbol (_puts/_strlen/_memcpy), never the _callee/_fastcall variants (those are alternate entries picked by z88dk HEADER MACROS for source calls; synthesis is post-macro). Verified base symbols in libsrc/**/sccz80/*.asm: strcpy/strcmp/strchr (pop/push), memcpy/memset/memcmp (ld hl,sp+2), strlen (pop) — ALL stack args, caller-cleanup, return in DE = one convention = __smallc (cc132). z88dk classic lib is built with ONE (small-C) convention; _callee/_fastcall are just faster alternate entries.
=> For CORRECTNESS a single uniform CC (cc132) on synthesized libcalls is enough; it even fixes strlen (stack-passed pointer matches _strlen instead of clang's HL->1200 garbage). A per-libfunc table is only an OPTIMIZATION (hit strlen_fastcall=HL smaller/faster, *_callee=callee-cleanup saves caller bytes), NOT required. Caveat (not exhaustive): checked 8 common base symbols; if any emitted target exists ONLY as fastcall/register with no stack base it'd need special handling — none found. Net: middle-end fix = one target/flag-provided default CC (cc132) + the SemaDecl.cpp:3902 LangOpt; per-libfunc table deferred as later optimization.

## Standard flags? (2026-08-11)
For stamping __smallc on synthesized libcalls: NO standard flag fits. `-fdefault-calling-conv=` (LangOpt DefaultCallingConvention: cdecl/fastcall/stdcall/vectorcall/regcall/rtdcall) has NO Z80/smallc value (=smallc -> "unknown argument") AND is frontend-only (doesn't reach middle-end SimplifyLibCalls synthesis). RTLIB getLibcallCallingConv covers only compiler-rt/softfloat, not C-lib SimplifyLibCalls. So the real fix needs a NEW flag (precedent: -mllvm -z80-float-sdcccall0) plumbed to getOrInsertLibFunc + SemaDecl.cpp:3902 LangOpt.
PARTIAL WIN via STANDARD flag TODAY: `-fno-builtin-<name>`. Verified hosted --target=z80 -Os: `-fno-builtin-printf` -> banner() keeps _printf (hazardous printf->puts BLOCKED) while len() strlen("Hello") still folds to `ld de,5`. Recipe: compile hosted (drop -ffreestanding) + `-fno-builtin-printf -fno-builtin-sprintf -fno-builtin-snprintf -fno-builtin-fprintf -fno-builtin-puts -fno-builtin-fputs -fno-builtin-fwrite` to keep only the CC-safe group-C constant/inline folds (strlen/strcmp/abs/isdigit of constants). Zero backend/CC work; the ~20% printf->puts win still needs the new __smallc flag.

## EMPIRICAL PROOF stamping cc132 works (2026-08-11)
Same printf("boot\n") (return discarded), hosted, --target=z80 -Os. puts=default C -> `ld hl,L_str; jp _puts` (arg in HL, WRONG). puts=__attribute__((z80_smallc)) + referenced -> `ld hl,L_str; push hl; call _puts; pop af; ret` (stack arg, caller-clean = CORRECT __smallc). Transform (printf->puts, ~20%) fired in BOTH; only case B is ABI-correct. A flag automates the two manual steps (declare __smallc + keep referenced) via getOrInsertLibFunc stamping cc132 on the fresh decl. Fix direction validated.
