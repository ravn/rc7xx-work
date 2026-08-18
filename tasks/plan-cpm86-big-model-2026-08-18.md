# Plan: CP/M-86 "big" memory model for Watcom `FORMAT CPM86` (phase 2)

Status: DRAFT, not started. Companion docs (read first):
`tasks/memory/reference_cpm86_big_model.md` (what "big model" means, from the
DR C manual), `tasks/memory/reference_cpm86_cmd_header.md` (the `.CMD` header
byte layout), `tasks/memory/reference_watcom_wlink_cpm86_format.md` (current
phase-1 small-model-only implementation).

## Goal

Give Watcom's native `wlink FORMAT CPM86` the ability to emit a CP/M-86 big
model `.CMD` — i.e. two independent capabilities, both needed for the RC759
production firmware work to eventually exceed the 64 KB small-model wall:

1. **Code > 64 KB**, spread across multiple separately-addressed far segments.
2. **Heap > 64 KB**, in a dedicated Extra (ES) segment outside DGROUP.

Both map to the SAME underlying mechanism — additional `.CMD` Group
Descriptors (G-Type 1=Code already used, add 3=Extra and 4=Stack) — but they
touch different parts of the toolchain (linker/loader vs. compiler codegen vs.
C runtime), so they're separate phases below.

## Phase 0 — resolve the one open documentation question (before designing anything)

`reference_cpm86_big_model.md` flags one thing NOT confirmed from manual text:
does DR C's `-b` compiler make **every** pointer uniformly far (4 bytes,
segment:offset), or does it do something narrower? This determines whether
Watcom's big-model heap runtime needs a uniform far-pointer ABI or a mixed
near/far one.

- [ ] Compile a small malloc-using test program with the DR C oracle
      (`scratch/rc759-cmd-toolchain/drc-oracle.sh`, which per its own header
      comment already defaults to the "LARGE"/big model + `CLEARL.L86`) — a
      `char *p = malloc(n); p[big_index] = ...;` style test that would reveal
      `LES`/far-load codegen if used.
  - Note: the oracle script as-is only demonstrates output via a
    `DRC_PUTCHAR=1`-injected far putchar; a pointer-width probe just needs the
    resulting `.OBJ`/`.CMD` disassembled, not necessarily run.
- [ ] Disassemble the resulting object/CMD (Watcom's `wdis` can disassemble
      raw 8086 code; `mandel_watcom.dis` in `scratch/rc759-cmd-toolchain/` is
      a precedent for how this was done before) and look for `LES`/`MOV
      AX,ES` around heap-pointer accesses vs. plain 16-bit offset math around
      DGROUP-local variable accesses.
- [ ] Record the answer back into `reference_cpm86_big_model.md`'s "Open
      sub-question" section — this blocks Phase 4 design (below), not Phases
      1-3.

## Phase 1 — wlink: emit STACK and EXTRA group descriptors

Current state (`bld/wl/c/cmdcpm86.c`/`loadcpm86.c`, ~226 lines total):
small-model-only, emits exactly 2 descriptors (CODE=1, DATA=2), `A-Base=0`,
no fixup table.

- [ ] Add G-Type 4 (Stack) and G-Type 3 (Extra) descriptor emission, gated on
      a new `format cpm86` linker option (working name: `option cpm86_big` or
      reuse Watcom's existing `-mm`/`-ml` memory-model selection to switch
      `cmdcpm86.c`'s descriptor-count logic — needs a decision, see Phase 2).
- [ ] Stack section: size from wlink's existing `OPTION STACK=` (already a
      general wlink option; needs cpm86-format-specific wiring to become a
      Stack *group descriptor* instead of being folded into DATA/BSS the way
      small model does today).
- [ ] Extra/heap section: size from a new linker option (`OPTION HEAPSIZE=`,
      already exists generically for some other formats — check reuse vs. a
      cpm86-specific option) written into G-Min/G-Max of the Extra
      descriptor, per `reference_cpm86_cmd_header.md`'s byte layout.
- [ ] Code section: verify `G-Length` computation isn't hardcoded/assumed to
      fit some small bound — confirm it already handles the "one descriptor,
      many concatenated segments, up to ~1 MB" case correctly (it may already
      be correct for phase 1 by construction; audit, don't assume).
- [ ] Lit-suite equivalent: no LLVM codegen involved here, this is pure
      linker work — add a small integration test under
      `open-watcom-v2/contrib/ravn/` (mirroring the existing small-model
      proof scripts) rather than an LLVM lit test.

## Phase 2 — decide + wire the Watcom compiler-side model selection

Open design question, must be settled before Phase 1's option-gating can be
finalized: which Watcom compiler memory-model flag (if any existing one, or a
new cpm86-specific mode) produces "many separate, non-CGROUP-merged code
segments, near DGROUP" — i.e. DR C big model's exact segment topology?

