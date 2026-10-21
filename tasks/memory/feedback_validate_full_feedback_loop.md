---
name: feedback_validate_full_feedback_loop
description: When iterating on a tool, verify the artifact under test is actually the one you just built; stale-tool is the mundane cause of "weird" results that look like real bugs
metadata:
  type: feedback
---

**Rule:** Before trusting any test result as evidence about a code change, verify there is a causal chain from the change to the artifact under test.

**Why:** Session 2026-10-21 (z88dk PR #90 workstream) lost ~30 minutes because `make -C src/zcc` built `src/zcc/zcc` but did NOT install to `bin/zcc` (which the test harness invoked). The stale `bin/zcc` reproduced old behavior; I misread this as "antigravity's bug report was wrong" and burned iterations on fprintf-debugging the wrong binary, stash/pop experiments, and head-scratching. Correct call was `make bin/zcc` at the workspace root — toplevel Makefile has a `bin/zcc: ...` rule that chains to `make -C src/zcc PREFIX=... install`. Finding this took 2 seconds of `grep "^bin/zcc" Makefile` AFTER the fact.

**How to apply:** When a test's output contradicts a prediction based on a code change — stop. FIRST check that the artifact being executed has an mtime later than the source edit (or hash matches), and that any "install"/"deploy"/"copy-to-bin" step has run.

Project-specific probes (prefer these over mtime where available):
- **z88dk tools**: `./bin/zcc 2>&1 | head -1` → `v<count>-<git-sha>-<date>`. If SHA matches the base of your branch rather than your HEAD, the install is stale. Caveat: `src/config.h` is NOT regenerated automatically on git state change (Makefile only generates it when absent); `rm src/config.h && make src/config.h` to refresh.
- **llvm-z80 tools**: `clang --version` prints the LLVM commit it was built from.

Common failure vectors:

- subdir-make without install (today's case)
- Docker image rebuilt but tag not re-pulled
- Hot-reload systems that silently cache stale modules
- Submodule or vendor directory not pin-updated
- Package manager that resolved from cache
- `.o` files that didn't rebuild because header mtime wasn't bumped

The underlying trap is pattern-matching on familiar shapes: "C program being built" triggers the "`cd subdir && make`" muscle memory before checking the project's actual build conventions. The grep for a canonical build target (`grep "^bin/<tool>" Makefile` or similar) costs 2 seconds; chasing a stale artifact costs minutes to hours and, worse, generates spurious hypotheses ("the bug report is wrong", "my fix is broken") that pollute subsequent reasoning.

Signature to react to: **"I changed X, why does the test still show old behavior?"** or **"this contradicts the earlier report."** → do NOT form a new hypothesis about the code; FIRST verify the artifact under test embodies the change.

Relation to [[fingerprint-build-after-two-no-change-edits]]: that rule triggers after 2 consecutive no-change edit cycles with a dedicated fingerprint probe. This rule triggers EARLIER — on the first observation that contradicts expectation, before forming any new hypothesis. The fingerprint rule is the late tripwire; this is the early gate. Both compose: react early (this rule); if you still can't tell whether bytes are running, graduate to a fingerprint (the other).

Related: [[feedback_file_bugs_not_fixes]] (verify-before-fix), [[feedback_verdict_after_real_pass_output]] (real output beats theorized output).
