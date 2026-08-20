---
name: CP/M-86 runtime memory allocation + wlink FARHEAP knob (the RAM-sizing story)
description: How a CP/M-86 / Concurrent CP/M-86 program controls how much RAM it takes. Covers the BDOS 53-58 runtime memory-allocation calls (present in BOTH plain CP/M-86 AND Concurrent, verified from the DRI System Guide), the .CMD M/X (G-Min/G-Max) header semantics, what wlink actually exposes today (`OPTION FARHEAP=<size>`), and the recommended single user-facing RAM knob for the owcc CP/M-86 toolchain.
type: reference
metadata:
  node_type: memory
  type: reference
---

# CP/M-86 runtime memory allocation + the wlink FARHEAP knob

Context: on the RC759 / RC702-class machines CCP/M-86 is multitasking with
modest RAM — several programs coexist, so a program must NOT grab more memory
than it needs. This note captures, with citations, exactly what the OS and the
Open Watcom cpm86 toolchain expose for controlling a program's RAM footprint.

## 1. YES — CP/M-86 can hand a running program more RAM (not Concurrent-only)

**VERIFIED** from the base (single-user) **CP/M-86 System Guide, Jun 1983,
§4.4 "BDOS Memory Management and Load"**
(`open-watcom-v2/contrib/ravn/CPM-86_System_Guide_Jun83.txt`, functions listed
lines 1427-1437, described 2885-3006). These are base CP/M-86 calls — NOT
exclusive to MP/M-86 / Concurrent CP/M-86. They exist because the 8086's
relocatable segmented model requires the OS to manage memory for `.CMD`
programs (even the OS itself uses Free-Memory/func 57 to release a finished
program, guide line 2826).

Memory Control Block (MCB) at `DS:DX`: `+0` M-Base (16-bit paragraph),
`+2` M-Length (16-bit paragraphs), `+4` M-Ext (8-bit). Error flagged with
`AL=0FFH` (matches CP/M file-error convention).

| func | CL  | name       | effect |
|------|-----|------------|--------|
| 53   | 35H | GET MAX MEM   | largest free region ≤ M-Length; M-Ext=1 if more remains |
| 54   | 36H | GET ABS MAX   | largest region at an absolute paragraph boundary |
| **55** | **37H** | **ALLOC MEM** | **allocate M-Length paragraphs at runtime; returns base in MCB** |
| 56   | 38H | ALLOC ABS     | allocate at an absolute address |
| 57   | 39H | FREE MEM      | release the region named by the MCB |
| 58   | 3AH | FREE ALL      | release all memory owned by the program |

**emu2 implements these** (`emu2-cpm86/src/cpm86.c:1415-1474`): cases 53/55
(alloc), 57 (free), 58 (no-op). Cases 54/56 (ABSOLUTE alloc) are **NOT**
implemented in emu2 yet (`AX=0FFFFH, CX=3`). So the portable runtime-growth
primitive to rely on is **func 55 MC_ALLOC** (relocatable), never 56.

Practical nuance: under single-user CP/M-86 the loader has usually already
given the program its X-region and there is one big free area, so runtime
alloc matters less; under Concurrent/MP-M-86 the memory manager is essential
because programs share RAM. The API is identical either way.

## 2. Static sizing: the .CMD M (G-Min) / X (G-Max) header fields

The `.CMD` header holds up to eight 9-byte group descriptors
(`type, length, base, min, max` — paragraphs; see
[[reference_cpm86_cmd_header]]). For each group:

- **M-value = G-Min** = paragraphs the loader MUST allocate (incl. BSS). Floor.
- **X-value = G-Max** = maximum the loader will allocate if free. Ceiling.
  System Guide (lines 1102-1109): *"generally used when additional free memory
  may be needed for such purposes as I/O buffers or symbol tables. If the data
  area size is fixed, then the X parameter need not be included. In this case
  the X value is assumed to be the same as the M value."*
- **X = 0FFFFH** = "allocate the largest region available" → **grabs
  everything**, which is exactly what you must AVOID on a multitasking machine.

