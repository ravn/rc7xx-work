# BUG (FIXED): sret setup skipped for no-argument functions returning > 4 bytes

- **Upstream issue:** ravn/llvm-z80 — *(to be filed for traceability; number TBD)*
- **Status:** **FIXED** 2026-07-17 in ravn/llvm-z80 commit `74378e7a78cc`
  (branch `fix-sret-noarg-return`, not yet pushed/merged).
- **Regression test:** `llvm/test/CodeGen/Z80/sret-noarg-return.ll` (lit, green).
- **Component:** ravn/llvm-z80 backend — `Z80CallLowering::lowerFormalArguments`.
- **Severity:** high — legalizer crash or corrupt sret for a whole class of
  functions (any no-arg function returning `double`/`i64`/large struct).

---

## 1. One-line

`Z80CallLowering::lowerFormalArguments` early-returned for any function with no
formal arguments, **before** the sret-demotion block. A no-arg function returning
more than 4 bytes therefore never had its hidden sret pointer set up
(`FLI.DemoteRegister` stayed `$noreg`), so the return store lowered to a store
through a null base — legalizer crash (`unable to legalize G_STORE s16 into
unknown-address + 6`) or corrupt sret.

## 2. Root cause (verified)

The guard was:

```cpp
if (F.arg_empty() && !IsVarArg)
    return true;   // skipped the sret-demotion block below
```

`canLowerReturn` returns true only when the return fits in <= 4 bytes; a `double`
(8 bytes) makes it false, meaning the sret-demotion block (which sets
`FLI.DemoteRegister = SRetReg`) MUST run. But the early-return fired first for
no-arg functions and skipped it.

## 3. Fix

`llvm/lib/Target/Z80/Z80CallLowering.cpp` — only skip when there is genuinely
nothing to lower, i.e. also require `FLI.CanLowerReturn`:

```cpp
if (F.arg_empty() && !IsVarArg && FLI.CanLowerReturn)
    return true;
```

## 4. Red-green

`sret-noarg-return.ll` has three no-arg functions returning > 4 bytes. Pre-fix:
legalizer crash / missing sret store. Post-fix: CHECKs for the sret pointer read
from the stack (`ld c,(ix+4)` / `ld b,(ix+5)`), the `5.0` high word
(`ld de,16404` = `0x4014`), the i64 low word (`ld de,5`), and `ret` — all green.

## 5. Discovery context

Found while bringing up `double` via the Berkeley-SoftFloat closure: a no-arg
`double mkfive(void){ return 5.0; }`-shaped helper crashed the legalizer.
Distinct from the still-open int→double corruption
(`bugs/f64_int_to_double_miscompiled.md`).
