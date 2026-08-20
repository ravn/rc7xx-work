# CP/M-86 `.CMD` static checker + far-heap/far-data layout constraint

Created 2026-08-19 (macbook). Tool: `open-watcom-v2/contrib/ravn/cmd_check.py`.

## What the checker is

A static linter for CP/M-86 `.CMD` load files. It parses the 128-byte header's
eight 9-byte group descriptors (G_TYPE/G_LENGTH/A_BASE/G_MIN/G_MAX, see
`reference_cpm86_cmd_header.md`) + the fixup table (`reference_cpm86_p_load_fixups.md`)
and flags known-bad layouts WITHOUT running the program. Complements the runtime
oracle `watcom-cpm86-libc/test/compact_farheap_test.c` (which now has 7 checks
c1..c7) and, above both, the DEFINITIVE oracle DR C.

Usage:
```
python3 contrib/ravn/cmd_check.py X.CMD                 # strict (current farheap.c)
python3 contrib/ravn/cmd_check.py --heap-starts-at-min X.CMD   # models the fix
python3 contrib/ravn/cmd_check.py --map X.map X.CMD     # + near-arena (F2) check
```
Exit 0 = OK, 1 = FAIL, 2 = parse/usage error. Wired into
`build-compact-farheap.sh` as an automatic gate.

Checks: **F1** far-heap/far-data overlap (primary), **F2** DGROUP >64 KB and (via
--map) the near-arena-in-FAR_DATA base-page-clobber regression, **F3** malformed
descriptors, **F4** fixup-table sanity.

## The far-heap/far-data layout constraint (F1) -- the real design bug

Our compact-model design coalesces a program's far data/BSS AND the
`OPTION FARHEAP` reservation into the SAME type-3 EXTRA group. In the group
descriptor: far data+BSS occupy Extra paragraphs `[0, G_MIN)`; the heap headroom
is `[G_MIN, G_MAX)`. But `port/farheap.c` `__AllocSeg` carves heap slabs starting
at Extra paragraph **0** -> the first far `malloc()` hands out memory ON TOP of
the program's far data -> silent corruption.

- SAFE under the CURRENT (carve-from-0) farheap.c iff the Extra group holds NO
  far data: `G_LENGTH==0 AND G_MIN<=1`. This is exactly why SMALL-model far heap
  works (all program data is near/DGROUP, so Extra is heap-only) and COMPACT does
  not (module data defaults far -> lands in Extra).
- The FIX direction (validated by `--heap-starts-at-min`): make farheap.c carve
  from `G_MIN`, not 0. Problem: the base page carries only the Extra TOTAL and
  segment, NOT G_MIN, so the far-data boundary must be communicated another way --
  put the heap in its OWN group (separate base-page descriptor), or emit a
  linker symbol for end-of-far-data. NOT YET IMPLEMENTED.

## DR C (the definitive oracle) does NOT cover this case

Ran the checker on genuine DR C large-model binaries (`DRC.CMD`, `LINK86.CMD`,
`drc861.cmd`, `r.cmd`): they have **DGROUP up to the full 64 KB and NO Extra
group at all**. DR C large model keeps all data in DGROUP and never puts far data
+ far heap in one Extra group. So DR C's shipped binaries are NOT a direct oracle
for the >64 KB far-data + far-heap case UnZip needs -- that is genuinely new
territory. `mame-tests/LL_l.CMD` (our large-model build) DOES have `G_MIN=128`
far BSS + heap, so it trips F1 too (same latent bug; passes under
`--heap-starts-at-min`).

## What DR C actually does with >64 KB (definitive -- resolves the fix direction)

DR C Language Programmer's Guide §2.4.2 (see `reference_cpm86_big_model.md`):
DR C's "big" model is *"for programs that use a **maximum of 64K bytes of
data**, a maximum of 64K bytes of stack, but require a large code section and
heap. ... The **heap data occupies the extra segment**."* So DR C's answer to
">64 KB":
- **Static/global DATA is HARD-CAPPED at 64 KB (near DGROUP).** DR C has NO
  >64 KB data segment and NO `far` data qualifier (K&R era) -- you cannot
  declare a >64 KB static array.
- The only things that grow past 64 KB are **CODE** (many <=64 KB segments
  concatenated by LINK-86 into one Code section, far calls) and the **HEAP**
  (Extra/ES group, ~1 MB, `malloc`-allocated, adjustable at link time).
- Therefore the **Extra group is HEAP-ONLY** -- no program static data lives in
  it, which is exactly why DR C hands out heap from Extra paragraph 0 with no
  overlap.

**Strategic consequence.** Our F1 bug is a DIVERGENCE from DR C introduced by
using Watcom `-mc` (compact), which forces ALL static data FAR -> into the Extra
group alongside the heap. The DR-C-FAITHFUL design keeps Extra heap-only (exactly
what makes SMALL-model far heap already pass): static data stays in near DGROUP
<=64 KB, and any big buffer (UnZip's 32 KB inflate window) is `malloc`-allocated
into the Extra heap rather than declared static. That DISSOLVES F1 instead of
patching farheap.c to skip G_MIN. If a program's *static* data genuinely exceeds
64 KB it is beyond DR C's model and must be restructured to heap-allocate.
Recommended UnZip path: small/medium model + heap-allocate the window (keep total
static <=64 KB), NOT `-mc` far-everything. (An inconclusive `CPM86_FH_SKIP_PARAS`
experiment carving from G_MIN was tried and reverted; the right fix is upstream
of farheap.c.)

## Concrete numbers observed

- Buggy compact test `CFHT.CMD`: Extra G_LENGTH=512 G_MIN=512 G_MAX=12800 -> F1.
  Runtime: `C 1101001` (c3=0 malloc seg==DS after corruption, c5=0 far canary
  clobbered, c6=0 near heap). Load-time DS=0x10de but the corrupted `ds` local
  printed 0x1231 (== Extra seg) -- evidence the heap/data collision scrambled
  DGROUP/stack.
- Small-model `FHSMALL.CMD`: Extra G_LENGTH=0 G_MIN=1 G_MAX=12288 -> OK (heap-only).

## Related fix already applied this session

`port/lowlevel.c`: `wc_arena` now `static char __near wc_arena[...]` with a
model-aware size (compact/large/huge = 4096; small/medium = 36352) so the near
arena stays in DGROUP (fixes the base-page clobber; small-model regression test
still PASS). The far-data/far-heap overlap above is a SEPARATE, still-open bug.
