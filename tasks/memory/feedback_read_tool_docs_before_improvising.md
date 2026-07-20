---
name: Read build-tool docs before improvising on their internal files
description: When a build tool (ninja, sccache, cmake) misbehaves, consult its documentation BEFORE experimenting on its internal state files. The ninja manual documents .ninja_log/.ninja_deps; guessing cost several full rebuilds on 2026-07-12.
metadata:
  type: feedback
---

**Before improvising a fix on a build tool's internal files, read its docs.**

**Why:** On 2026-07-12, chasing a persistent ninja `premature end of file;
recovering` (corrupt `.ninja_log`) I experimentally `rm`'d BOTH
`build-macos/.ninja_log` AND `.ninja_deps`.  The ninja manual
(ninja-build.org/manual.html) plainly documents that `.ninja_deps` is the
discovered-header **dependency database** — deleting it forces ninja to
re-discover every dependency, i.e. a FULL rebuild (3295 steps here) instead of
the cheap log-only reset I intended.  A one-minute doc read (or `man ninja`)
would have said "delete only `.ninja_log`."  The user asked, pointedly, whether
I could have found the behavior in the documentation.  Yes.

**Concrete ninja facts (from the manual, now known — no need to re-derive):**
- `.ninja_log` = the build log ("what was built when").  Truncated (killed
  ninja) -> `premature end of file; recovering` -> conservative near-full
  rebuild.  To reset safely: `rm .ninja_log` ONLY.
- `.ninja_deps` = the dependency database (discovered `#include`s).  Removing it
  forces full dependency re-discovery = full rebuild.  Do NOT delete it to fix a
  log problem.
- The `.o` files themselves stay valid; only the metadata DBs get corrupted.

**Also (not ninja-specific, basic shell — should have known up front):**
- `ninja … 2>&1 | tee log; echo done` returns the EXIT CODE OF `echo`, not
  ninja.  A failed build reads as "exit 0" to the harness.  Always
  `set -o pipefail` and capture `${PIPESTATUS[0]}` (tee'd into the log) to know
  the REAL ninja result; don't trust the background task's reported exit code
  when the command is a pipeline followed by another command.

**How to apply:** when a tool's internal state looks corrupt, `WebFetch` its
manual / `man` it BEFORE touching its files.  Relates to [[feedback_dont_kill_ninja]].
