# Z80 backend: recognise small-copy / fill loops and lower to LDIR — 2026-06-21

Filed out of the bug-5 cost-witness hunt (see
`upstream-5bug/avr-triage-2026-06-07.md` addendum 2026-06-21).  This is a
**Z80 backend pattern-match concern**, NOT the upstream InstCombine
consistency bug (bug 5), which is parked.  Separating it here so the two
never get conflated again.

## The use case (motivating shape)

Populating a jump table by copying a 3-byte jump (`JP nnnn`, opcode + 16-bit
address) into the memory area immediately following it, repeated for each
table slot — the classic self-propagating Z80 fill where `LDIR` with
`DE = HL + len` replicates a seed pattern across a region in one instruction.

The ideal lowering is a single `LDIR` (or a short `LDIR`-based fill), which
on Z80 is the densest and fastest way to do a block copy/replicate.

## Symptom (KNOWN — verified from source)

The InstCombine memcpy->integer fold does NOT touch a 3-byte copy: in
`SimplifyAnyMemTransfer` (InstCombineCalls.cpp:165),
`if (Size > 8 || (Size & (Size-1))) return nullptr` rejects size 3
(`3 & 2 == 2 != 0`).  So whatever the Z80 backend does with a 3-byte
`llvm.memcpy`, the mid-end is not in the way — the memcpy reaches isel
intact.  This is why bug 5 (the i64-fold consistency issue) is irrelevant to
this use case: different size class, different code path.

## Suspected cause (GUESSED — not yet investigated)

The Z80 backend likely lowers small fixed-size `llvm.memcpy` to open-coded
byte loads/stores (or a libcall) rather than recognising the copy/replicate
idiom and emitting `LDIR`.  Whether the seed-then-replicate fill (overlapping
src/dst by `len`) is even expressible as a single `llvm.memcpy` — or arrives
as a loop of small copies the backend would need to recognise — is unknown.
Both framings need checking.  **Do not write "caused by X" until the isel /
`Z80ISelLowering`/`Z80SelectionDAGInfo::EmitTargetCodeForMemcpy` path is read
and a repro is lowered and inspected.**

## Investigation plan (read-only first)

1. **Repro.** Write the minimal C for the jump-table fill (3-byte seed +
   replicate) and the plain fixed-size `memcpy` variants; compile with the
   fork `clang`/`llc` (`~/z80/llvm-z80/build/bin`) at -Os/-O2; capture the
   actual Z80 asm.  Baseline FIRST, before touching anything.
2. **Locate the lowering.** Check whether Z80 has an
   `EmitTargetCodeForMemcpy` / `SelectionDAGInfo` hook and what it emits for
   small constant sizes; check whether `LDIR` is reachable from it.  Compare
   against how a mature backend's `SelectionDAGInfo` recognises block moves.
2b. Check the overlapping seed-replicate case specifically — `LDIR`'s
   self-propagating fill relies on `DE = HL + 1` overlap, which `memmove`
   semantics forbid; the idiom may need its own recogniser, not the memcpy
   path.
3. **Decide framing.** Backend missed-opt (fork-internal, like #168/#223) vs
   anything genuinely upstream-general.  Most likely fork-internal — `LDIR`
   is Z80-specific and the recogniser would live in the Z80 target.
4. **Oracle.** If pursued, measure bytes + cycles on simavr-equivalent / Z80
   sim the way bug 4 did (size delta + cycle witness), not just instruction
   count.

## Status

PARKED pending user priority.  Not filed anywhere (no fork issue, no upstream
issue) — this is a task note only, per `feedback_explain_before_filing`
(explain + explicit per-filing go-ahead before any issue is opened).

## Cross-refs

- `upstream-5bug/avr-triage-2026-06-07.md` (addendum 2026-06-21) — why bug 5
  is parked and how this item split off.
- `upstream-5bug/draft-bug5-v2.md` — the parked upstream consistency draft.
