---
name: project_upstream_tracking_issues
description: Tracking issues for pushing ravn work upstream to z88dk/z88dk and llvm-z80/llvm-z80
metadata:
  type: project
---

Oprettet 2026-09-06. Alle issues er i ravn-forks (aldrig i upstream direkte).

## ravn/z88dk — hvad kan gå til z88dk/z88dk

- [#64](https://github.com/ravn/z88dk/issues/64) — Generic z88dk fixes (fopen rb+, stdbool C23, float.h IEEE builtins, BSS out of .COM, appmake NO_GMP, zpragma)
- [#65](https://github.com/ravn/z88dk/issues/65) — zsdcc patches (sign-extension, REGPARM K&R, Apple Silicon banner, peephole orphan jp)
- [#66](https://github.com/ravn/z88dk/issues/66) — ez80-clang fixes (__preserves_regs no-op, CEdev v15 GNU-as rules, db-string corruption)
- [#67](https://github.com/ravn/z88dk/issues/67) — -compiler=llvmz80 integration (kræver RFC til z88dk/z88dk først)
- [#68](https://github.com/ravn/z88dk/issues/68) — RC700 platform som z88dk target

## ravn/llvm-z80 — hvad kan gå til llvm-z80/llvm-z80

- [#291](https://github.com/ravn/llvm-z80/issues/291) — Correctness fixes (sret frame offset, jump-table off-by-one, frame underflow, RemoveJumpToNext, FCMP width, SM83 sizes, latent miscompiles)
- [#292](https://github.com/ravn/llvm-z80/issues/292) — z88dk calling conventions (z80_smallc, fastcall, callee, cc133 composition, -z80-classic-libc-cc)
- [#293](https://github.com/ravn/llvm-z80/issues/293) — float32/double=float32 support (#277)
- [#294](https://github.com/ravn/llvm-z80/issues/294) — Infrastructure fixes (datalayout, pseudo sizing CI guard, .byte not .ascii, AutoStaticStack cross-TU; MO_MCSymbol + AggressiveInstCombine → llvm/llvm-project)
- [#295](https://github.com/ravn/llvm-z80/issues/295) — Codegen optimizations (BSS store-back peephole, loop prep, fast division, direct-addressing, divrem fusion, IDX8 fold, InstCombine narrow, ADJCALLSTACKUP, MUL_I32→fast)

**Why:** Oprettet efter upstream-merge 2026-09-05 (copilot merge) for at spore hvad der kan bidrage tilbage.
**How to apply:** Brug disse issues som checkliste når et upstream-bidrag overvejes. Husk [[feedback_no_external_issues]] — ingen upstream-PR/issue uden eksplicit per-item go-ahead.
