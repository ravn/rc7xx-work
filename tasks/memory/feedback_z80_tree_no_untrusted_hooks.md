---
name: /Users/ravn/z80/ tree has no untrusted hooks
description: User has confirmed the z80 workspace tree contains no untrusted git hooks; cd + git compounds are safe there
type: feedback
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
Inside `/Users/ravn/z80/` and any subdirectory, no untrusted git hooks exist. `cd /Users/ravn/z80/... && git <cmd>` chains are safe to run; do not hedge or warn the user about hook execution risk for paths under this root.

**Why:** User stated explicitly on 2026-04-25 after a permission-prompt mentioned hook risk. They own the entire tree and vet what lives there. Hedging on every `cd … && git …` invocation is noise.

**How to apply:** When the working directory is somewhere under `/Users/ravn/z80/` and a git operation is most cleanly expressed as `cd <subdir> && git <cmd>`, just run it — no caveat in user-facing text. This does NOT generalise: paths outside `/Users/ravn/z80/` (other projects, home dir, /tmp clones, etc.) still warrant the default caution.
