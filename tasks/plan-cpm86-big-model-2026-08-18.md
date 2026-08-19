# Plan: CP/M-86 memory models beyond small, for Watcom `FORMAT CPM86`

Status: DRAFT, not started. Companion docs (read first):
`tasks/memory/reference_cpm86_big_model.md` (DR C's big model + far/huge
pointer explanation), `tasks/memory/reference_cpm86_cmd_header.md` (the
`.CMD` header byte layout), `tasks/memory/reference_watcom_wlink_cpm86_format.md`
(current phase-1 small-model-only implementation).

## Goal, split into two independently-useful stages (user, 2026-08-18)

DR C's "big model" bundles two unrelated capabilities together (far code
across multiple segments, AND a far-addressed heap outside DGROUP). They
don't have to ship together. Split into two stages, build the cheaper one
first:

- **Stage A — CP/M-86 gets Watcom's existing COMPACT model (`-mc`).** Decided
  2026-08-18 (see full reasoning in `[[reference_cpm86_big_model]]`'s
  "Compact model = Stage A's real name" section): don't invent anything new.
  Watcom already has a named model for exactly this shape — **compact: small
  code (≤64 KB, CGROUP unchanged) + big data (`DataPtrSize = far`)** — and,
  crucially, **Watcom's own clib source already redirects `malloc()` itself
  to `_fmalloc()` when building the compact-model library variant**
  (`bld/clib/heap/c/fmalloc.c`, gated on `__BIG_DATA__`, which `-mc` sets via
  `CGSW_X86_BIG_DATA` — verified 2026-08-18 by inspecting `cmdlnx86.c`'s
  model-switch table). So plain user code calling ordinary `malloc()`/`free()`
  transparently gets far-heap-backed memory under `-mc` — **the redirect
  mechanism lives entirely inside Watcom, zero user-code involvement**
  (explicit user requirement, 2026-08-18). Documented split going forward:
  **small = 64 KB code + 64 KB data(+heap+stack, all in DGROUP, as today)**;
  **compact = 64 KB code + 64 KB data, PLUS a separate far heap** (all
  pointers become 4-byte far under compact — accepted tradeoff, user
  2026-08-18: "det er fint compact har 4-byte pointere"). This is genuinely
  the DOS-precedented meaning of "compact" model (small code, big data) — no
  redefinition of Watcom's own terminology, just the first port of it to
  `FORMAT CPM86`.
