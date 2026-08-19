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

## MAME rc759 verification (fully authoritative) — DONE 2026-08-19

Both a wlink-native and a DR C reference build were booted on the genuine
SW1400 Concurrent CP/M-86 3.1 turnkey disk in the MAME rc759 driver (the real
loader applies the fixup records), installed as the autostart `menu.cmd`, and
each printed `OK!` then `....` on the PICCOLINE console and signalled
`DONE-SIGNAL word=0x0008 pass=8 fail=0` (OUT 0x2FE io-tap, `done_signal.lua`):
- **wlink's OWN output** (`test_stageb_farptr_mame.c` + `test_stageb_crt759.asm`)
  — the decisive check: exercises the exact fixup records wlink emits on real
  hardware. `crt759.asm` is a minimal CP/M-86 crt0 distilled from `load.sup`
  (base-page reservation; entry at CS:0; loader hands a small stack via
  `u_initss=lod_lstk`/`ls_sp` + a RETF frame to `user_retf`, so we switch to our
  own roomier DGROUP stack, as DR C's CLEARL does).
- **DR C 1.11 reference** (`test_stageb_farptr_drc.c` + `test_stageb_done_far.asm`)
  — "how it SHOULD be done": DR C's default LARGE model is genuinely
  far-code/far-data, LINK-86 emits the same fixup format, the loader relocates.
  Independent period-correct compiler confirming the oracle methodology.
- MAME loader entry state (verified from `load.sup`): CS:IP = code-group:0000
  (no entry field; IP=0 for non-8080), DS=ES=base-page (first DATA group),
  SS:SP = system loader stack. `mame_done()`/`mame_ok`/`mame_bad` = far OUT to
  the undecoded port 0x2FE; `#pragma aux` works on the wcc path, a small FAR asm
  stub is needed on the DR C path. Reproduction + evidence in
  `open-watcom-v2/contrib/ravn/README_stageb_tests.md`.

## Still to do
Medium-model clib/crt0 so `owcc -mcmodel=m` links a full program (currently
small-model only; `crt759.asm` is the minimal freestanding stand-in); UnZip
`-mm -zm` port verified with the pointer-memory oracle + MAME.

## UPDATE 2026-08-19 — medium clib/crt0 + one-command owcc (16-bit `dos` convention)
Medium-model clib/crt0 DONE and verified. `MODEL=m ./build-lib.sh` builds
`lib286/cpm86/clibm.lib` (far code; per-function `*_TEXT` coalesced to one CODE
group). `mediumtest.c`+`mediumtest_b.c` (cross-segment far calls + DATA→CODE far
fn pointers + printf) run end-to-end under the Unicorn loader oracle: `medium
clib: 6 far calls, 0 fail` / PASS.

**One-command `owcc -bcpm86 -mcmodel={s,m}` now works, following Open Watcom's
16-bit `system dos` convention (NO `libfile`).** Key move: the crt0 entry lives
in the front-sorted `BEGTEXT` segment, so `option dosseg` keeps `_cstart_` at
code-group offset 0 (the .CMD fixed CS:0000 entry — no entry-point field) EVEN
when the startup is pulled as a plain **library member**. So crt0 is archived
into `clibs.lib`/`clibm.lib`; `format cpm86`'s implicit `_cstart_` start pulls
it FIRST from whichever model lib the object's default-library record
(`clibs`/`clibm`) auto-fetches. Model selection is automatic — ZERO owcc change,
one `system cpm86` block. (Gotcha: the compiler `-zl` flag SUPPRESSES the
default-library record → no auto-fetch; user programs must be compiled WITHOUT
`-zl` for the one-command link. The clib objects themselves keep `-zl` so the
stock DOS clib is never pulled.)

Changes: `bld/wl/lnk/specs.sp` — removed `libfile cstartcpm.obj`. crt0 sources
→ BEGTEXT: contrib `port/crt0sm.asm`+`crt0mm.asm`, standard-build
`bld/clib/_cpm/a/cstartcpm.asm`; `bld/clib/_cpm/objects.mif` now archives
`cstartcpm.obj`. Standalone `cstartcpm.obj`/`cstartmm.obj` kept for the
explicit-`file` demo scripts. **Standard build has only the SMALL (`ms`) cpm86
model wired; the MEDIUM (`mm`) standard-build integration (mm dirs across the
merged msdos.086 components) is the remaining task — the contrib
`build-lib.sh MODEL=m` path already proves medium end-to-end.**
