---
name: reference_lld_lto_bypasses_addIRPasses
description: ld.lld LTO backend uses lto::LTO::run(), NOT Z80PassConfig::addIRPasses — custom IR passes never run under -flto
metadata:
  type: reference
---

`ld.lld` under LTO (-flto) does NOT invoke `Z80PassConfig::addIRPasses`.
It uses its own pipeline via `lto::LTO::run()`. Any custom IR pass
registered via `addPass()` in `addIRPasses()` is silently skipped for LTO
builds.

**Observed symptom (2026-10-09, autoload-in-c):** `Z80NonReentrant` ran
for the one -fno-lto object (intvec.c) but never for the main LTO module.
All FDC functions kept IX dynamic frames even though they'd been
non-reentrant under per-file compilation. Net LTO size regression: +62 B
(2171 B non-LTO vs 2233 B LTO).

Verified by inserting `errs()` prints in `addIRPasses()` and
`Z80NonReentrantImpl::run()`:
- `[Z80] addIRPasses optlevel=2` fired per-fil.
- `[NR] module=intvec.c defs=0` fired for the one non-LTO object only.
- Nothing fired for the LTO link-time merged module.

**How to apply:**
- Don't assume `-flto` runs custom target IR passes. Verify with
  `errs()` prints or `-print-after=<pass-name>`.
- If a custom pass is critical for codegen (e.g. NonReentrant → static
  frames), per-file compilation is currently correct; LTO is a
  regression until the pass is registered with the LTO pipeline too.
- To fix properly: register with the new PassBuilder (NewPM) so
  `lto::LTO::run()` picks it up, or build a ModulePass that integrates
  via `-passes=` plugin API. Non-trivial; deferred for autoload.

**Related:** `[[feedback_rcbios_no_lto_boot_placement]]` (unrelated LTO
breakage in rcbios — different root cause, P2 legalizer).
