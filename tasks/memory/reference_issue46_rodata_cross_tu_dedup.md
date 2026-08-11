# ravn/z88dk#46 — cross-TU rodata/string dedup gap (missed-opt, OPEN)

**Status (2026-08-11): investigated, verified, plan posted; NOT implemented. OPEN.**

Missed optimization (size-only, no correctness effect): the llvmz80 -> z88dk
pipeline does not deduplicate identical mergeable read-only data across object
files. clang emits `.section .rodata.cstN,"aM",@progbits,N` (SHF_MERGE + entsize)
and `.rodata.str1.1` for strings; the copt bridge
(`lib/llvmz80/llvmz80_rules.1`) collapses all of them to a single `SECTION
rodata_compiler`, dropping the merge attribute/entsize, and z80asm's linker only
concatenates modules (no dedup).

**Verified scope — strictly cross-TU** (within-TU pooling already works via clang):
- same 16B const table in 2 TUs -> 2 copies in the image (not merged)
- same string literal in 2 TUs -> 2 copies (str1.1 also not deduped)
- same string twice within 1 TU -> 1 copy (clang pools)

**Feasibility:** the hard part of any fix is a **relocation-aware** dedup in
z80asm's linker (collapse identical entries, then rewrite every symbol/reloc to
the survivor) — substantial + risky. The 'easy half' (route cstN/str to
dedicated sections preserving entsize) is NOT safe to land alone: any new
section must be added to the crt memory map
(`crt/newlib/crt_memory_model_z80.inc`) or it hits the #30 silent-drop bug.

**Feasibility — refined after reading z80asm internals (2026-08-11):** LESS bad
than "relocation-aware rewrite". z80asm has no dedup/COMDAT (only merge_modules
= concat). BUT internal refs are symbol + link-time-expression based, NOT baked
offsets: a const table keeps a LOCAL symbol (e.g. `_fa_t`) and each use is an
expression `E W ... _fa_t` patched at link. So dedup = symbol-redirection +
section compaction (repoint duplicate module's local symbol to survivor, drop
bytes) — no need to rewrite patched code. Verified via `z88dk-z80nm a.o`.
Real blocker: the copt bridge (`lib/llvmz80/llvmz80_rules.1`) funnels all
`.rodata.cstN`/`.str1.1` into one `rodata_compiler` AND strips `.size`, so block
size/entsize is lost → a dedup pass must infer boundaries from consecutive local
symbols (fragile) unless the bridge is changed to preserve size. Concrete design:
(1) bridge preserves per-block size, (2) link pass folds identical blocks by
repointing local symbols + compacting rodata.

**Recommendation:** keep open, do not implement speculatively; gate on a concrete
production-size measurement (scan a linked production image for duplicated
rodata/string blocks). On 2KB-PROM targets (autoload, cpnos) each image is
single-TU-dominated so cross-TU duplication is expected small. Related: #30
(section-drop fix), #45 (warn on drop). Guard: test/clang/runtime_rodata_cstn.c.

## CRITICAL SCOPING (verified 2026-08-11): only the z80asm path is affected
`z80asm` here = z88dk's OWN assembler/linker (`z88dk/src/z80asm`), reached via
`zcc +cpm -compiler=llvmz80`. It is NOT from llvm-z80. llvm-z80 ships clang +
**ld.lld**, and ld.lld DOES dedup SHF_MERGE (verified: same 2-TU repro linked
with ld.lld -> constant appears ONCE; via z80asm -> TWICE). The 2KB-PROM
production firmware links with ld.lld, not z80asm (autoload-in-c Makefile
`CLANG_LD=.../ld.lld`, cpnos-in-c `LD=.../ld.lld`), so production ALREADY gets
cross-TU merge for free. #46 duplication is confined to the z88dk `zcc +cpm`
toolchain path. This lowers priority further — production is unaffected.
