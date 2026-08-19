# Stage B far-code relocation: image-paragraph layout bug + base-page reservation — VERIFIED on two runtime oracles

2026-08-19. Stage B (`-mm -zm`, far code / near data, code >64K across
segments) wlink CP/M-86 load-time relocation is implemented and RUNTIME-VERIFIED
on the Unicorn oracle. Two lessons, both caught by *runtime* oracles that a
consumer-only unit test (`test_cpm86_reloc.py`, hand-fed records) could never
have caught.

## THE linker bug (fixed): far target paragraph must come from the packed image, not `grp_addr.seg`

A far reference's group-relative paragraph (the segment word the loader adds the
group base to, and the fixup record's own location paragraph) MUST be derived
from the **packed `.CMD` image layout** — the running sum of `CMD_PARAS(CalcGroupSize())`
over preceding non-empty same-class groups — NOT from `grp_addr.seg − base`.

Why: wlink's frame/segment numbers increment by **1 per segment regardless of
size**, but `FiniCPM86LoadFile` packs each code group PARAGRAPH-PADDED and
coalesces them into ONE type-1 CODE descriptor. A 54-byte function is 4
paragraphs in the image but advances the frame number by only 1. Using the frame
delta points every far reference at the wrong paragraph.

Fix: `cpm86GroupImgPara(group_entry*)` in `bld/wl/c/loadcpm86.c` walks the
`Groups` list in the SAME order/filter as the image writer, summing
`CMD_PARAS(CalcGroupSize())`. Used by both `CPM86GroupRelPara` (the far-seg word
value) and the fixup record's loc-paragraph. Discrimination proven: for a
4-target test the correct image paragraphs were {5,6,7,9} (a multi-paragraph
function creates a gap) vs the buggy frame deltas {1,2,3,4} — the buggy linker
relocated every far reference wrong.

## The base-page trap (test-side, NOT a linker bug): first DATA group starts with the base page

Genuine CCP/M-86 2.0 `kern/load.sup:477` `init_base` — "1st Data Group has Base
Page": after applying fixups the loader takes the first DATA group, **zero-fills
its first ~0x5B bytes and writes base-page descriptors there**. So anything a
program puts at DS:0000 is CLOBBERED at load. Real programs reserve it in crt0
(`cstartcpm.asm`: `BEGDATA segment / db 100h dup(0)` first in DGROUP).

A freestanding relocation test that READS low DATA (e.g. a pointer table at
DS:0000) will therefore see zeroed data and fail — a **test artifact, not a
linker bug**. Freestanding Stage B tests must link a base-page reservation
module FIRST (`contrib/ravn/test_stageb_begdata.asm`) so real data starts at
DS:0100. First symptom seen: the pointer oracle printed "????" until BEGDATA was
added; the linker's stored relocation values were provably correct all along.

## The two committed runtime oracles (`contrib/ravn/test_stageb_farcall.sh`)

Both drive the real wcc/wasm/wlink → forced-split `.CMD` → run under
`cpm86run_unicorn.py`, expected output exactly "OK!\r\n":
- **CALL** (`test_stageb_farcall.c`): CODE→CODE far calls — value-via-execution;
  fixups LOCATED in CODE (record nibble 0x1X).
- **POINTER** (`test_stageb_farptr.c`): DATA→CODE far pointers — **memory oracle**;
  follows each relocated pointer and checks the bytes there are the stub's
  expected `B8 lo hi` (`return 0xHHLL` → `mov ax; retf`), independent of
  execution flow. Exercises fixups LOCATED in DATA (record nibble 0x2X) — a code
  path the call oracle never touches. **This pointer-memory technique is the one
  to reuse for very large programs (UnZip)**: it does not require running the
  whole program, only dereferencing known far pointers and byte-checking the
  target code.
- Plus a **small-model guard**: single CODE segment must leave header byte 127
  bit 7 CLEAR (no spurious fixup table).

All three pass. Discrimination is real (the pointer oracle failed with "????"
under the base-page bug and would print wrong bytes under the paragraph bug).

## Files
- `bld/wl/c/loadcpm86.c` — `cpm86GroupImgPara` (THE fix), `CPM86GroupRelPara`,
  `AddCPM86Fixup`, `cpm86WriteFixups`, wired into `FiniCPM86LoadFile`.
- `bld/wl/c/obj2supp.c` — CPM86 capture branch in `formatBaseReloc`, seg-write
  branch in `PatchData`.
- `bld/wl/c/cmdcpm86.c` / `bld/wl/h/loadcpm86.h` — enable `LS_MAKE_RELOCS`, decls.
- `contrib/ravn/test_stageb_{farcall.c,farptr.c,begdata.asm,farcall.sh}` — oracles.
- Oracle/loader source of truth: `scratch/ccpm86-src/kern/load.sup`
  (fixup apply ~line 402-460; `init_base` ~line 477).

## Still to do
MAME (fully-authoritative oracle) verification of a real medium-model `.CMD`;
medium-model clib/crt0 so `owcc -mcmodel=m` links (currently small-model only);
UnZip `-mm -zm` port verified with the pointer-memory oracle + MAME.
