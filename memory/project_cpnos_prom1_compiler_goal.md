---
name: CP/NOS → PROM 1 via compiler fixes (post-functional goal)
description: After CP/NOS is fully working, the next phase is fixing llvm-z80 codegen to shrink CP/NOS enough to fit in PROM 1 (2 KB)
type: project
originSessionId: b07ba379-19bf-4244-a50b-7118b0bab69d
---
Once CP/NOS is functionally complete, the planned next phase is to switch attention to the llvm-z80 backend and shrink CP/NOS until it fits in PROM 1 alone (2 KB / 2048 B).

**Why:** User stated 2026-04-25. The open issue backlog (#74–#80, plus future findings) is the lever — Tier 2/3 payload shrinks are blocked on compiler-side fixes, not on more C-level refactors. The work order is intentional: get CP/NOS *correct* first, then optimise it down via better codegen rather than C contortions.

**How to apply:**
- Until the user signals "CP/NOS works", keep prioritising correctness/integration of CP/NOS over code-density work in cpnos-rom.
- When the user says CP/NOS is done (or asks to start the compiler phase), pivot to fixing the open ravn/llvm-z80 issues — measure each fix's impact on the cpnos-rom payload size as the success metric, not just lit-test diff.
- Continue logging codegen issues with self-contained reproducers as they are spotted in cpnos-rom / autoload-in-c / rcbios-in-c — they're the inventory we'll work through later.
- Don't treat the 2 KB ceiling as binding *yet*; payload currently sits ~2047 B and there is still functional work pending. Premature C-side shrinking is worth less than the compiler-fix runway.