So the DRI-sanctioned minimal-footprint policy is: **default X = M** (take only
what is needed), and let the user raise X only when a program needs heap /
buffers.

## 3. What wlink actually exposes today (verified in the fork source)

- **DATA group (type-2, the near DGROUP / DS+SS auto-data):** wlink emits
  `G-Min == G-Max == data_alloc_paras` (`bld/wl/c/loadcpm86.c:418-423`). There
  is **NO near-heap tuning knob** — the near data group is fixed-size. This is
  why the current 36 KB static near arena (`wc_arena[36352]`, lowlevel.c) is
  BOTH stored in every `.CMD` and force-allocated (issue #24).

- **EXTRA group (type-3, far data / far heap):** controlled by
  **`OPTION FARHEAP=<size-in-bytes>`** (`bld/wl/c/cmdcpm86.c:104-125`,
  registered `bld/wl/c/cmdall.c:2007` as `MK_CPM86`). It emits a type-3 Extra
  descriptor with:
  - `G-Length = 0` → **NO stored image** (never bloats the `.CMD`; the loader
    reserves it, does not read it),
  - `G-Min = 1` → loads even under memory pressure (a large G-Min made a 300K
    test outright REFUSE to load on real Concurrent CP/M-86 — "For lidt lager"),
  - `G-Max = <size> paragraphs` → ceiling only.
  The loader grants whatever RAM is actually free between Min and Max and
  reports the ACTUAL grant back via the base page's Extra-group length field
  (`loadcpm86.c:436-485`). This is precisely the multitasking-friendly
  "use up to this much of whatever is really free" semantics.

- **Far-heap runtime seam:** `contrib/ravn/watcom-cpm86-libc/port/farheap.c`
  implements `__AllocSeg`/`__GrowSeg`/`__FreeSeg` by reading the base page
  (DS+000C..000E = Extra last-byte position, DS+000F..0010 = Extra base seg,
  System Guide §2.6) and carving the reserved Extra region into ≤64 KB slabs.
  Watcom's own `fmalloc.c` redirects `malloc()/free()` → `_fmalloc()/_ffree()`
  whenever **`__BIG_DATA__`** is defined (i.e. the program is compiled `-mc`
  compact model), so ordinary user C gets far-heap-backed `malloc` with zero
  user-code changes. See [[reference_cpm86_big_model]].

### The far-heap seam is now FIRST-CLASS (lifted 2026-08-20)

**DONE (2026-08-20):** the far-heap runtime seam has been lifted from the
contrib staging tree into the first-class `bld/clib/_cpm/` that owcc links:

- **New file `bld/clib/_cpm/c/farheap.c`** — the CP/M-86-native
  `__AllocSeg`/`__GrowSeg`/`__FreeSeg` (reads base page DS+000C Extra-length /
  DS+000F Extra-seg, carves the type-3 Extra reservation into ≤64 KB slabs).
  Adapted from `contrib/.../port/farheap.c` to first-class convention: clib
  compiles with `-za` (ANSI), so un-prefixed `near` → `__near`; the
  `__AllocSeg/__GrowSeg/__FreeSeg` prototypes come from `heap/h/heap.h:237-239`
  (on the cpm86 include path via `include.mif:9`); dropped the unused
  `roundmac.h` (`PARAS_IN_64K` is in `heap.h`).
- **`bld/clib/_cpm/objects.mif`** — added `farheap.obj` to `objs_cpm86_086`.

**No shadowing — genuine exclusion.** Because `library/cpm86.086/libs.mif`
lists `_cpm` FIRST in the merge, wlib DROPS the DOS INT-21h heap objects
outright when `farheap.c` (and `lowlevel.c`) already define their symbols. The
shipped `bld/clib/library/cpm86.086/ms/clibs.lib` therefore contains ZERO
`allocseg.c`/`growseg.c`/`freeseg.c`/`sbrk.c` modules (verified: `wlib
clibs.lib` → 0 matching modules) — no dead `TinyAllocBlock` (INT 21h AH=48h)
code is carried. `__AllocSeg`/`__GrowSeg`/`__FreeSeg` resolve to `farheap.c`;
the OS-generic far-heap API (`_fmalloc/_ffree/...`) is unchanged and links on
top. This is the same drop-on-duplicate mechanism the port already uses for the
fd-layer (diskio → handleio) and near heap (lowlevel → sbrk). Documented in
`libs.mif`.

**VERIFIED end-to-end (2026-08-20):** small-model `_fmalloc` test
(`contrib/.../test/farheap_smalltest.c`, 8×12 KB = 96 KB off DGROUP, full byte
round-trip) → **PASS** under `contrib/ravn/cpm86run_unicorn.py`. (emu2 only
prints the first char and does not populate the type-3 base-page fields —
unicorn is the authoritative CP/M-86 loader model for this test.)

**INSTALL GAP CLOSED (2026-08-20):** the first-class object
`bld/clib/_cpm/library/cpm86.086/ms/farheap.obj` was surgically installed into
the lib owcc actually reads (`lib286/cpm86/clibs.lib`), REPLACING the older
contrib-built `port/farheap.c` module, via
`rel/armo64/wlib -q -b lib286/cpm86/clibs.lib -+.../farheap.obj` (basename-match
replace — verified `__AllocSeg`/`__GrowSeg`/`__FreeSeg` now resolve to
`bld/clib/_cpm/c/farheap.c`, exactly one def each, contrib path gone). Re-ran
`build-farheap-small.sh` (which links `$OW/lib286/cpm86/clibs.lib`) → PASS,
so the FIRST-CLASS object itself (not just the contrib source) is now proven in
the shipped lib. Backup at `/tmp/clibs.lib.bak-*`. NOTE: this wired **small
model (ms) only**; the compact/medium first-class models are not yet installed,
and a full merged-lib swap was deliberately avoided (496 KB first-class merged
lib vs 204 KB installed lib = broad regression risk).

**INDEPENDENT ORACLE + MAME rc759 CROSS-CHECK (2026-08-20):** the guest's own
"PASS" print is only an EQUIVALENCE oracle (same code writes and re-reads the
blocks), so two INDEPENDENT content checks were added:
- `cpm86run_unicorn.py` gained an additive `--dump PATH` flag → writes the full
  1 MB physical RAM after the run. `test/verify_farheap_dump.py` then scans the
  dump for the 8 expected ramp blocks (byte[j]=(i*97+1+j)&0xFF, ≥12288 B each) —
  confirming the 96 KB physically exists in RAM, NOT via the guest's read path.
  `build-farheap-small.sh` now runs this after every unicorn run. Under unicorn
  the blocks land at phys 0x1C218..0x3521C.
- `build-farheap-mame.sh` builds `FHMAME.CMD` (`farheap_smalltest.c -DMAME_DONE`,
  linked against the INSTALLED first-class `lib286/cpm86/clibs.lib`), boots it on
  the cycle-faithful **MAME rc759** (real i80186 + the real CP/M-86 loader) via
  `mame-tests/farheap_done_dump.lua` (0x2FE done-tap + full-RAM dump). Result:
  guest word `0x0008` (8 blocks OK / 0 bad) AND the independent dump scan found
  all 8 blocks — at phys **0x3B738..0x5373C** (HIGH in the 384 KB RAM), a
  DIFFERENT layout than unicorn, because the real loader carves the type-3 Extra
  group differently. Both oracles PASS → Unicorn's far-heap/loader model matches
  metal on observable behavior. (MAME rc759 = 384 KB RAM, phys 0..0x5FFFF; boot
  ~6 s headless via `SDL_VIDEODRIVER=dummy -video none`.)

### Remaining contrib seams NOT yet lifted, and WHY (drop-on-duplicate hazard)

Three other seams still live in `contrib/.../port/` and are NOT clean lifts:

- **`fesoft.c`** (FP `feraiseexcept` no-op for the no-8087 RC759): CANNOT be
  lifted by the same `_cpm`-first drop-on-duplicate trick. `fesoft.c` redefines
  ONLY `feraiseexcept`, but the stock `clib/fpu/c/fenv.c` is a SINGLE object
  module bundling 14 symbols (feclearexcept/fesetenv/fegetenv/feraiseexcept/...).
  wlib drops the WHOLE clashing module, so listing `fesoft.c` first would drop
  all 14 fenv functions → 13 undefined symbols = regression. farheap.c was safe
  precisely because `allocseg.c`/`growseg.c`/`freeseg.c` are three SEPARATE
  single-function objects that its three symbols matched exactly. Lifting
  fesoft needs a different mechanism (split fenv.c per-function, or a
  post-merge wlib member surgery), plus a no-8087 `_matherr` runtime test.
- **`ehsupp.c`** (`__clib_exit`/`__clib_fatal` + setjmp/longjmp + C++ EH OS
  hooks) and **`cpprt.c`** (`__clib_malloc`/`__clib_free` C++ iostream heap
  bridge): C++/setjmp subsystems. `__clib_malloc`/`__clib_free` are absent from
  the first-class C clib (only referenced once a C++ iostream/plib component is
  linked, which the cpm86 merge does not list). These belong with the C++
  runtime wiring, need a C++ (`-xs`) + setjmp test harness, and share the same
  multi-symbol-module drop hazard. Separate scope from the memory/far-heap work.

RULE (durable): the `_cpm`-first drop-on-duplicate exclusion only cleanly
replaces stock objects that are SINGLE-FUNCTION (one public symbol). For a
multi-symbol stock module, redefining one of its symbols drops the whole
module — verify the target object's full symbol set with `wlib <lib>` before
relying on this mechanism.

### History: why it was in contrib (migration lag, now resolved)

The far-heap seam originally lived ONLY in the contrib staging tree
(`contrib/ravn/watcom-cpm86-libc/port/farheap.c`). This was a two-tree
migration-lag, same pattern as the redirection work (proven in contrib, then
ported forward). VERIFIED git timeline:

- **18 Aug 00:33** `ee6ac439bd` — first-class `bld/clib/_cpm` CREATED as a
  snapshot of the contrib tree as it was then: near arena only.
- **18 Aug 18:59** `b8cfd0d10e` — far-heap seam (`__AllocSeg/__GrowSeg/
  __FreeSeg`) added to CONTRIB, ~18 h AFTER the first-class snapshot.
- **19 Aug 15:43** `1a068e3814` — 2nd first-class port: medium-model +
  one-command owcc, NOT the far heap.
- **19 Aug 17:12** `09c2eb3099` — wlink type-3 EXTRA group (far side) in contrib.
- **20 Aug 09:06** `949596a732` — contrib runtime "green in ALL models (s/m/c)":
  the compact/far model only just stabilized.

So nothing design-wise blocked it — the first-class snapshot simply predated the
far heap, the one later re-sync carried other work, and the compact model only
stabilized on 2026-08-20. The wlink side (`OPTION FARHEAP`) was already
first-class; the C runtime seam `port/farheap.c` → `bld/clib/_cpm/c/farheap.c`
was lifted on 2026-08-20 (see the section above). Gap (b) in §4 is now CLOSED
for small model; wiring the first-class build's compact/medium models remains a
follow-up (commit `1a068e3814`).

## 4. THE single user-facing RAM knob (current decision)

Delegate precise RAM to the user via the **far heap ceiling**, which already
has all the right properties (unstored, loader-on-demand, multitasking-safe):

1. Compile the program `-mc` (compact model) so `malloc` is far-heap-backed.
2. Set the ceiling with **`OPTION FARHEAP=<bytes>`** — the loader then grants
   only the RAM that is actually free, up to that ceiling; nothing is stored in
   the `.CMD`.

Two delivery routes for that ceiling (user's standing rule: **always build
`.CMD` with a single `owcc` command, no loose build scripts** —
[[reference_owcc_cpm86_no_seams_softfloat_lib]] / user directive):

- **Preferred — native owcc option.** owcc has no generic `-Wl,` passthrough
  today, but it DOES map `-mstack-size=<n>` onto a wlink `OPTION STACK`
  (`bld/wcl/c/owcc.c:852-856`). Mirror that exactly: add a driver option (e.g.
  `-mfar-heap=<bytes>`) that emits `OPTION FARHEAP=<bytes>` into owcc's linker
  directive file. Keeps everything in the one `owcc` command. (Small, scoped
  owcc.c change; needs a driver rebuild + a header-descriptor verification.)
- **Fallback — GENCMD post-step.** Edit the finished `.CMD`'s Extra-group X
  (G-Max) with DRI GENCMD. The user explicitly accepted this alternative, but
  it is a second tool step, so it is less aligned with the "single owcc
  command" rule.

Default when the knob is unused: no Extra group at all (pure small model),
output byte-identical to today — so console-only / no-malloc programs pay
nothing (this is the on-demand principle from the redirection work).

## 5. Refined memory work (deferred → its own issue)

The near-arena bloat (issue #24) and true runtime growth (BDOS-55 MC_ALLOC
driven `__AllocSeg`, minimal DGROUP near heap, not storing/zeroing BSS) are the
refined direction, tracked separately in **issue #26** (with issue #24 the
near-arena subset). The FARHEAP knob above is the immediate, already-wired
mechanism; #26 is the "grow the near heap on demand / shrink the DGROUP /
BDOS-55 MC_ALLOC at runtime" follow-up.

