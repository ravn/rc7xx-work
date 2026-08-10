# ravn/z88dk#54 — random-access stdio write-back: NOT reproducible (CLOSED)

**Status (2026-08-11): CLOSED not-reproducible + regression-guarded.**

The #54 report: classic stdio `fseek()`+`fwrite()` random write-back to an
existing file (`"r+b"` update mode) did not persist and corrupted a neighbouring
record (blamed on `fflush` being a stub). Re-ran the exact repro on current
`master` under ntvcm: **works correctly on BOTH sccz80 and llvmz80** — in-place
write persists (`rec0=99`), neighbour intact (`rec1=22`). A stronger mid-record
oracle (4×128B records, seek to record 2, overwrite, verify all four) also passes
on both toolchains.

Did NOT root-cause *why* it now passes (symptom-gone verified, not a specific
fix). Possible the original measurement was against the retired prebuilt z88dk
2.4, not this dev fork's classic stdio — unconfirmed.

Regression fixture added so it stays covered: `test/clang/runtime_fileio_seekwrite.{c,sh}`
(oracle-based, mirrors `runtime_fileio_eof`). Landed on `master` `3d4af968bd`
(merge), fixture commit `9e45c5277c`. Suite: **62 PASS / 0 FAIL / 2 SKIP / 1 XFAIL**.
Fixture output is single-line-collapsed (newlines → `;`) because run_all.sh
uses `tail -1` to read the PASS/FAIL status.

Reopen + bisect `fflush`/seek only if the write-back failure resurfaces in a
specific environment.
