---
name: feedback_upstream_routing_two_targets
description: How to route fixes between the two upstreams — official LLVM vs @zlfn's z80 fork
metadata:
  type: feedback
---

There are two upstreams and fixes route by **where the fix physically lives**, not by destination choice:

- **Generic LLVM fixes** (`llvm/lib/...` outside `Target/Z80/`) go to **official `llvm/llvm-project` ONLY.**
- **Z80-backend changes** (`llvm/lib/Target/Z80/`) go to **@zlfn `llvm-z80/llvm-z80` ONLY** (can't reach official until the Z80 target is upstreamed).

**Why:** @zlfn's fork does periodic upstream syncs (`Merge remote-tracking branch 'upstream/main'`), so an accepted generic fix flows down to @zlfn (and to our `ravn/llvm-z80`) automatically over time. Do NOT separately PR a generic fix to @zlfn — the duplicate would conflict with the canonical version when the sync arrives.

**How to apply:** (1) Keep each local generic commit in exact upstream-ready shape so the future sync merges/drops it cleanly instead of conflicting. (2) Track "pending upstream" local commits (in #186) so they can be dropped/rebased once the sync brings the canonical version. See [[project_z80_upstream_goal]]. Counts as of 2026-05-30: 8 official-bound generic items (5 PR-ready, 3 report-only), ~25 backend-only items to @zlfn.