## Key file pointers

- `contrib/ravn/CPM-86_System_Guide_Jun83.txt` §4.4 (BDOS 53-58), lines
  1102-1109 (M/X), 1427-1437, 2885-3006 — the authoritative DRI source.
- `emu2-cpm86/src/cpm86.c:1415-1474` — emu2's MC_ALLOC/MC_MAX/MC_FREE (54/56 abs
  NOT implemented).
- `bld/wl/c/loadcpm86.c:418-485` — DATA G-Min==G-Max; EXTRA/FARHEAP descriptor.
- `bld/wl/c/cmdcpm86.c:104-125`, `bld/wl/c/cmdall.c:2007` — `OPTION FARHEAP=`.
- `contrib/ravn/watcom-cpm86-libc/port/farheap.c` — far-heap OS seam.
- `bld/wcl/c/owcc.c:852-856` — `-mstack-size=` → wlink OPTION STACK (the pattern
  to mirror for a `-mfar-heap=` option).
- Related: [[reference_cpm86_cmd_header]], [[reference_cpm86_big_model]],
  [[reference_watcom_wlink_cpm86_format]], [[reference_cpm86_emu2_p_load_reloc]].

## 6. Variable-segment / up-to-1MB far-heap demo + Unicorn==MAME loader check (2026-08-20)

