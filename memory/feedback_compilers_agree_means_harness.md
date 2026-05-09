---
name: When two compilers fail identically, suspect harness not compiler
description: HARD — at end-to-end byte parity, identical failure across compilers means the bug is outside the binary
type: feedback
originSessionId: 9adba288-d140-4e53-8e2b-2f1cfaedce42
---
When testing the same C source with two compilers (clang Z80 + z88dk-zsdcc) and BOTH produce identical end-to-end failures at the byte level — same timing, same single-byte stall, same banner-then-hang — the bug is almost never in the compilers.  Look at the test harness, MAME wiring, network topology, or shared infrastructure first.

**Why:** This is the inverse of Phase 48's diagnostic rule.  Phase 48: compilers diverge on shared C source → dump runtime data structures the foreign code reads from each compiler's binary, the divergence finds the bug.  Phase 49: compilers AGREE on shared C source → the divergence is somewhere outside the binary (test harness, MAME slot wiring, mpm-net2 config, etc.).  The phase-49 trap is spending hours auditing C/asm when both binaries are correct and the topology is wrong.

**How to apply:** When a test fails end-to-end under one compiler, before deep-diving the binary, run it under the other compiler too.  If both fail identically (especially at byte level: same N bytes out, same stall point, same wall-clock timeout), STOP compiler-side investigation.  Audit the test target's MAME invocation, socket wiring, port assignments, and topology assumptions.

Concrete recipe (for cpnos-rom polypascal-test):
1. Run `make cpnos-polypascal-test COMPILER=clang TRANSPORT=$X`
2. Run `make cpnos-polypascal-test COMPILER=sdcc TRANSPORT=$X`
3. Compare `/tmp/cpnos_siob.raw` and `/tmp/cpnos_sioa.raw` byte counts
4. If both produce same banner + same byte count + same FAIL message → harness gap, not compiler gap
5. Inspect the MAME `-piob` / `-rs232a` / `-rs232b` / `-bitb1..3` wiring against what the slave's transport layer actually emits

Phase 49 case: TRANSPORT=sio harness wired PIO-B to mpm-net2 :4002, but SIO transport emits CP/NET frames out SIO-A.  Both compilers wrote 1 byte to SIO-A and hung.  Fix was a Makefile conditional that swaps `-rs232a` to socket :4002 when TRANSPORT=sio, no compiler change.