- [ ] Audit Watcom's i86 backend segment/group emission for `-mm` (medium:
      far code, near data) — does it already emit one segment PER COMPILATION
      UNIT without forcing them into CGROUP, or does something in the
      OMF-writing path merge same-class CODE segments into one group
      regardless of `-mm`/`-ms`? (`reference_cpm86_big_model.md`'s earlier,
      unconfirmed inference guessed `-mm`; needs actual verification against
      Watcom's OMF/group-emission source, not just theory.)
  - If `-mm` already does the right thing: Phase 1's `cmdcpm86.c` just needs
    to recognize "code from multiple non-CGROUP segments" and lay them into
    one Code Group Descriptor per the LINK-86-equivalent CLASS/SEGMENT
    concatenation described in `reference_cpm86_big_model.md`.
  - If not: may need a new format-specific compiler flag/mode, more invasive.
- [ ] Once settled, this is also where the "8080 model rejected" precedent
      (`Proc8080()` fatal in `cmdcpm86.c`) gets a sibling: decide whether an
      *invalid* combination (e.g. big model requested but code still lands in
      CGROUP) should be a hard link-time error, matching the existing
      "reject unvalidated models" policy for this format.

## Phase 3 — crt0 (`cstartcpm.obj`): read SS:SP and ES from the loader-set base page

`reference_cpm86_cmd_header.md` already documents the target behavior,
copied from DR C's own `startup.a86`: in big model, the loader deposits Stack
and Extra group info in the base page (offsets past 0x12, alongside the
existing 0x00/0x06 code/data descriptors small model already reads) and crt0
must read SS:SP from there rather than computing a stack pointer from DGROUP
the way small-model `cstartcpm.asm` does today.

- [ ] Extend `open-watcom-v2/contrib/ravn/cpm86-clib/cstartcpm.asm` (or its
      current equivalent — confirm exact current filename/location, it may
      have moved since the small-model proof) with a big-model code path,
      gated the same way Phase 2 gates compiler output (so small-model
      programs are completely unaffected — this must not regress the
      existing MAME-verified small-model boot).
- [ ] Set ES from the Extra group descriptor's loaded base (base page offset
      per `reference_cpm86_cmd_header.md`'s "0x00 code, 0x06 data, 0x0C
      extra, 0x12 stack" table — CONFIRM this table's offsets are exactly
      right for the 4-descriptor case; it was documented from the 2-
      descriptor small-model case and needs re-verification against the
      System Guide's base-page section for the general N-descriptor case).

## Phase 4 — heap/malloc runtime: retarget to the Extra segment

The biggest, most uncertain-scope item — blocked on Phase 0's answer.

- [ ] If pointers are uniformly far under big model: Watcom's own clib
      already has a far/huge pointer heap path for other 8086 targets (large
      model DOS, etc. — `bld/clib/heap/`) that may be reusable almost as-is,
      the way the existing small-model cpm86 port reused DOS's `sbrk.c`/`__brk`
      seam (`reference_watcom_cpm86_heap_shim.md`). Look there FIRST before
      writing new allocator code.
- [ ] If narrower: design a CP/M-86-specific seam analogous to the existing
      `watcom-cpm86-libc/port/lowlevel.c` arena-bump `__brk`, but sized/based
      from the Extra group's loaded ES base + G-Max instead of static BSS.
- [ ] Single-allocation-size cap: confirm whether a >64 KB single `malloc()`
      needs "huge pointer" normalization (re-carrying offset overflow into
      the segment on pointer arithmetic) or whether it's simply
      out-of-scope/unsupported (DR C's own manual gives no indication it
      supports single allocations >64 KB — likely fine to leave unsupported
      initially, matching DR C's own apparent behavior, revisit only if a
      concrete production need for a >64 KB single allocation shows up).

## Phase 5 — verification

- [ ] A test program whose CODE section (deliberately, via padding/multiple
      source files) exceeds 64 KB total but keeps each segment ≤64 KB — prove
      it links, loads, and runs under emu2 first (fast iteration), then MAME
      rc759 (`[[reference_rc759_mame_c_verification]]`-style), then cross-
      check under PCE/rc759 (`[[reference_pce_rc759_headless_automation]]`,
      now that the two-oracle setup exists — this is a good first real use of
      PCE as the RC759 hardware cross-check for something MAME hasn't been
      asked to verify before).
- [ ] A test program whose heap usage (many small mallocs, not one big one)
      exceeds 64 KB total — same three-tier verification.
- [ ] Add both as lit-suite-adjacent regression fixtures per the project's
      standing rule ("whenever you modify the compiler, always add a lit
      test" — this is linker/runtime, not backend codegen, so the equivalent
      here is a permanent script under `open-watcom-v2/contrib/ravn/`, not an
      LLVM `.ll`/`.s` lit test).

## Explicitly out of scope for this plan

- The 8080 single-group model (already implemented, rejected by design).
- Watcom's generic (non-CP/M-86) medium/large/huge model support for OTHER
  targets (DOS, Windows, etc.) — those already exist; this plan is only about
  making `FORMAT CPM86` emit the right `.CMD` shape and runtime plumbing for
  *this* OS's loader contract.
- CP/NET or any multi-console/networking angle — unrelated to memory models,
  don't conflate with the parallel `reference_ccpm86_boot_disk_and_4console_todo.md`
  TODO.
