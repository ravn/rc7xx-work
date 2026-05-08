---
name: Watch for unnecessarily slow commands
description: Flag any RC702 command or CP/NET operation that seems unreasonably slow; previous symptoms of this were register clobbering across BIOS calls
type: feedback
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
Keep an eye on wall-clock per operation during RC702 / MAME / CP/NET work.
If an individual command takes unexpectedly long (e.g. LOGIN that used to
take ~1 s suddenly taking minutes, or a DIR that should be quick sitting
for tens of seconds), **raise it** rather than assuming the Z80 is just
slow.

**Why:** In past sessions the telltale of "unnecessarily long" turned out
to be real bugs — most recently BIOS routines not preserving registers
across calls, which caused SNIOS framing to retransmit silently.  The
user noticed it felt slow, and that feeling was the only visible signal.

**How to apply:**
- When running `run_test.sh`, `cpnos-*-test`, or interactive MAME sessions,
  notice if any step seems to hang or lag.  Even if tests pass, flag the
  slowness.
- Quick diagnostics in order: (1) tap the serial traffic with
  `/tmp/cpnet_tap.py` and look for duplicate frame headers (= retransmits)
  or long gaps mid-transaction; (2) compare M->S vs S->M byte counts and
  in-flight latency; (3) check for BIOS/SNIOS changes since the last
  known-fast baseline.
- Baseline (2026-04-22): `cpnet/run_test.sh --no-server --inject --auto
  --headless` takes ~33 s wall-clock, ~83 CP/NET transactions, zero
  retransmits.  Deviations from this shape (many more transactions, or
  dupe frame headers) are the red flags.