- **Stage B — code > 64 KB across multiple segments.** The harder half of
  big model: don't group code into CGROUP, emit many far-addressed segments
  concatenated into one Code Group Descriptor. Deferred until Stage A ships
  (user, 2026-08-18: "dernæst kigge videre på mere-end-64kb kode" — look at
  this *next*, after Stage A). **PARKED, do not chase yet:** which Watcom
  `-m` flag this should be called/reuse (large `-ml` was floated as a guess,
  NOT decided) — user, 2026-08-18: settle that only once the linker-side
  behavior is well understood, not before ("det gemmer vi til du har styr
  på hvordan linkeren skal opføre sig").

Both still map onto the same `.CMD` Group Descriptor mechanism
(`[[reference_cpm86_cmd_header]]`) — G-Type 3=Extra for Stage A, G-Type
1=Code (multi-segment) for Stage B — but they're independent linker/runtime
changes and should ship as independent, separately-testable increments.

---

## Stage A — CP/M-86 compact model (`-mc`)

### Phase A1 — wlink: accept `-mc` for `FORMAT CPM86` + emit the EXTRA group descriptor — **DONE 2026-08-18**

Audited `bld/wl/c/cmdcpm86.c`/`loadcpm86.c` first (per the checklist
originally here): confirmed phase-1 was small-model-only, exactly 2
descriptors (CODE=1, DATA=2), `A-Base=0`, no fixup table.

**Resolved during implementation:** the linker can't observe the
compiler's `-mc` flag at all (it only ever sees OMF segments) — and it
turns out it doesn't need to. Per the CP/M-86 System Guide, "Compact
Model" is *defined* as "Code+Data plus ≥1 of Stack/Extra/Auxiliary" — the
model is implicit in which descriptors exist, not a separate flag anywhere
in the `.CMD` file or the loader's decision logic. So no new `FORMAT
CPM86` sub-keyword was added; `SMall`/`8080` are unchanged. Instead:

- [x] Added `OPTION FARHEAP=<size>` (byte-sized, same pattern as the
      existing `STACK` option) — `CPM86FarHeapSize` global in
      `cmdcpm86.c`/`.h`, registered `MK_CPM86`-gated in `cmdall.c`'s
      `MainOptions` table. Echoes real LINK-86 `EXTRA[MAXIMUM[...]]`
      precedent (`[[reference_cpm86_big_model]]`) without inventing new
      terminology.
- [x] `FiniCPM86LoadFile()` (`loadcpm86.c`) now appends a type-3 (Extra)
      group descriptor whenever `CPM86FarHeapSize != 0`: no stored image
      (G_Length=0), `G_Min == G_Max == paragraphs(size)`. CODE/DATA
      descriptors emitted exactly as before — verified byte-identical
      output when the option is omitted (no regression).
- [x] Verified end-to-end: linked `contrib/ravn/hello.asm` with
      `op farheap=0x1000` — header grew from 1 to 2 descriptors, second one
      `03 00 0000 0100 0100` = type Extra, min=max=0x100 paragraphs =
      0x1000 bytes exactly. Commit `4cd6304d3a`.
- [ ] (Not applicable) rejecting other `-m` flags is moot here — the
      linker was never asked to validate compiler model flags in the first
      place; Stage B's own model-name question stays PARKED as before.

### Phase A2 — retarget `__AllocSeg`/`__GrowSeg`: the whole seam already exists — **DONE 2026-08-18**

Implemented as `open-watcom-v2/contrib/ravn/watcom-cpm86-libc/port/farheap.c`.
One real design evolution vs. the original scoping below: a single
`__AllocSeg` call handing out ES once is NOT enough to make a FARHEAP total
bigger than 64 KB actually usable (every Watcom heap-list slab is capped at
64 KB by construction, same on every target) — so `__AllocSeg` instead
**carves successive ≤64 KB slabs** out of the one Extra reservation,
reading its TRUE size from the CP/M-86 base page (`DS+000C..0010`, System
Guide Sec.2.6 LE/BE fields) rather than trusting a compiled-in constant.
`__GrowSeg` stays a no-op (each slab's size is fixed at carve time);
`__FreeSeg` always fails (nothing is ever handed back to any OS) — see the
file's own comments for the `_fheapshrink()` caveat this implies.

Verified with a new overlap-detecting stress test (`test/farheaptest.c` +
`build-farheap.sh`, Phase A4 below): **298,973 bytes across 130 `_fmalloc`
blocks, 0 corrupted, under emu2** — past one 64 KB slab, proving multi-slab
carving actually works, not just a single 64 KB allocation. Commit
`b8cfd0d10e`.

**Real footgun hit and fixed along the way:** wlink/wcc/wasm each read an
env var NAMED AFTER THEMSELVES for implicit default switches — exporting
`WCC=<path to wcc.exe>` makes `wcc.exe` itself misparse that path as a
bogus second source file (`E1139`). Any future script wrapping these
tools must NOT name its own path-override variables `WCC`/`WASM`/`WLIB`/
`WLINK` (see `build-farheap.sh`'s `OWCC_BIN`/`OWASM_BIN`/etc. pattern) and
should defensively `unset` them.

Original scoping (kept for context, now superseded by the above):

**Found 2026-08-18, source-verified:** Watcom's far-heap C API is complete
and OS-generic — `bld/clib/heap/c/{fmalloc,ffree,frealloc,fcalloc,fmsize,
fheapset,fheapchk,fheapmin,fheapwal}.c` implement `_fmalloc`/`_ffree`/etc.
entirely in terms of two OS-specific primitives:
- `__segment __AllocSeg(unsigned amount)` (`bld/clib/heap/c/allocseg.c`) —
  get a brand-new segment from the OS to seed/extend the far-heap segment
  list.
- `int __GrowSeg(__segment seg, unsigned amount)` (`bld/clib/heap/c/growseg.c`)
  — grow an existing far-heap segment.

Both are `#if defined(__OS2__) / __QNX__ / __WINDOWS__ / #else /* __DOS__ */`
branches; the DOS branch calls `TinyAllocBlock`/`TinySetBlock` — **the exact
same low-level DOS INT 21h primitives already replaced once** for the
near-heap `__brk` seam (`[[reference_watcom_cpm86_heap_shim]]`: "Watcom
small-model near-heap's ONLY OS trap is sbrk.c's `__brk` -> INT 21h AH=4Ah
(TinySetBlock)"). This is the SAME retarget pattern, one level up (whole
segments instead of growing one static arena):

- [ ] Add a `port/farheap.c` seam (sibling to the existing `port/lowlevel.c`
      near-heap arena-bump) implementing `__AllocSeg`/`__GrowSeg` for
      `-DCPM86`: CP/M-86 has no dynamic "give me a new segment" OS call (no
      analogue to DOS's INT 21h AH=48h) — the Extra group's entire memory
      was already handed to the program at load time (fixed base + size from
      G-Min/G-Max, Phase A1). So:
  - `__AllocSeg`: **first call** returns the (single) ES segment value the
    loader set up; **any subsequent call** (heap already fully claimed)
    returns `_NULLSEG` (out of memory) — there is nothing more to hand out,
    unlike DOS where more segments can be requested.
  - `__GrowSeg`: return 0 (fail) once the single Extra segment already
    covers its full allocated size — same "nothing more available" logic,
    simpler than DOS's case since CP/M-86 never has a *second* segment to
    grow into.
  - This mirrors `[[reference_watcom_cpm86_heap_shim]]`'s existing guidance
    almost exactly ("AVOID bmalloc/bexpand/growseg (based variant ->
    `__GrowSeg` -> DOS trap)") — that note already correctly identified
    `__GrowSeg` as a DOS-trapping function to avoid for the NEAR heap; Stage
    A is precisely "stop avoiding it, retarget it instead" for the FAR heap.
- [ ] `fmalloc.c`/`ffree.c`/`frealloc.c`/`fcalloc.c`/`fmsize.c`/
      `fheapset.c`/`fheapchk.c`/`fheapmin.c`/`fheapwal.c` themselves need
      **zero changes** — they're already OS-generic on top of
      `__AllocSeg`/`__GrowSeg`. Link them in unmodified, same pattern as the
      near-heap port reusing nmalloc/nfree/calloc/etc. unchanged
      (`[[reference_watcom_cpm86_heap_shim]]`).
- [ ] Decide the user-facing API: expose Watcom's native `_fmalloc`/`_ffree`
      naming (simplest, matches upstream), or additionally provide a CP/M-86
      convenience wrapper. Lean toward native naming — don't invent new API
      surface for something Watcom already names consistently.

### Phase A3 — crt0: (mostly) nothing to do, per §2.5 of the System Guide

**Simplified 2026-08-18** from the original scoping (which assumed manual
base-page parsing would be needed). CP/M-86 System Guide §2.5 "The Compact
Memory Model" (`[[reference_cpm86_cmd_header]]`'s new section) states
plainly: *"the CS, DS, and ES registers are set to the base addresses of
their respective areas"* — **the loader itself sets ES to the Extra group's
base automatically at program entry**, the same load-time mechanism that
already sets CS/DS today (matches small model's measured `DS=ES=data group`
at entry). "Compact Model" is the CP/M-86 loader's OWN name for this
scenario (code+data plus ≥1 of stack/extra/auxiliary) — independent
confirmation this is the right model to target, not just a Watcom-side
coincidence.

- [ ] `port/farheap.c`'s `__AllocSeg` (Phase A2) should read the **current
      `ES` register directly** (e.g. inline `mov ax, es`) on its first call —
      NOT walk the base page. crt0 needs no new code for this at all.
- [ ] Confirm empirically (real RC759 or MAME register dump, same technique
      as the existing small-model proof in
      `scratch/rc759-cmd-toolchain/wlink-cmd-test/RC759_ENTRY_REGISTERS.png`)
      that ES really does land on the Extra group's base once wlink actually
      emits one (Phase A1) — the System Guide text is authoritative but
      hasn't been checked against wlink's OWN loader output yet.
- [ ] SS/SP auto-setup is explicitly NOT part of Stage A (System Guide: SS/SP
      stay in the CCP's own area even when a Stack group exists — it's the
      *program's* job to switch, only relevant once Stage B/a Stack group
      shows up). Don't add stack-group crt0 code prematurely.

### Phase A4 — verification

- [x] Test program using ONLY `_fmalloc`/far heap (not regular `malloc`) for
      an allocation total exceeding 64 KB (many small far allocations, not
      one big one — no huge-pointer normalization exists here, see
      `[[reference_cpm86_big_model]]`'s far-vs-huge explanation, so a single
      allocation stays ≤64 KB same as DOS far heap always has). Done as
      `test/farheaptest.c` — 130 pseudo-random-sized blocks, overlap-
      detecting fill pattern, verified only after all allocations complete.
- [x] emu2 leg: **298,973 bytes across 130 blocks, 0 corrupted** (2026-08-18,
      commit `b8cfd0d10e`).
- [x] MAME rc759 leg — **DONE 2026-08-18**, on the GENUINE CCP/M-86 disk.
      `floptool` built via `make SUBTARGET=regnecentralen REGENIE=1
      TOOLS=1 SOURCES=... OSD=sdl` (recipe was already in
      `[[reference_mame_regnecentralen_rc75x_imd]]`, found only after
      several blind `make TOOLS=1 ...` guesses failed).
      **Two real design corrections found along the way, both fixed and
      re-verified:**
      1. A fixed `G_Min==G_Max==300 KB` request got REJECTED outright by
         real Concurrent CP/M-86 (`"Concurrent Fejl: For lidt lager"`).
         Fixed at the wlink level: `G_Min=1` paragraph, `G_Max=<size>` as
         a ceiling — the loader now grants whatever's actually free
         (commit `3c79eea897`).
      2. `farheaptest.c`'s original fill pattern (single shared slope,
         only the start value varied by block index) had a real blind
         spot: blocks 256 apart in index got an IDENTICAL byte sequence,
         making an overlap between that pair undetectable — a live risk
         once the test runs to exhaustion (250+ blocks). Fixed by
         deriving the slope from a second, coprime period (251) as well.
      First attempt also used the WRONG A: disk (Bits:30002654, cataloged
      as "CDOS systemdisk" — a different DRI product that happens to
      share CCP/M-86's BDOS error text, "Concurrent Fejl", which is what
      caused the initial confusion) — corrected to the genuine
      `sw1400-r3.1a-disk1.img` CCP/M-86 disk, which turned out to already
      be a ready **4-console** system (see
      `[[reference_ccpm86_boot_disk_and_4console_todo]]`'s correction —
      the old "needs installing" TODO was wrong). Booted straight into
      the test by overwriting `0:startup.0` (a plain-text CP/M command
      file) rather than fighting the interactive installer menu's
      confirmation prompts.
      **Final verified result on real hardware:** `allocated 181647
      bytes in 79 blocks (far heap exhausted)` / `PASS (0 blocks
      corrupted)` — genuine Concurrent CP/M-86 3.1, 384 K RAM / 261 K
      brugerlager, screen-captured. Commits `d9b1de395b`, `3c79eea897`.
      **Follow-up investigation (commit `2d809fc6da`):** 261K−181,647 B
      leaves an unexplained ~33 KB gap vs. our own CODE+DATA footprint.
      Ruled OUT: Watcom's own `_fmalloc()` has a genuine near-heap
      fallback (falls back to `_nmalloc()`/DGROUP once the Extra group is
      exhausted) — added detection (`_getds()` + segment check) and
      shrank the test's near-heap arena from 36 KB to 32 B; the MAME
      number was **byte-identical** before and after (181,647 B/79
      blocks, confirmed "real out-of-memory" both times) — so the
      fallback was never actually firing, not the explanation. Still
      open: shrinking our own CODE+DATA by ~36 KB did not grow the Extra
      grant by a matching amount at all — points to Concurrent CP/M-86's
      allocator handing the Extra group the largest free CONTIGUOUS
      block, capped by fragmentation from the 4-console system's other
      resident state, not by this program's own footprint. Not pursued
      further (out of scope for Stage A itself).
- [ ] PCE/rc759 leg — not started. Lower priority now: MAME already
      exercised real hardware-class constraints (RAM budget); PCE would
      mainly cross-check MAME's rc759 driver itself, not the far-heap
      logic.
- [ ] Regression script under `open-watcom-v2/contrib/ravn/` (linker/runtime
      work, not backend codegen — no LLVM lit test applies here).

---

## Stage B — code > 64 KB across multiple segments

Deferred until Stage A ships. Retains the phase numbering/content from the
original single-stage plan (2026-08-18 draft), renumbered B1-B4:

### Phase B1 — resolve the far-pointer-width sub-question for Stage B's OWN needs — **DONE 2026-08-18**

- [x] Compiled a small two-function DR C oracle test (`caller.c`/`callee.c`,
      `drc-oracle.sh`'s underlying toolchain, `-b` big model) and
      disassembled the OBJECT files directly with `wdis -a` (cleaner than
      disassembling the linked `.CMD`). Confirmed DR C's exact contract:
      each compiled module gets its OWN uniquely-named `CODE`-class
      segment (`CALLER_CODE`, `CALLEE_CODE` — not a shared `_TEXT`), and
      every call to an extern is unconditionally `call far ptr <name>`
      with a matching `retf` — a static per-module policy, not a
      link-time size computation. DATA stays merged into one shared
      DGROUP as usual (only CODE is kept apart). This is exactly the
      shape a wlink Stage B implementation needs to reproduce: pack
      same-class CODE segments from many modules into one Code Group
      Descriptor without merging them into one logical segment, then let
      ordinary OMF far-call relocation fixups resolve the cross-segment
      calls — nothing CP/M-86-specific about the call mechanism itself.

### Phase B2 — wlink: emit multi-segment CODE + STACK group descriptor — **IN PROGRESS, blocked on a real design decision (2026-08-18, session paused here)**

**Uncommitted change so far:** `bld/wl/c/cmdall.c` — added `_CPM86` to
the `#if` guard + `MK_CPM86` to the mask for the existing generic
`OPTION PACKCODE`/`PACKData` options (was `_OS2`/`_EXE`/`_DOS16M`/`_QNX`
only). Rebuilt wlink clean. **NOT YET COMMITTED** — see finding below
before committing; the option alone is necessary but not sufficient.

**Empirical finding (real, load-bearing — read before continuing):**
Compiled a 2-function `-mm -zm` test (`main_` calls `callee_`, each its
own segment per Phase B3's finding), linked `format cpm86` with the
now-enabled `OPTION PACKCODE=<limit>`:

- **`PACKCODE` large (0xF0000, i.e. "don't split")**: wlink's existing
  `AutoGroup` pass (`bld/wl/c/autogrp.c`) packs BOTH function-segments
  into ONE auto-group, contiguous (`callee_TEXT` at 0001:0000,
  `main_TEXT` right after at 0001:0002 per `op map` output) — and
  `loadcpm86.c`, COMPLETELY UNCHANGED, already emits exactly one correct
  G-Type=1 descriptor for it. The `far ptr callee_` call got
  link-time-optimized down to a near `jmp` (both ended up in the same
  real segment) — worked perfectly, zero new code needed for this case.
- **`PACKCODE` deliberately tiny (8 bytes, to force a split cheaply
  without writing 64 KB of real code)**: `AutoGroup` now makes TWO
  separate real segments (`callee_TEXT` at internal address `0001:0000`,
  `main_TEXT` at `0002:0000` — different "segment" slots in wlink's own
  map). Two real problems surfaced:
  1. `loadcpm86.c`'s per-`Groups`-entry loop (unchanged since Phase 1)
     emitted **TWO separate G-Type=1 (CODE) descriptors** — almost
     certainly invalid per the CP/M-86 header format (Table 3-1 implies
     at most one descriptor per type; DR C/LINK-86's own big model
     always produces exactly one Code descriptor even when internally
     spanning many segments, `[[reference_cpm86_big_model]]`).
  2. Worse: the `jmp far ptr callee_` in `main_TEXT`'s machine code was
     encoded as `EA 00 00 00 00` — **segment operand = 0x0000**, not the
     correct `0x0001`. Confirmed NOT an artifact of the synthetic test's
     `op undefsok`/missing-crt0 warnings (re-verified: `_cstart_` is an
     unreferenced stray `EXTRN`, unrelated to this fixup; a clean link
     produces the identical wrong value with zero warnings about it).

**Root cause (why this happens, not yet a bug in the usual sense):**
CP/M-86's `.CMD` format is fully relocatable per-descriptor (`A-Base=0`
in every Phase-1-emitted header, per `[[reference_cpm86_cmd_header]]`) —
the LOADER, not the linker, picks each descriptor's real load address,
and per-descriptor independently (no guarantee of contiguity between
descriptors). wlink's GENERIC address-resolution engine (shared by every
format) evidently assumes something more DOS-like — one uniform,
link-time-computable relocation base for the whole image — and silently
bakes in a placeholder/zero segment value for a cross-group far pointer
with no warning at all. This never mattered for Phase 1 (small model
never has more than one CODE group) or for Stage A's Extra group (no
code lives there, so no far CALL/JMP ever targets it). It only bites
once code is deliberately split across genuinely different real
segments — exactly Stage B's whole point.

