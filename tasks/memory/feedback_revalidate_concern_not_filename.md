---
name: revalidate-concern-not-filename
description: When triaging if an issue is resolved, verify the actual symptom in CURRENT source — a moved/renamed/split file or a workaround-in-place is NOT a fix
metadata:
  type: feedback
---

When revalidating whether an open issue is "still problematic," verify the
**actual symptom/concern against the current source**, not the file path or
directory name in the issue.

**Why:** During the 2026-05-28 issue-revalidation sweep, two close-candidate
verdicts were wrong because they reasoned from file/dir identity instead of the
bug:
- A subagent said rc700 #84 was resolved because "snios.asm/.s no longer exist"
  — they DO exist (`cpnet/snios.asm`, `cpnos-in-c/src/snios.s`).
- The whole "parked-tree cluster" (#83/#85/#87/#90/#36/#95) was flagged
  close-as-superseded because `cpnos-rom/` was split into
  `cpnos-shared/cpnos-in-c/cpnos-in-asm`. The user corrected: **"the bugs may
  still be present in the split sources."** They were — every concern had
  carried into `cpnos-in-c` (enter_coldst, the BC→HL bios shims, snios_c.c
  spills, the DMA-refresh and conout-codes tasks, the 25-B PROM budget).

**How to apply:**
- A directory rename / file move / code relocation does NOT resolve an issue —
  grep the *successor* source for the specific function/pattern the issue names
  and confirm the problem is gone.
- A workaround in place (volatile, inline-asm, a safe-path retained) does NOT
  resolve the underlying bug — e.g. rc700 #49 (clang elides memcpy-to-NULL) and
  llvm-z80 #150 stay OPEN because only a workaround exists.
- Trust-but-verify subagent "LIKELY-RESOLVED" verdicts that rest on
  file-existence/comment-claims; reproduce or source-check before closing.
- Prefer "keep open + re-scope the path reference" over "close as superseded"
  when the concern persists in the new location.
- See also [[state-certainty]], [[dig-deeper-before-parking]].
