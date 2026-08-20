# Watcom OWN near-heap retargets to CP/M-86 via a one-function arena __brk seam — PROVEN

2026-08-14. Second milestone of the Watcom-clib CP/M-86 retarget (rc7xx-work#6,
todo `wc-lowlevel-shim`). Watcom's *genuine* near-heap runs on CP/M-86 with only
its bottom primitive swapped; run-verified under emu2 against a hand oracle.

## The one OS trap, and the swap

Watcom's small-model (`-ms`) near-heap grows DGROUP through `sbrk.c`'s `__brk`,
whose ONLY OS act is `INT 21h AH=4Ah` (`TinySetBlock` — resize the program's
memory block). `grownear.c` `__ExpandDGROUP` computes `new_brk = amount +
_curbrk` and calls `__brk(new_brk)`; the extender path is a pure DGROUP bump.

`port/lowlevel.c` (in the fork's `contrib/ravn/watcom-cpm86-libc/`) replaces
`__brk`/`sbrk` with a bump over a static `_BSS` arena and DEFINES the `_curbrk`
RT-data word `grownear.c` reads (so the linker does NOT pull `crwd086.asm`,
which drags `_psp`/`_LpCmdLine`/`_osmajor`…). NO OS call is needed: a CP/M-86
`.CMD` owns its whole TPA from the loader. `crt0sm.asm` calls `wc_heap_init`
to seed `_curbrk = &wc_arena[0]` before `main` (grownear reads `_curbrk`
BEFORE calling `__brk`, so a zero seed would corrupt the first grow).

## The genuine Watcom heap objects (all UNCHANGED clib)

`nmalloc.c` (malloc/_nmalloc/`__nheapbeg`=NULL), `nfree.c`, `calloc.c`,
`nrealloc.c`, `grownear.c` (`__ExpandDGROUP`), `amblksiz.c` (`_amblksiz`=8K),
`heapen.c` (`__heap_enabled`=1), `nheapmin.c` (`__nheapshrink`), `mem.c`
(`__MemAllocator`/`__MemFree` — the near core), `bfree.c` (`_bfree`),
`_expand.c` (`__HeapManager_expand`), `nmemneed.c`, `nmsize.c`, `nexpand.c`,
`nheapunl.c` (`__UnlinkNHeap`). Heap sources need `-i=$B/clib/heap/h` in the
INC set (`heap.h` is private there).

TRAP TO AVOID: do NOT pull `bmalloc.c`/`bexpand.c`/`growseg.c` — the *based*
allocator variant references `__GrowSeg`, which grows a segment via DOS and
would reintroduce INT 21h. The near path uses `mem.c` + `__ExpandDGROUP`.

## Proof

`build-heap.sh`: links the heap objects + `qsort` (`bld/clib/search/c/qsort.c`)
+ mem* (`bld/clib/memory/c/{memcpy,memset,memmove}.c`) against the seam into a
CP/M-86 `.CMD`, gates purity (0× INT 21h), runs under emu2, matches oracle:
`sorted: 0..9` (malloc+qsort), `calloc: 0`, `realloc: 0 40` (prefix preserved —
note p[0]=0 is the SMALLEST after sort, an easy oracle slip), `reuse: ok`.
Fork commit `bb1c7f68`. Next: stdio FILE* write-path shim, then relink stdcbench
off DR C and cross-check its reference final score 13.

## FAR heap: compact model (-mc) NOW WORKS (was BLOCKED); small + explicit _fmalloc also WORKS

> **UPDATE 2026-08-20: compact `-mc` is NO LONGER blocked.** The wlink type-3
> EXTRA fix (`09c2eb3099`, `[[reference_wlink_cpm86_far_data_type3]]`) places
> program far data in ONE loader-placeable group, so clib far globals
> (`__heap_enabled`) now read correctly and transparent far `malloc()` runs.
> `run-all-models.sh` compact heap/stdio/float all PASS
> (`[[reference_cpm86_clib_all_models_gate]]`). The paragraph below is the
> ORIGINAL (pre-fix) diagnosis, kept for history.

2026 (this session). Goal: put big buffers (UnZip's 32 KB inflate window + huft)
OUTSIDE the single 64 KB DGROUP so DEFLATE fits. Two routes:

**Transparent compact `-mc` (near code / FAR data) — [HISTORICAL] was BLOCKED at runtime.**
`-mc` makes module-level data FAR, incl. the clib's own globals
(`int __heap_enabled = 1` in heapen.c, `__fheapbeg`, `_amblksiz`) and string
literals. wlink's `format cpm86` emits that FAR_DATA as a SECOND `type=2` group.
The CP/M-86 .CMD header identifies groups by TYPE (1=code,2=data,3=extra,...); a
second type=2 collides with DGROUP and is placed by NEITHER the loader NOR
cpm86run_unicorn.py (keys its image dict + group_seg by group NUMBER). So every
clib far global reads 0 → `__heap_enabled==0` → `port/farheap.c::__AllocSeg`
early-returns `_NULLSEG` → `malloc`/`_fmalloc` return NULL. Empirically confirmed
(probe: `E0 A0000 F0000:0000`). Fixing transparent -mc needs wlink to emit
compact far-data as its OWN loader-placeable group + far-pointer relocation, PLUS
teaching the Unicorn runner to place a second type=2 — substantial linker work.
`build-lib.sh MODEL=c` still builds `clibc.lib`+`cstartcm.obj` cleanly (crt0cm.asm,
near code) as the foundation for that future work; it is NOT runtime-usable yet.

**Small model + EXPLICIT `_fmalloc` — WORKS TODAY (recommended).**
In `-ms` the clib globals + literals stay NEAR in DGROUP → exactly ONE type=2
group, no collision. A program still offloads big buffers by calling `_fmalloc()`
by name: the far heap is a separate paragraph arena (the .CMD Extra group, type=3)
carved by `__AllocSeg`, linked with `option farheap=<size>`. VERIFIED PASS under
cpm86run_unicorn.py: `test/farheap_smalltest.c` allocates 8×12 KB = 96 KB of far
blocks (>64 KB, impossible in DGROUP), fills + round-trips every byte, asserts
each block's segment != DS. Oracle script: `build-farheap-small.sh` (links against
the INSTALLED clibs.lib — proves build-lib.sh now ARCHIVES the far-heap members
`_fmalloc`/`_ffree`/`farheap.c`/… into all models; that archive gap previously
left far-heap symbols undefined). For UnZip: route the 32 KB window + huft tables
(via a `zcalloc`→`_fcalloc` shim) to the far heap, freeing ~35 KB from DGROUP.
