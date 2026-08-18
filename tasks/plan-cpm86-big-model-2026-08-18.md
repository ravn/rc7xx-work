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
  this *next*, after Stage A).

Both still map onto the same `.CMD` Group Descriptor mechanism
(`[[reference_cpm86_cmd_header]]`) — G-Type 3=Extra for Stage A, G-Type
1=Code (multi-segment) for Stage B — but they're independent linker/runtime
changes and should ship as independent, separately-testable increments.

---

## Stage A — CP/M-86 compact model (`-mc`)

### Phase A1 — wlink: accept `-mc` for `FORMAT CPM86` + emit the EXTRA group descriptor

Current state (`bld/wl/c/cmdcpm86.c`/`loadcpm86.c`, ~226 lines total):
small-model-only, emits exactly 2 descriptors (CODE=1, DATA=2), `A-Base=0`,
no fixup table. Today an `-mc` compile would presumably either be silently
mishandled or rejected outright (needs checking — audit current behavior
first, don't assume).

- [ ] Recognize `-mc` (compact) as a second valid model for `format cpm86`,
      alongside small (default). CODE/DATA descriptors are emitted exactly
      as today (no change — compact model's code is still a single ≤64 KB
      CGROUP, same as small).
- [ ] Add G-Type 3 (Extra) descriptor emission when compiling for `-mc`,
      sized via a new linker option (working name: `OPTION FARHEAP=<size>`)
      written into G-Min/G-Max of the Extra descriptor, per
      `[[reference_cpm86_cmd_header]]`'s byte layout.
- [ ] Keep the existing "reject unvalidated models" policy
      (`Proc8080()` precedent): any OTHER `-m` flag (medium/large/huge) stays
      rejected until Stage B is implemented — don't silently accept a model
      this phase doesn't actually support correctly.

### Phase A2 — retarget `__AllocSeg`/`__GrowSeg`: the whole seam already exists

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

### Phase A3 — crt0: set ES from the Extra group's loaded base

- [ ] Extend `cstartcpm.asm` (confirm current filename/location — may have
      moved since the small-model proof) to read the Extra group's loaded
      segment from the base page (offset per `[[reference_cpm86_cmd_header]]`'s
      "0x00 code, 0x06 data, 0x0C extra, 0x12 stack" table — **CONFIRM this
      offset table is exactly right**: it was documented from the
      2-descriptor small-model case; Stage A adds a 3rd descriptor (Extra)
      so re-verify against the System Guide's base-page section rather than
      assuming the table extends trivially) and store it wherever
      `port/farheap.c`'s `__AllocSeg` reads it from.
- [ ] Gate this so plain small-model programs (no Extra descriptor
      requested) are completely unaffected — must not regress the existing
      MAME-verified small-model boot.

### Phase A4 — verification

- [ ] Test program using ONLY `_fmalloc`/far heap (not regular `malloc`) for
      an allocation total exceeding 64 KB (many small far allocations, not
      one big one — no huge-pointer normalization exists here, see
      `[[reference_cpm86_big_model]]`'s far-vs-huge explanation, so a single
      allocation stays ≤64 KB same as DOS far heap always has).
- [ ] Three-tier verification: emu2 (fast iteration) → MAME rc759
      (`[[reference_rc759_mame_c_verification]]`-style) → PCE/rc759
      (`[[reference_pce_rc759_headless_automation]]`) — good first real use
      of the new PCE oracle for something MAME hasn't been asked to verify
      before.
- [ ] Regression script under `open-watcom-v2/contrib/ravn/` (linker/runtime
      work, not backend codegen — no LLVM lit test applies here).

---

## Stage B — code > 64 KB across multiple segments

Deferred until Stage A ships. Retains the phase numbering/content from the
original single-stage plan (2026-08-18 draft), renumbered B1-B4:

### Phase B1 — resolve the far-pointer-width sub-question for Stage B's OWN needs

Stage A already answers "is the far heap far-pointer-addressed" (yes, by
construction — `_fmalloc` always returns far pointers, that's the whole
point of the API). What's still open for Stage B specifically: does calling
a function in a *different* code segment require anything beyond an ordinary
far call (it shouldn't — far calls are a well-understood, already-supported
Watcom compiler feature for its OWN medium/large models on other targets),
or is there a CP/M-86-specific wrinkle. Lower-risk than originally scoped
now that Stage A has de-risked the Extra-segment/far-pointer side entirely.

- [ ] Compile a small malloc-using across-multiple-source-files test with
      the DR C oracle (`scratch/rc759-cmd-toolchain/drc-oracle.sh`, defaults
      to big model + `CLEARL.L86`) with multiple far-called functions;
      disassemble (Watcom's `wdis`; `mandel_watcom.dis` is prior art for the
      technique) to confirm DR C's actual far-call codegen shape as a
      cross-check reference before implementing Watcom's own.

### Phase B2 — wlink: emit multi-segment CODE + STACK group descriptor

- [ ] Extend `cmdcpm86.c`/`loadcpm86.c`: don't merge code segments into
      CGROUP when Stage B is requested; concatenate them into one Code Group
      Descriptor per the LINK-86 `CODE[SEGMENT[...],CLASS[...],GROUP[...]]`
      mechanism described in `[[reference_cpm86_big_model]]` (G-Length up to
      ~1 MB, 16-bit paragraph count).
- [ ] Add G-Type 4 (Stack) descriptor too — DR C's own big model still caps
      the stack at 64 KB (confirmed from the manual — big model doesn't
      relax the stack), but per Watcom's own precedent this is worth giving
      its own descriptor anyway (matches `[[reference_cpm86_cmd_header]]`'s
      note that large/compact-model crt0s read SS:SP from a dedicated
      Stack-group base-page entry rather than computing it from DGROUP).
- [ ] Audit `G-Length` computation isn't hardcoded/assumed small — confirm
      it already handles "one descriptor, many concatenated segments" (may
      already be correct by construction from phase-1; audit, don't assume).

### Phase B3 — decide + wire the Watcom compiler-side model selection

- [ ] Audit Watcom's i86 backend segment/group emission for `-mm` (medium:
      far code, near data) — does it already emit one segment PER
      COMPILATION UNIT without forcing them into CGROUP, or does the
      OMF-writing path merge same-class CODE segments into one group
      regardless of `-mm`/`-ms`? (Earlier inference guessed `-mm`; verify
      against Watcom's actual OMF/group-emission source, not just theory.)
  - If `-mm` already does the right thing: Phase B2's `cmdcpm86.c` just
    needs to recognize "code from multiple non-CGROUP segments."
  - If not: may need a new format-specific compiler flag/mode.
- [ ] Decide whether an *invalid* combination (Stage B requested but code
      still lands in CGROUP) should be a hard link-time error, matching the
      existing "reject unvalidated models" policy (`Proc8080()` precedent).

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
