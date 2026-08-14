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
