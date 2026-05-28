---
name: Sentinel preconditions must be carried with the value
description: Don't promote a context-specific sentinel value to a shared #define without proving the precondition at every use site
type: feedback
originSessionId: 5295f669-4bd6-4de0-8588-d661b7498d99
---
When introducing a sentinel value to mean "no data" / "no result" / "absent",
the constraint that real data can never equal the sentinel must be carried
with the sentinel at every use site — not just the originating one. If the
constraint depends on caller-specific knowledge ("this byte position is
structurally never 0xFF", "this index is always positive", "this status
field is never zero on success"), the sentinel does NOT get promoted to a
shared `#define` or named constant. It either gets inlined where its
precondition holds, or replaced with a non-sentinel design (separate
flag, queue, optional, sum-type).

**Why:** Session 33-34 (2026-04-27/28). I introduced `PIO_RX_EMPTY_VAL =
0xFF` for the first-byte-of-frame sync wait in cpnos-rom's
`pio_recv_msg`. That use was correct — the byte being waited for is the
SCB FMT field, which is structurally never 0xFF. Then I reused the same
`#define` for `transport_pio_recv_byte`, a per-byte primitive called from
arbitrary positions in the data stream. The "FMT is never 0xFF"
precondition no longer applied. Real 0xFF data bytes (RST 38h opcodes,
table fillers) in cpnos.com got silently dropped from the recv stream,
shifting frames by one byte and breaking the protocol parser. Failure
presented as an "intermittent stall after 4-25 sectors" — actually
deterministic at the first sector containing 0xFF (sector 4 of cpnos.com).
Cost: ~3 sessions chasing red-herring chip-emulation bugs before
counting 0xFF bytes in the binary and seeing the data-content correlation.

**How to apply:** Whenever I introduce a sentinel value, write a comment
at the *define* site listing the constraint that justifies the choice,
and re-derive that constraint at every *use* site before referencing the
constant. If a new use site can't justify the constraint, that's a
design smell — refactor to remove the sentinel rather than reuse it.
For "is there data?" specifically: prefer a separate flag / index pair /
ring-buffer head!=tail check over a magic byte value.