`test/farheap_smalltest.c` now grabs far heap in a loop up to a 1 MB budget with
a VARIABLE `SEG` (`-DSEG=<bytes>`, default 16384, <=64 KB Watcom cap) and analyses
ONLY the blocks the loader actually grants ("analyse what you got"). Harnesses:
`build-farheap-small.sh` (Unicorn) and `build-farheap-mame.sh` (MAME rc759); both
parse the guest's block count and re-check it with the INDEPENDENT RAM-dump oracle
`test/verify_farheap_dump.py --seg <bytes> --count <n>`.

Two things this exposed and pinned:

- **Loader clamp (`cpm86run_unicorn.py::_load`).** A big `OPTION FARHEAP=0xF0000`
  (~960 KB) previously zero-filled the type-3 Extra group past `MEM_SIZE` (1 MB)
  → `UC_ERR_WRITE_UNMAPPED`. Fixed by clamping the granted paragraphs to the RAM
  actually available above the group (`avail = (MEM_SIZE>>4) - free_seg`) — which
  is exactly what a real CP/M-86 loader does: grant `min(descriptor max, free
  TPA)`, placed right above the data group. So "accept up to a megabyte, use what
  you get" is now modelled faithfully.

- **`_fmalloc` near-heap fallback == far-heap-exhausted boundary.** In SMALL model,
  once `__AllocSeg` returns `_NULLSEG` (Extra reservation fully carved), Watcom's
  `_fmalloc` falls back to the NEAR heap and returns a far pointer with
  `FP_SEG==DS` (into DGROUP). This is NOT corruption — it is the normal clib
  behaviour. The demo now STOPS at the first `FP_SEG==DS` block (frees it,
  doesn't count it), so every counted block is genuinely outside DGROUP.

**Unicorn vs MAME — SAME algorithm, different size/placement (the independence
proof):**

| runner | RAM | Extra base-seg | slab pattern | far blocks | far heap |
|--------|-----|----------------|--------------|-----------|----------|
| Unicorn        | 1 MB   | 0x1C70 | 3×16 KB per 64 KB slab | 42 | 672 KB |
| MAME rc759     | 384 KB | 0x3BBB | 3×16 KB per 64 KB slab |  6 |  96 KB |

Both feed off the base-page type-3 Extra descriptor; the SAME `farheap.c`
`__AllocSeg` carves identical 64 KB slabs (3×16 KB each, 16 KB/slab lost to heap
headers), and both fall back to near at exhaustion. Only the granted SIZE (RAM-
dependent) and the base PLACEMENT differ — different loaders, identical content →
confirms Unicorn's `_load` models the real CCP/M-86 loader's far-heap allocation,
rather than merely reproducing the same bytes. Answers user 2026-08-20 ("undersøg
om unicorn tildeler heap på samme måde som mame ccp/m"): yes, same mechanism.

## 7. emu2-cpm86 third-loader cross-check + emu2 BDOS register-preservation fix (2026-08-20)

Ran the SAME variable-seg far-heap test on emu2-cpm86 (`emu2-cpm86/emu2`) as the
third independent loader. `build-farheap-emu2.sh` (uses `EMU2_RAMDUMP=<file>`,
newly added to emu2 -- `src/main.c` atexit handler dumping the full 1 MB RAM) +
`verify_farheap_dump.py`.

**Same far-heap algorithm on all THREE loaders (size scales with TPA, placement
differs -- the independence proof):**

| loader   | TPA     | Extra base-seg | slab pattern           | far blocks | far heap |
|----------|---------|----------------|------------------------|-----------|----------|
| MAME rc759            | 384 KB | 0x3BBB | 3x16 KB per 64 KB slab |  6 |  96 KB |
| emu2 (mcb 0x80-0xA000)| 640 KB | 0x0D04 | 3x16 KB per 64 KB slab | 27 | 432 KB |
| Unicorn _load         | 1 MB   | 0x1C70 | 3x16 KB per 64 KB slab | 42 | 672 KB |

emu2's Extra allocation (`src/cpm86.c` ~L462-482: `want = max>min?max:min`,
`mem_alloc_segment()`, fall back to largest available `>= g_min`) is the same
grant-min(max,available) model; the SAME `farheap.c __AllocSeg` carves identical
slabs. Three different base-segs, identical content -> confirms the algorithm is
loader-independent.

**emu2 BUG found + FIXED (`emu2-cpm86/src/cpm86.c intr_cpm_bdos`).** The first
emu2 run printed only `P27 16384 432/` -- every `puts_n()` (`while(*s)
conout(*s++)`) dropped all but its FIRST char, while `put_u()` printed fully.
Root cause: emu2 delegates BDOS functions to its INT 21h (DOS) handlers via
`bdos_via_dos()/intr21()`, which clobber registers a real CP/M-86 BDOS preserves.
Per the System Guide S4.1: results return in AL / AX+BX / ES:BX, and "All segment
registers, except ES, are saved... restored... (PL/M-86 conventions)" -- PL/M-86
also preserves SI, DI, BP; only AX/BX/CX/DX/ES are scratch. Watcom's `puts_n`
keeps its string pointer in **BX** across `int 0E0h` (disasm:
`mov bx,ax; L: mov al,[bx]; ...; int 0E0h; inc bx; jmp L`), but emu2's
`bdos_ret()` writes AX AND BX for EVERY function, including value-less console
output (2). Fix: (a) snapshot SI/DI/BP/DS/SS at BDOS entry and restore at exit;
(b) for the no-return output functions (2, 9, and 6 output subfn DL<0FDh) also
restore AX/BX; (c) EXEMPT P_CHAIN (47) from the restore -- it transfers control
to a freshly loaded program whose CS/DS/SS/IP must not be reverted. After the fix
emu2 prints the full `PASS far-heap n=27 seg=16384 kb=432`. Verified: existing
`tests/cpm86-reloc/run.sh` (FARMULTI/FARPTR, incl. a type-3 EXTRA-group far
pointer) still ALL PASS. This was a real emu2 console-output fidelity bug (a
program that worked on real MAME hardware and Unicorn was corrupted only on emu2).

## 8. First-class-lift todos filed as GitHub issues (2026-08-20)

The four remaining OS-seam modules still living in `contrib/ravn/watcom-cpm86-libc/port/`
(blocked on the per-MODULE, not per-symbol, `wlib` drop-on-duplicate limitation — a stock
DOS object bundles many symbols we still need, so a single-symbol override drops them all)
now each have a full explanation + plan tracked upstream in `ravn/open-watcom-v2-ccpm86`:

- **#27** — `fesoft.c` (soft `<fenv.h>` `feraiseexcept` no-op). Stock `bld/clib/fpu/c/fenv.c`
  bundles 14 `fe*` funcs; naive lift loses 13. Simplest candidate. Plan: per-function `#ifdef`
  split of `fenv.c` (Option A) or a full forked `fenv.obj` in `_cpm` (Option B).
- **#28** — `ehsupp.c` (`setjmp`/`longjmp` + C++ EH hooks `___longjmp_handler`/`__get_ovl_stack`).
  Stock symbols scattered in DOS startup RT-data that also drag `_psp`/`_LpCmdLine`. Needs a
  setjmp + `-xs` throw/catch test harness across all three loaders.
- **#29** — `cpprt.c` (`__clib_malloc`/`__clib_free` iostream heap bridge). Stock defs in
  `bld/clib/startup/c/liballoc.c` (bundled `__clib_*` family). Option A: prove stock forwards
  are already correct on cpm86 and DELETE the port file; Option B: forked `liballoc` in `_cpm`.
- **#30** — fp/crt0 asm (`fpsoftstub.asm __real87=0`, `fpsupport.asm`, `emu87cpm.asm`,
  `crt0{sm,mm,cm}.asm`). Stock `_8087086.asm` bundles 5 symbols; `fdmth086.asm` fuses hw+sw
  double math. Plan: provide the full `_8087086`-equivalent data block in `_cpm/a` + lift crt0
  variants with `_cstart_` in front-sorted BEGTEXT (mirror `cstartcpm.asm`).

