---
name: reference-z88dk-symbol-encoding
description: Length-prefixed symbol mangling for dotted names in z88dk z80asm format, collision guarantees with C identifiers, and the _ prefix preventing MC temporary symbol EXTERN suppression.
metadata:
  type: reference
---

# z88dk Dotted Symbol Encoding (`_`-prefixed length encoding)

## Problem

In `z88dk`'s assembler (`z80asm`):
1. `.` is an expression operator (cannot appear in symbol identifiers).
2. `@` introduces local labels (scope-limited, cannot be exported or referenced across modules).
3. LLVM frequently produces dotted symbols:
   - Module-internal static locals in C: `static int counter;` in `test()` -> `@test.counter`.
   - String literals: `"hello"` -> `@.str`.
   - External symbols in LLVM IR or via `__asm__`: `@ext.var`.

## Mangling Algorithm (`encodeDottedName`)

Located in `llvm/lib/Target/Z80/Z80TargetObjectFile.cpp`:
1. Check if the prefixed symbol contains `.`. If not, return unchanged.
2. Initialize encoded buffer with `"_"` prefix (avoids `"L"` which is `PrivateGlobalPrefix`).
3. Split string at `.` into parts via `StringRef::split(SmallVectorImpl<StringRef>&, '.')`.
4. Stream `<length>_<part>` for each segment via `raw_svector_ostream`.
5. Empty parts are preserved (e.g. trailing dot or consecutive dots).

### Worked Examples

- `@test.counter` (prefixed as `_test.counter`) -> `_` + `5__test` + `7_counter` = `_5__test7_counter`
- `@.str.1` (prefixed as `L_.str.1`) -> `_` + `2_L_` + `3_str` + `1_1` = `_2_L_3_str1_1`
- `@a..b` (prefixed as `_a..b`) -> `_` + `2__a` + `0_` + `1_b` = `_2__a0_1_b`
- `@end.` (prefixed as `_end.`) -> `_` + `4__end` + `0_` = `_4__end0_`

## Collision Guarantees

Every encoded dotted symbol begins with `_<digit>`:
- In C, identifiers match `[a-zA-Z_][a-zA-Z0-9_]*`.
- Prefixed with C's global `_`, every ordinary C identifier begins with `_[a-zA-Z_]`.
- The second character of an ordinary C symbol in assembly is NEVER a digit `0-9`.
- Therefore, `_<digit>` is mathematically disjoint from all ordinary C identifiers.

## LLVM MC Temporary Gotcha (`L` vs `_`)

- LLVM Z80 data layout uses `m:o` (Mach-O mangling mode) with `PrivateGlobalPrefix = "L"`.
- If mangled symbols start with `"L"` (e.g. `L5__test...`), `MCSymbol::isTemporary()` returns true.
- `Z80AsmPrinter::emitEndOfAsmFile()` skips temporary symbols when emitting `EXTERN <sym>`:
  ```cpp
  for (const auto *Sym : ExternalSymbols) {
    if (Sym->isTemporary())
      continue;
    OutStreamer->emitRawText(ExternDirective + Sym->getName());
  }
  ```
- With `"L"`, external dotted symbols produce no `EXTERN` declaration in assembly, causing `z80asm` link errors (`undefined symbol: L4__ext3_var`).
- With `"_"` prefix, `MCSymbol::isTemporary()` is false, `EXTERN` is emitted correctly, and multi-file linking succeeds.

## Upstream References

- PR: `llvm-z80/llvm-z80#84` ("Better symbol encoding for Z88dk z80asm")
- Discussed in `llvm-z80/llvm-z80#58` and review comments on #84.
