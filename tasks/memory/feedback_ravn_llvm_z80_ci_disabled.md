---
name: ravn-llvm-z80-ci-disabled
description: GitHub Actions are intentionally OFF on ravn/llvm-z80 — local oracle is the merge gate; do not "fix" the CI silence by re-enabling without user direction
type: feedback
---
**User directive 2026-06-07: GitHub Actions are intentionally disabled on `ravn/llvm-z80`.**

**Why:** Stuck processes (hung lit tests, never-terminating runtime fixtures) could run very long and burn GHA runner minutes.  The disable is a budget protection, not an oversight or a stuck migration.  Verified the same day via `gh api repos/ravn/llvm-z80/actions/permissions` → `{"enabled":false}`.  The Z80 backend CI workflow (`.github/workflows/z80-ci.yml`) still defines `build-and-lit` + `runtime-tests` and its workflow object reports `state=active` — irrelevant when the repo-level toggle is off.

**How to apply:**
- Never expect CI to run on push / merge to `ravn/llvm-z80` main.  The LOCAL oracle (lit + test-runner clang + AES 13-config + production byte-compare + llc test_27 via the macbook Docker SDCC shim) is THE merge gate.  The CLAUDE.md "Keep GitHub Actions green" rule is therefore inert on this repo until Actions are re-enabled.
- A `workflow_dispatch` invocation will queue forever (status `queued`, no runner).  Don't watch it.  Also: cancelling such a stuck run via API returns HTTP 500 (confirmed on run 27100367803).  Just ignore.
- Do NOT re-enable Actions without explicit per-session user direction.  If the user asks for cloud verification, the exact toggle is: `gh api -X PUT repos/ravn/llvm-z80/actions/permissions -f enabled=true -f allowed_actions=all`.  Re-disable after the run.
- Local-oracle merge commits should include the oracle results in the commit message (lit count, test-runner totals, AES/production diff status) so the gate trail is visible in `git log` — the lit/runtime CI badge that would normally encode this is absent.
- Cross-listed with [[feedback_no_commit_first_version]] (value oracle required) and [[feedback_value_oracle_all_transport_cells]] (all linking cells covered) — both still apply; the loss of CI just raises the bar on the local oracle.

Different from `llvm-z80/llvm-z80` (the fork-of-record at @zlfn) — that one's CI policy is independent and not covered here.
