---
name: Verify slave banner timestamp matches build before trusting test results
description: HARD RULE — every cpnos-rom test run that produces siob.raw must have its banner's timestamp + git-hash verified against the most recent build BEFORE drawing any conclusion from the trace
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
**HARD RULE (2026-05-08):** Never trust a slave-side trace, register
dump, log buffer, or test outcome until the banner timestamp in
`/tmp/cpnos_siob.raw` matches the most recent build's
`BUILD_INFO_STR`.  Same timestamp across multiple rebuilds = stale
ROM in MAME's roms dir; all subsequent diagnosis is invalid.

**Why:** Spent hours today running BIOS-JT instrumentation that
showed `idx=0` no matter what I changed.  Cause: `make cpnos`
rebuilds `cpnos.bin` and `prom0_padded.ic66` inside
`cpnos-rom/sdcc/`, but only `make cpnos-install` copies them to
`mame/roms/rc702/`.  MAME launched directly via `regnecentralend
... -rompath ...` loaded whatever was in the install location from
the last actual install — in this case the 14:46 build (commit
a18f72), even after I rebuilt at 15:54, 15:59, 16:00, 16:02 with
fresh instrumentation.  Every siob.raw banner showed `14:46
a18f72+`.  I saw it.  I didn't recognize it as stale because I
wasn't comparing to the latest build.

**How to apply (PRE-FLIGHT, not debugging-when-stuck):**
- The PROM-timestamp check is a NON-NEGOTIABLE step BEFORE every test
  run.  Treat it like turning on the build server: the test doesn't
  start until the check passes.
- Single-command pre-flight: `ls -la
  cpnos-rom/sdcc/prom0_padded.ic66 mame/roms/rc702/roa375.ic66`.
  If the ROM file is older than the PROM image build, ROM is stale.
  Run `make cpnos-install` to fix.
- Banner format: `RC702 CP/NOS 55K <transport> <compiler> YYYY-MM-DD
  HH:MM <git-hash>+`.  After every test run, `head -1
  /tmp/cpnos_siob.raw` and check the timestamp.
- Compare against `cpnos-rom/sdcc/cpnos_buildinfo.h` (or the clang
  equivalent) which has `BUILD_DATE_STR` and `GIT_HASH_STR` macros.
  These get regenerated on every `make` so they reflect the latest
  build.
- If timestamps don't match → STOP investigating the test results.
  Run `make cpnos-install` to refresh MAME's roms dir, then re-run.
- Never launch MAME directly via `regnecentralend ... -rompath ...`
  for cpnos-rom tests.  Use targets that depend on `cpnos-install`
  (`cpnos-polypascal-test`, `cpnos-mame`, `cpnos-interactive`,
  `cpnos-netboot`, etc.).
- For ad-hoc Lua probe tests: ALWAYS run `make MIRROR_SIOB=1
  COMPILER=<X> TRANSPORT=<Y> cpnos-install` BEFORE the direct MAME
  launch.  Treat install as a non-skippable prerequisite.

**Why "stale ROM" is special as a class of bug:**
- Visible in every output (banner timestamp) but invisible to
  ad-hoc inspection if you don't think to check.
- Diagnostic instrumentation written into the OLD build never
  shows new behavior, so trace data falsely suggests "the
  instrumentation doesn't fire" when actually "the instrumentation
  isn't loaded at all".
- Cycles waste exponentially: every "fix" that doesn't change
  observed behavior increases attribution to "deeper bug" instead
  of "wrong build loaded".

**Discriminator** — when to apply:
- Any time you read `/tmp/cpnos_siob.raw`, `bios_log_buf`, display
  memory contents, frame counter, or any other slave-side artifact.
- Before commits that claim "instrumentation X doesn't fire" or
  "behavior Y is unchanged".