**Decision — RESOLVED 2026-08-19 (macbook): Option 1, real fixup records.**
Ran the three-way's own option 3 first (investigate DR C's LINK-86), and it
settled the whole question empirically. Built a clean 2-module DR C 1.11
large-model program (`moda.c` calls extern `callee` in `modb.c`, each its
own CODE segment) under `emu2` and decoded its `.CMD`. Full decoded wire
format + cross-check in `[[reference_drc_cpm86_reloc_format]]`. Findings:

- DR C large model emits `9A 00 00 00 00 call callee` (segment operand 0 in
  the .OBJ, fixed up by the linker) — the same far-call contract as our
  `-mm -zm`.
- LINK-86's output has **`header[0x7F] = 0x80` (fixup bit 7 SET)** and a
  **trailing relocation table** of 4-byte records
  `[group-nibbles][para-offset:2 LE][byte-in-para:1]`; the low nibble
  selects which group's load segment the loader adds (1=CODE base, 2=DATA
  base). LINK-86 writes each far segment field as a **group-relative
  paragraph**, and the loader adds the real load segment at load time.
- **Every group descriptor has `A_Base = 0`** — DR C is fully relocatable.
  → **Option 2 (fixed A-Base) is RULED OUT**: the reference toolchain
  demonstrably does not use it, and a fixed TPA address is unsafe under a
  multi-console Concurrent CP/M-86 system anyway.
