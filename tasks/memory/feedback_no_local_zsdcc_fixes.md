---
name: no-local-zsdcc-fixes
description: Do NOT fix zsdcc/SDCC bugs in the local ravn/z88dk fork anymore — root-cause + minimal-repro them, then mark won't-fix-locally and report upstream to SDCC
metadata:
  type: feedback
---

For **zsdcc / SDCC** bugs (z88dk's bundled SDCC backend): do **not** write or
apply local fixes/patches in the ravn/z88dk fork anymore. Only produce
**upstream reports**.

**Why:** user decision (2026-05-29). Local zsdcc patches are a maintenance
burden and the right home for SDCC codegen/feature bugs is upstream SDCC. The
session that prompted this had just done several local zsdcc patches (#5/#14/#15
REGPARM, #4 `__modsint`-adjacent const-fold, macOS-aarch64 banner); going forward
that stops.

**How to apply:**
- When a zsdcc/SDCC bug is found or triaged: root-cause it and build a **minimal
  repro** (that's the valuable artifact for the upstream report), then mark the
  ravn/z88dk issue **won't-fix-locally**: add the `wontfix` label, `gh issue
  close --reason "not planned"`, with a comment stating it's an upstream SDCC
  bug to be reported upstream later. Pattern set: ravn/z88dk #3 (`#embed`), #16
  (`__modsint` under `--sdcccall 1`), #17 (pi `--sdcccall 1`).
- Do **not** add a new `sdcc-*-z88dk.patch` + Makefile wiring for SDCC bugs.
- Existing local zsdcc patches already applied (REGPARM-preserve, macOS-aarch64,
  const-shift-signext, the standard z88dk patch) **stay** — this is about *new*
  fixes, not reverting.
- **Scope = zsdcc/SDCC only.** llvm-z80 (clang) bugs are still fixed locally in
  the fork (e.g. #156428 LiveVariables, #49 null-pointer-valid, #208 builtin
  gate, #125) — that's the active fork-of-record. See [[no-upstream-issues]]
  (file bug *issues* only in ravn/* forks) — this rule is the complement for
  *fixes*: zsdcc fixes go upstream, not into the local fork.
