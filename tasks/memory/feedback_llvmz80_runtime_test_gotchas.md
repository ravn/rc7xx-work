---
name: feedback_llvmz80_runtime_test_gotchas
description: Authoring llvmz80 end-to-end runtime tests — use -Cg-O2 (not -O2) for clang opts, and verify const data in the shell (C-side compares fold).
metadata:
  type: feedback
---

Two non-obvious traps when writing `zcc +cpm -compiler=llvmz80` end-to-end
runtime tests (e.g. `z88dk/test/clang/runtime_*.sh`):

1. **`-O2` is NOT clang -O2 in zcc.** Bare `-O2` sets the z88dk-side level
   (copt/z80asm/appmake) and leaves clang at -O0; use **`-Cg-O2`** to pass -O2
   to the code generator (clang). This matters for what clang emits: e.g.
   clang's mergeable `.rodata.cstN` constant sections appear ONLY at clang -O2;
   at -O0 const arrays go to plain `.rodata`. A test targeting an -O2-only
   codegen feature built with bare `-O2` passes VACUOUSLY. Verify with
   `zcc ... -Cg-O2 -a x.c` and read `x.c.asm`.

2. **A C-side `x[i]==LITERAL` check on a `const` array constant-folds.** LLVM
   knows the const global's contents, so the compare is folded to true at
   compile time even when the bytes were dropped from the binary at link/asm
   time — the test reports OK while `printf` of the same load correctly shows 0.
   Route the check through the SHELL: `printf` the loaded values (a real
   volatile-indexed load is emitted) and `grep` the expected lines in the `.sh`.
   Index with a `volatile int` so the load isn't folded away either.

Both were hit building the ravn/z88dk#30 guard `runtime_rodata_cstn.c`
(.rodata.cstN survival). See also [[project_double_is_float32_retire_softfloat]]
and [[feedback_use_math32_flag]]. Build llvmz80 float/runtime tests against the
**classic** clib, not newlib ([[reference_z88dk_direction_classic_not_newlib]]).
