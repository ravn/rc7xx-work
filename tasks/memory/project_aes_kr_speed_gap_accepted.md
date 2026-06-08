---
name: aes-kr-speed-gap-accepted
description: clang AES K&R `09_Oz_prod_like` is +51 % slower than SDCC post-sound-gate; accepted as a structural limitation, not on the critical path for the four finishing-firmware components
metadata:
  type: project
---

**Fact:** On the AES-256 K&R corpus `09_Oz_prod_like` config, clang is
**−22 % smaller** than SDCC (2581 B vs 3323 B) but **+51 % slower**
(18.21 M vs 12.08 M tstates) as of llvm-z80 main `21ef058` / workspace
`3393d0d` (2026-06-08).

**Why:** The +51 % speed gap traces to `AggressiveInstCombine`'s
Phase 2 (synthetic-trunc-root narrowing) missing on Z80 because
`CorrelatedValuePropagationPass` strips the `(and X, MASK)` marker
that Phase 2 needs.  CVP strips it on Z80 (branch form, driven by
`Z80TTIImpl::getPredictableBranchThreshold = 0`) but not on AVR
(select form).  Full chain documented in
`llvm-z80/tasks/session-2026-06-08-clang-vs-sdcc-speed-investigation.md`
and the draft issue
`tasks/upstream-5bug/draft-cvp-strips-narrowness-marker.md`.

**Why we accepted it:** The four finishing-firmware components
(rcbios, autoload-in-c, CP/NET, cpnos) — see
[[project_finishing_firmware_components]] — are the project goal.  AES
K&R is a corpus benchmark, not on any production component's critical
path.  The size win (−22 %) still holds; the four production targets
are within their hard caps.

**Why we didn't fix it:** Five options were considered (see the
session writeup).  The honest summary:

- (1) Accept regression — chosen.
- (2) Use LVI in AggressiveInstCombine — tried 2026-06-08, LVI returns
  full-set on post-CVP IR; the constraint LVI used to prove
  narrowness was the mask CVP itself stripped.
- (3) Change `getPredictableBranchThreshold` — single line, but high
  risk of regressing other code (every Z80 branch decision).
- (4) Frontend `!range` metadata on uint8_t-sourced phis — cleanest
  architectural fix; needs clang frontend work.  Cross-target benefit.
- (5) Stronger middle-end cyclic-phi range analysis — research-grade
  scope.

**How to apply:** Don't propose v3/v4/v5 work as a default priority.
If a future workload genuinely depends on AES K&R or a structurally
similar shape (uint8_t arithmetic carried through an int-promoted i16
phi inside a loop), revisit.  Otherwise, the four production
components come first.

**Status:** ACCEPTED, not blocked.  Revisit triggers:
- A finishing-firmware component starts to want AES K&R-shape narrowing.
- A user explicitly opts into option (4) frontend work for the
  generic cross-target benefit.
- An upstream LLVM RFC lands a stronger middle-end range analysis.

**Cross-listed with:**

- [[project_finishing_firmware_components]] — the actual priority.
- [[feedback_multi_pass_marker_interactions]] — the lesson about how
  the gap was diagnosed.
- [[feedback_avr_density_oracle]] — the cross-target oracle that
  surfaced the divergence.
- [[feedback_file_bugs_not_fixes]] — informs the draft issue at
  `tasks/upstream-5bug/draft-cvp-strips-narrowness-marker.md`.
