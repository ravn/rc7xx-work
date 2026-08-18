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