All four are NOT on the far-heap critical path (deferred 2026-08-20). Session todos
`port-fesoft`/`port-ehsupp`/`port-cpprt`/`port-asm` carry the matching `[tracked: #NN]` link.

## 9. emu2 deficiencies filed as GitHub issues for upstream PRs (2026-08-20)

The three emu2 deficiencies found while adding emu2 as a third far-heap loader (all
FIXED locally, uncommitted) are now tracked in `ravn/emu2-cpm86` to prepare upstream PRs:

- **#2** — CP/M-86 BDOS does not preserve caller SI/DI/BP/DS/SS. emu2 delegates to
  intr21() which clobbers them; real BDOS preserves all segregs except ES + SI/DI/BP
  (System Guide §4.1 / PL/M-86). Fix: snapshot at entry, restore for all funcs except
  P_CHAIN (47).
- **#3** — CP/M-86 BDOS clobbers AX/BX/CX/DX for value-less console-output funcs (2, 9,
  6-out DL<0FDh) via unconditional bdos_ret(). Watcom puts_n keeps its ptr in BX → only
  first char printed. Fix: restore AX/BX/CX/DX for those no_return funcs.
- **#4** — enhancement: EMU2_RAMDUMP env var dumps full 1 MB guest RAM on exit
  (atexit) for an independent host content oracle, matching Unicorn --dump / MAME Lua.
  main.c is shared with dmsc/emu2 so this is offerable upstream too.

