---
name: Cross-compiler Makefile recipes must produce identical artifact sets
description: HARD RULE — when a Makefile has parallel recipes per COMPILER (clang vs sdcc vs hitech), each must emit the SAME set of artifact files; an asymmetry where one branch emits prom0_padded.ic66 and another doesn't silently breaks downstream install rules
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
**HARD RULE (2026-05-08):** When a Makefile has parallel recipes per
compiler (`ifeq ($(COMPILER),clang) ... else ... endif`), the artifact
set produced by each branch must be **identical**.  If recipe A emits
`{prom0.bin, prom1.bin, cpnos.bin, prom0_padded.ic66}` and recipe B
emits `{prom0.bin, prom1.bin, cpnos.bin}` (missing the padded image),
downstream rules that install `prom0_padded.ic66` to MAME's roms dir
fall back to whatever stale file is on disk — produced by the OTHER
compiler's last build.  Symptom: PROM0 from build N-1 + PROM1 from
build N → relocator's word-additive checksum fails → "BAD CHECKSUM"
on display → no boot.

**Why:** Spent ~30 min today (2026-05-08, session 47 evening) chasing
a phantom checksum-verify bug.  Trace was empty.  Display showed
"BAD CHECKSUM".  Every byte on disk computed the right sum.  Every
md5 through the install chain matched.  But MAME loaded
`/Users/ravn/git/mame/roms/rc702/roa375.ic66` from 16:52 (the
SDCC-build PROM0 from earlier in the session) alongside
`prom1.ic65` from 17:12 (the clang-build PROM1 just made).  Mismatched
PROMs.  Root cause: `cpnos-rom/Makefile` line 580-585 (clang
`cpnos.bin` recipe) emits prom0.bin + prom1.bin + cpnos.bin but does
**not** generate prom0_padded.ic66.  SDCC's recipe at line 1798-1812
DOES generate it.  Empty rule at line 739 (`prom0_padded.ic66
prom1.bin: cpnos.bin` with `@:`) trusted the recipe to update its
timestamp as a side-effect.  Side-effect missing → install-rule
sees prom0_padded.ic66 as older than the installed roa375.ic66 → no
copy.

**How to apply:**

- When adding/modifying a per-COMPILER recipe block, list the
  artifact set the OTHER branches emit and verify yours emits all of
  them.  If a branch genuinely shouldn't emit one, document the
  exception explicitly — don't leave it implicit.
- For "umbrella" generated-file rules with empty recipes (`@:`), add
  a build-time check that confirms the listed targets actually got
  produced after the dependency recipe ran (`stat -c %Y` comparison
  or simple existence check).  An empty rule is a CONTRACT that the
  dependency will create those files; verify the contract.
- Audit cue: `find . -name Makefile -exec grep -l 'ifeq.*COMPILER' {} \;`
  followed by per-block target-set comparison.  Symmetric branches
  only need their head-of-block targets diff'd; recipe-set asymmetry
  is what hurts.

**Discriminator** — when this rule applies:

- ANY Makefile with `ifeq ($(COMPILER),...)` or sibling
  switch-statement variable.
- ANY build pipeline that emits files consumed by `cp` install rules
  outside the recipe (so dependency tracking is the only safety
  net).

**Discriminator** — when this rule does NOT apply:

- Pure derived-output rules where ALL outputs come from a single
  pre-COMPILER recipe.  No asymmetry possible.
- Per-compiler files that are explicitly single-compiler (e.g. a
  source-listing target only meaningful under clang).  The artifact
  asymmetry is intentional and the install rule should be gated.

**Class label:** "stale-ROM-in-MAME bug class" was already covered by
`feedback_check_banner_timestamp.md` (banner pre-flight check); this
rule covers the build-side root cause that produces stale ROMs in
the first place.  Both rules apply: the banner check catches the
symptom, this rule prevents the cause.
