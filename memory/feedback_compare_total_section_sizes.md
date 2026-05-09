---
name: Compare total section sizes, not per-function .text sizes
description: HARD — when sizing two compilers for the same project, sum all loaded sections; per-function `.text` sizes hide jumptables and overstate the codegen gap
type: feedback
originSessionId: 9adba288-d140-4e53-8e2b-2f1cfaedce42
---
When comparing two compilers' output sizes for the same C source, the only trustworthy number is **total bytes across all loaded sections** (`.text + .rodata + .data` + any other LMA-mapped section). Per-function `.text`-only sizes from `llvm-nm --print-size` or equivalent are misleading: a switch lowered as a `jp (hl)` + jumptable in `.rodata` will report a tiny `.text` body even when the table is 60+ B.

**Why:** This bit me badly in cpnos-rom (sessions 45-49). I repeatedly claimed "z88dk-zsdcc generates 30-50% larger code than clang per function" based on `llvm-nm`-style measurements. After Phase 50's analysis, the matched-function gap was actually **+2%**, and the real 1114 B gap was structural (cold-init code in RAM under SDCC, in PROM-only `.init` under clang). The wrong per-function comparison sent me chasing the wrong fix for many sessions.

**How to apply:**
1. For two-compiler comparisons, always start with the section-header dump:
   * clang ELF: `llvm-objdump --section-headers <elf>`
   * SDCC z88dk: parse `<file>.map` for `__<SECTION>_size` symbols
2. Sum ALL loaded sections (anything that ends up in PROM/flash/RAM image).
3. Per-function comparisons are only sound when:
   * Both compilers use the same lowering strategy (no .rodata-table-vs-inline-cmp-chain divergence)
   * Both function sizes include any .rodata data the function uniquely consumes (jumptables, string literals, format strings)
4. To attribute a clang `.rodata` jumptable to its consumer function, match `LJTI<funcid>_<index>` (LLVM's internal naming) to the function whose lowering reference uses it. Add the table size to that function's effective size.

**Concrete recipe** (cpnos-rom-shaped projects):
```bash
# clang side: total all loaded sections from payload.elf
llvm-objdump --section-headers clang/payload.elf | awk '$4 != "DEBUG" && $3 ~ /^[0-9a-f]+$/ && $5 == "TEXT" || $5 == "BSS" {sum += strtonum("0x"$3)} END {print sum}'
# SDCC side: sum from cpnos.map
grep "__.*_size" sdcc/cpnos.map | awk '{gsub(/\$/,""); print strtonum("0x"$3)}' | paste -sd+ | bc
```

**Phase 50 case:** matched per-function `text` sizes summed to 1577 B SDCC vs 1550 B clang (Δ +2%), but whole-payload was 2756 vs 1642 (Δ +68%). The 1114 B gap was almost entirely cold-init code that under clang lived in `.init` (PROM-only, 630 B section) and under SDCC lived in `RESIDENT_PRE_CODE` (RAM-resident). Recovered with an 11-line Makefile change moving 3 .c files from `RESIDENT_PRE_CODE` to `INIT_CODE`. No codegen change. Rec resident 2756 B → 2180 B (-21%).