- Bonus: DR C large model layout = CODE + DATA + **EXTRA (far heap, G_Max
  0x800)** + dedicated **STACK** group — the EXTRA/STACK groups match what
  Stage A already emits, confirming our design direction.

Concrete wlink spec for the remaining work is in
`[[reference_drc_cpm86_reloc_format]]` ("Concrete wlink implementation
spec"): (1) coalesce all CODE-class groups into ONE type-1 descriptor;
(2) intercept `FORMAT CPM86` segment relocations so cross-group far
segments become loader fixup records (group-relative paragraph in the
image + a 4-byte table entry) instead of link-time-zeroed values;
(3) set `header[0x7F] |= 0x80` and append the paragraph-padded table before
`DBIWrite()`; (4) optionally emit the type-4 STACK group. Step (1) is
independent and needed regardless. **The relocation-engine intercept (step
2) is the real remaining implementation effort and requires MAME/emu2
verification — not yet started.**

- [ ] (Blocked on the above) Extend `cmdcpm86.c`/`loadcpm86.c` to gather
      ALL segments/wlink-groups whose class is `CODE` and concatenate
      them into ONE type-1 Code Group Descriptor, each sub-segment
      paragraph-aligned within it — mirroring LINK-86's
      `CODE[SEGMENT[...],CLASS[...],GROUP[...]]` mechanism. This part
      (multiple wlink-groups -> one descriptor) is independent of the
      fixup question and can proceed regardless of which of the 3
      options above gets picked — it's needed either way.
- [ ] Add G-Type 4 (Stack) descriptor too — DR C's own big model still caps
      the stack at 64 KB (confirmed from the manual — big model doesn't
      relax the stack), but per Watcom's own precedent this is worth giving
      its own descriptor anyway (matches `[[reference_cpm86_cmd_header]]`'s
      note that large/compact-model crt0s read SS:SP from a dedicated
      Stack-group base-page entry rather than computing it from DGROUP).
- [ ] Audit `G-Length` computation isn't hardcoded/assumed small — confirm
      it already handles "one descriptor, many concatenated segments" (may
      already be correct by construction from phase-1; audit, don't assume).

### Phase B3 — decide + wire the Watcom compiler-side model selection — **mostly ANSWERED 2026-08-18**

- [x] Audited Watcom's i86 backend (agent investigation, file:line cited
      in `[[reference_cpm86_big_model]]`) — **`-mm` ALONE gives no
      per-file/per-function segment isolation**: segment naming is
      static (`_TEXT`, `bld/comp_cfg/h/langenv.h`'s `TS_SEG_CODE`) and
      completely model-independent (`SetSegs`, `cinfo.c:629`); `-mm`'s
      `CGSW_X86_BIG_CODE` only changes pointer size/call-class semantics,
      never segment identity. **But `-mm` + `-zm` together already do
      exactly what Stage B needs**, zero new compiler code: `-zm`
      (`CompFlags.zm_switch_used`, `cdecl1.c:182-201`) makes the compiler
      synthesize one segment PER FUNCTION named `<funcname>_TEXT`
      whenever `CGSW_X86_BIG_CODE` is set — an existing, already-tested
      Watcom mechanism (normally used for DOS overlays/smart-linking),
      not something to build. Verified empirically: `wcc -bt=dos -mm -zm`
      on a 2-function test + `wdis -a` shows `callee_TEXT`/`main_TEXT`
      segments and `jmp far ptr callee_` between them (tail-call-optimized
      far jump) — same contract as DR C's, just per-function instead of
      per-file (strictly better: no per-file 64 KB ceiling either).
      wlink's own group-formation is ALSO confirmed model-independent and
      opt-in-only (`-g` switch, `x86obj.c:1068`) — by default, distinct
      same-class segments are NOT auto-grouped by wlink's generic layer,
      confirming Phase B2 (not the compiler) owns "pack many CODE
      segments into one Group Descriptor."
- [ ] Decide: is `-mm -zm` the DOCUMENTED, required Stage B compile
      convention (simplest — just tell users to pass both flags, matches
      how `-zm` already works for other Watcom targets), or should
      `format cpm86`'s own Stage-B mode flag imply `-zm` automatically
      when big-code is set (nicer UX, more invasive — would need a
      CP/M-86-specific tweak in `cdecl1.c`'s `-zm` gate). Lean toward
      "just document `-mm -zm`" first; only add the implicit-imply
      convenience later if it proves error-prone in practice.
- [ ] Decide whether an *invalid* combination (Stage B requested at link
      time but code isn't actually multi-segment, e.g. `-zm` was forgotten)
      should be a hard link-time error, matching the existing "reject
      unvalidated models" policy (`Proc8080()` precedent) — probably not
      enforceable at link time anyway (wlink can't know the compile flags
      used), so likely N/A; single-segment code under a Stage-B-format
      link should just work unchanged (one Code Group Descriptor,
      trivially the degenerate n=1 case).

**Naming — DECIDED 2026-08-18 (user confirmed):** Stage B = Watcom's own
**medium model** (`-mm`: far code, near data). The previously PARKED
question is closed; "Stage B" in this plan is now interchangeable with
"medium model" in prose/commits going forward.

### Phase B4 — crt0 + verification

- [ ] Extend crt0's Stage-A ES-reading addition (Phase A3) with CS/multi-
      segment awareness if needed (likely nothing extra — far calls burn in
      their own target addresses at link time, crt0 doesn't need to know
      about individual code segments beyond the entry point).
- [ ] Test program whose CODE section (via padding/multiple source files)
      exceeds 64 KB total, each individual segment ≤64 KB — same three-tier
      emu2 → MAME → PCE verification as Phase A4.

---

## Explicitly out of scope for this plan

- The 8080 single-group model (already implemented, rejected by design).
- Watcom's generic (non-CP/M-86) medium/large/huge model support for OTHER
  targets (DOS, Windows, etc.) — those already exist; this plan is only about
  making `FORMAT CPM86` emit the right `.CMD` shape and runtime plumbing for
  *this* OS's loader contract.
- Huge-pointer normalization (single allocation/object > 64 KB) — neither DR
  C's manual nor Watcom's own far-heap API implies this is needed; revisit
  only if a concrete production need shows up (see
  `[[reference_cpm86_big_model]]`'s far-vs-huge explanation).
- CP/NET or any multi-console/networking angle — unrelated to memory models,
  don't conflate with the parallel `reference_ccpm86_boot_disk_and_4console_todo.md`
  TODO.
