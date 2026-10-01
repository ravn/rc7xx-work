---
name: reference-z80asm-c-line-debug
description: C_LINE directives emitted by Z80AsmPrinter give source-level address maps in z80asm .map files; z88dk-dis -c shows source annotations in disassembly.
metadata:
  type: reference
---

## C_LINE emission (ravn/llvm-z80, 2026-10-01)

`Z80AsmPrinter::emitInstruction()` emits `C_LINE <line>, "<file::func::level::scope>"`
before each instruction when targeting z80asm format AND the instruction carries
`DebugLoc`. Requires `-g` (via `-Cg-g` under zcc).

z80asm with `-debug` converts these into `__C_LINE_<n>_<file>` address symbols
in the `.map` file — zero binary overhead in the ROM.

**Enable:** `zcc +cpm -compiler=llvmz80 -Cg-g -m -debug ...`

**Scope format:** `"file.c::func::level::scope"` — compatible with z88dk-ticks
`debug_add_cline()` for source-level debugging (`break file.c:3`, `list`).

Lit tests:
- `llvm/test/CodeGen/Z80/z80asm-c-line-debug.ll` — FileCheck at llc level
- `llvm/test/CodeGen/Z80/z80asm-c-line-e2e.test` — end-to-end: C→zcc→z80asm→ntvcm

Works with both llvmz80/clang (`-Cg-g`) and sccz80 (`-debug` always emits
C_LINE). Does NOT work with zsdcc (issue z88dk#1390, open).

## z88dk-dis -c flag (ravn/z88dk, 2026-10-01)

`z88dk-dis -mz80 -x prog.map -c -o 256 -s ADDR -e END prog`

Shows C source lines as `; file:line: text` comments before each instruction
when the source file is readable. Requires `-x map` with `__C_LINE_` symbols.

Source files are read from the filesystem using paths stored in the map file.
Up to 8 files cached. Deduplicates: comment only shown when file/line changes.

## Map file format entry

```
__C_LINE_42_file_2ec = $03D1 ; addr, local, , module, code_compiler, file.c:42
```

z88dk-ticks reads these via `debug_find_source_location(addr)` for runtime
source-level debugging (GDB MI2 interface, VS Code/DeZog compatible).
Static disassembly (z88dk-dis) also uses them when `-c` is given.
