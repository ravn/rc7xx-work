---
name: File issues in ravn/* forks when finding upstream project bugs
description: When debugging reveals a bug in a third-party project we depend on (llvm-z80, z80pack, cpnet-z80, mame, etc.), always file the issue against the ravn/* fork with reproduction info + test case
type: feedback
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
When work in `/Users/ravn/z80/` reveals a bug in a dependency project (clang/llvm-z80 codegen glitch, z80pack netwrkif issue, MAME driver model error, cpnet-z80 protocol oddity, etc.), file a GitHub issue in the **ravn/* fork** of that project, not in ours.  Stated 2026-04-22.

**Why:** The user maintains forks for everything we use.  Bugs in upstream tools flow through the fork.  Filing in the fork keeps our bug log with the code, makes PR workflow possible, and respects the "no upstream issues" rule.

**How to apply:**
- Target repo: `ravn/llvm-z80`, `ravn/z80pack`, `ravn/mame`, `ravn/cpnet-z80`, etc.  Not upstream (udo-munk/z80pack, mamedev/mame, …).
- Include:
  - Concise symptom description (what doesn't work).
  - Reproduction steps (exact commands, inputs, versions, commit SHA).
  - Expected vs observed behavior.
  - **A minimal test case** reduced from the real codebase — isolated source file(s) or patch that triggers the bug without all our surrounding code.
  - Evidence snippets (disassembly, logs, screenshots) showing the actual vs expected output.
- File the issue as soon as the bug is identified; don't wait until the work is complete.  The user may look at it, pick it up, or leave it queued.
- Link the issue from whatever rc700-gensmedet GitHub issue or task file the bug is blocking.
- If a fix exists in our local workaround, note it in the issue so it can become a PR if desired.