#2 and #3 are two facets of one PL/M-86 register-contract violation (same restore block,
can be one PR); #4 is independent. All three were verified: emu2 prints the full
"PASS far-heap n=27 seg=16384 kb=432", RAM-dump oracle agrees (27 blocks @ 0x0D04), and
tests/cpm86-reloc/run.sh still passes.

## 10. Already-committed @ravn emu2 CP/M-86 changes filed as issues for upstream PRs (2026-08-20)

To prepare upstream PRs (to dmsc/emu2 via the ravn/emu2-cpm86 fork), each of @ravn's OWN
committed CP/M-86 changes (author "Thorbjørn Ravn Andersen") now has a standalone issue with
what/why/evidence + a PR plan (submit the commit + add a regression fixture):

- **#1** (pre-existing) — P_LOAD load-time relocation (commit b5b1a48, closes #1).
- **#5** — mask bit-7 FCB interface attributes in filenames (f291d3d). DR C sets bit 7 →
  SRCFILE decoded as SRCFI.
- **#6** — load auxiliary groups CMD types 5-8 → descriptor slots 4-7 (3f0eea4); relocatable
  CMDs (DR C passes) need it.
- **#7** — BDOS 47 P_CHAIN + leading-"R" token strip (1594149). Must stay EXEMPT from the
  register-restore of #2/#3 (transfers control, doesn't return).
