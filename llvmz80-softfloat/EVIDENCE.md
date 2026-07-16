# EVIDENCE.md — verified probes behind the README claims

Every claim in README.md is backed by a command + output captured on the
macbook (2026-07-15, llvm-z80 build-macos clang "23.0.0git"). Reproduce with
the snippets below. "Verified" = observed to fail if the claim were false.

## 1. Our clang emits IEEE-754 with standard compiler-rt libcall names
```
$ clang --target=z80 -S -O2 (float sizeof)     -> float=4, double=8
$ clang --target=z80 -S -O2 (double a+b)        -> call ___adddf3
$ clang --target=z80 -S -O2 (double ops set)    ->
    ___adddf3 ___subdf3 ___muldf3 ___divdf3 ___eqdf2 ___ltdf2
    ___extendsfdf2 ___truncdfsf2 ___fixdfsi ___floatsidf
```

## 2. z88dk provides none of them (runtime float is non-functional)
```
$ zcc +cpm -compiler=llvmz80 (runtime float mul/add/cmp/cast)
    frt.c: error: undefined symbol: ___mulsf3
                                    ___addsf3
                                    ___fixsfsi
                                    ___gtsf2
```
Constant-folded float "works" only because no libcall is emitted (compile-time).

## 3. Integer runtime is ALSO partly missing
```
$ zcc ... (unsigned long long a*b)  -> undefined symbol: ___muldi3   (64-bit mul)
$ zcc ... (unsigned long   a*b)     -> undefined symbol: ___mulsi3   (32-bit mul)
$ zcc ... (unsigned        a*b)     -> LINKS                         (16-bit inlined)
```
=> Phase-2 mantissa multiply must be built from 16-bit multiplies.

## 4. Verified ABI for the libcalls (from generated asm)
```
$ clang --target=z80 -O1 -S abi.c
  _cmp:  ... call ___gtsf2 ; ld a,d ; rlca ; ... ; ld e,a ; ld d,0 ; ret
         => __gtsf2 returns a 16-bit int in DE; >0 means a>b
  _cvt:  ... jp ___fixsfsi           (int  return, uses low 16 bits)
  _cvtl: ... jp ___fixsfsi           (long return, same call)
         => __fixsfsi returns 32-bit
```
Shims are compiled by the SAME clang with the same C signatures, so the
arg/return register layout matches automatically — no hand register matching.

## 5. How CE-Programming/ez80-clang wires float (source-verified)
`CE-Programming/llvm-project` branch `z80`,
`llvm/lib/Target/Z80/Z80ISelLowering.cpp` (`setLibcall(...)`):
```
ADD_F32 -> "_fadd" (Z80_LibCall_L)   ADD_F64 -> "_dadd" (Z80_LibCall)
MUL_F32 -> "_fmul"                    MUL_F64 -> "_dmul"
FPTOSINT_F32_I32 -> "_ftol"          FPEXT_F32_F64 -> "_ftod"
SQRT_F64 -> "sqrtl"  SIN_F64 -> "sinl"  (libm = *l; long double == double)
```
Runtime: `CE-Programming/toolchain/src/softfloat/` = Berkeley SoftFloat (BSD,
"Regents of the University of California", John R. Hauser, Release 3e);
f32 path is hand asm `src/libc/float32_*.src` (eZ80 ADL); `%f` =
`src/libc/printf/nanoprintf.c` (0BSD/Unlicense). => custom names + custom CC + ADL asm are
NOT reusable; the SoftFloat C core and nanoprintf ARE.

## 6. NEW verified bug — llvm-z80 branch relaxation emits out-of-range `jr`
Filed as **ravn/llvm-z80#267** (repro: `bugs/jr_out_of_range.c`).
Compiling this file's `sf_add` at -Cg-O1/-O2/-O3/-Os makes clang emit e.g.
`jr nc,.LBB3_15` whose target is ~132 bytes away; the z88dk assembler rejects
it: `error: integer range: $84` (0x84 = 132 > 127). It is present in **clang's
own** `--target=z80 -O2 -S` output (not introduced by the z88dk bridge), and
the same function contains correct `jp` for other far branches — so relaxation
is inconsistent, not absent.
```
-Cg-O0 : integer-range errors = 0     <- workaround: build the lib at -O0
-Cg-O1 : 3
-Cg-O2 : 3   (before splitting: 3)
-Cg-O3 : 4
-Cg-Os : 2
```
Candidate llvm-z80 issue (own repo — file freely). Minimal repro: this sf32.c.
Prototype dodges it by compiling the lib at -O0 (correctness unaffected).

## 7. Phase 1 result
```
$ ./tests/run.sh
  host self-test: trials=2000000 add_bad=0 cmp_bad=0 fix_bad=0
  Z80 (ticks):    s=5 d=1 e=105 f=94 / gt=1 lt=0 eq=1 / acc=35 / RESULT: PASS
```

## 8. Phase 2 (multiply/divide) — verified
`__mulsf3` = shift-add `mul24` (24×24→48 into uint64; 64-bit add/shift link,
32-bit `*` would need the missing `__mulsi3`). `__divsf3` = restoring long
division (27 quotient bits; avoids the missing `__udivsi3`/`__udivdi3`).
Confirmed the lib object pulls in **no** `__mulsi3`/`__muldi3`/`__udiv*`.
Also fixed `sf_pack` subnormal rounding: it now denormalizes *before* rounding
with a proper sticky bit (the old truncation lost up to 1 ULP — invisible to
add, but mul/div underflow into subnormals far more often and exposed it).
```
$ ./tests/run.sh
  host self-test: trials=2000000 add_bad=0 cmp_bad=0 fix_bad=0 mul_bad=0 div_bad=0
  Z80 ft_add (ticks): ... RESULT: ft_add PASS
  Z80 ft_mul (ticks): m=3 q2=25 sq=9 r=2 / qq=1 pacc=1024 / RESULT: ft_mul PASS
RED (no lib): undefined symbol ___mulsf3, ___divsf3  (link fails as expected)
```

## 9. Phase 3 blocker — 64-bit GLOBAL initializers truncated (ravn/z88dk#27)
Filed https://github.com/ravn/z88dk/issues/27 (ravn's own repo, no permission needed).
- Symptom: `unsigned long long g = 0x4008000000000000ULL;` (global, static init)
  reads back as 0 on target; runtime stores are fine. Table:
  BIG 0x4008.. -> got `0 0` (want `0 1074266112`); MID 0x1_00000000 -> `0 0`
  (want `0 1`); SMLL 0x7 -> `7 0` ok; RUN (runtime store) -> `0 1074266112` ok.
- Root cause (verified 3 ways):
  1. raw `clang --target=z80 -S` emits correct 8-byte `.quad`.
  2. z88dk `DEFQ` is 4 bytes: `DEFQ 0x11223344`+`DEFB 0xAA` -> 5 bytes `44 33 22 11 aa`.
  3. bridge rule `z88dk/lib/llvmz80/llvmz80_rules.1` (~L99): `.quad %1` -> `DEFQ %1`
     `DEFQ 0`; the 64-bit `%1` is truncated to low 32 by the 4-byte DEFQ and the
     real high 32 is overwritten by the padding 0.  (`.long %1 -> DEFQ %1` is fine.)
- NOT the llvm-z80 backend (clang's `.quad` is correct); it is the copt bridge.
- Repro: bugs/quad_global_init_truncated.c (RED verified).
- Consequence for SoftFloat f64: `volatile double`/`long long` globals with high
  bits init to garbage -> explains wrong values (and the shim hang on garbage input).