- **#8** — separate entry-time stack, SS≠DS by default per System Guide §4.1.2 (f66c0dd).
  Fidelity fix: makes emu2 LESS forgiving so a PASS matches real MAME rc759 (caught a
  Dhrystone Int_1_Loc mismatch).
- **#9** — dos: fflush host handle after random write fn 0x22 (0b2450e); in shared src/dos.c,
  relevant to dmsc/emu2 directly. Restores write-through so fn 0x23/second handle see data.

Johnson (johnsonjh) authored the rest of the fork's CP/M-86 base and DOS work — NOT filed
here (his own to upstream). All emu2 issues live in ravn/emu2-cpm86: #2/#3/#4 (uncommitted
session fixes, §9) + #5-#9 (committed @ravn changes, this section) + #1 (P_LOAD).

## 11. emu2 pre-existing CP/M-86 gaps filed + session fixes committed (2026-08-20)

Pre-existing known-limitation gaps (NOT found this session, no production repro; filed so
they are tracked, verified against the DRI Concurrent CP/M Programmer's Reference Jan84):

- **#10** — BDOS 54/56 (MC_ABSMAX/MC_ABSALLOC) absolute allocation returns 0FFH/CX=3 at
  cpm86.c:1495. NO-OP under plain CP/M-86 but LIVE allocation under Concurrent CP/M-86
  (guide §6: "under Concurrent CP/M, this system call allocates memory").
- **#11** — BDOS 59 (P_LOAD, "load CMD, return base-page seg") falls through to the generic
  UNIMPLEMENTED 0xFF default (cpm86.c:1529). P_CHAIN (#7) currently works around it via the
  leading-"R" token strip.
- **#12** — 8080-model base-page layout TODO (cpm86.c:439): allocation is handled but the
  8080-model base page is not laid out separately from the small model.

Session emu2 fixes COMMITTED to branch local/cpm86 (NOT pushed — push only at merges):
- `8a77c6c` — BDOS caller register preservation (addresses #2 + #3), src/cpm86.c.
- `7dc704a` — EMU2_RAMDUMP full-RAM dump on exit (addresses #4), src/main.c.
Clean rebuild OK; tests/cpm86-reloc/run.sh ALL PASS.

Full emu2 issue map in ravn/emu2-cpm86: #1 P_LOAD-reloc | #2/#3/#4 session fixes (committed)
| #5-#9 @ravn committed changes (prep upstream PRs) | #10/#11/#12 pre-existing gaps.
