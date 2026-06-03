---
name: MAME Lua errors are fatal — fix them first, don't proceed
description: Any `[LUA ERROR]` line in a MAME run output invalidates the harness's reported result. Stop, fix the lua, re-run. Never reason about codegen / disks / MAME / boot behavior from a run with lua errors.
metadata:
  type: feedback
---

When a MAME run produces ANY `[LUA ERROR]` line, **treat the harness output as
unreliable and stop drawing conclusions from it until the lua is fixed**. Lua
errors silently swallow the rest of the script's side effects — file writes,
exits, screen reads, taps — so the harness's "PASS"/"FAIL"/"timeout"/dump can
be arbitrarily wrong.

**Triage order on a MAME run that reports a problem:**
  1. `grep -c 'LUA ERROR' <mame log>` — if non-zero, **fix the lua first**.
  2. Re-run, confirm 0 lua errors.
  3. *Then* interpret the harness result.

**Why:** burned ~a session (2026-06-03) chasing a non-existent codegen
regression (filed ravn/llvm-z80#215, closed same day) because
`mame_boot_test.lua` was throwing ~20 `[LUA ERROR] in execute_function: stack
index 2, expected string, received no value` per run from a `screen:snapshot()`
call whose signature changed in newer MAME (now needs a filename string).  The
errors were visible in every run's stderr, ignored for hours, while the test
kept reporting "FAIL: timeout — no A>" — for a boot that was actually reaching
`A>` in under 5s.  The misreport then poisoned downstream conclusions about
codegen, disk compatibility, and MAME branches, none of which were the issue.

**How to apply:**
- Treat `LUA ERROR` like a compiler error: a precondition for trusting the run,
  not a cosmetic warning.
- Wrap optional API calls in `pcall` so a future signature drift errors *once*
  and is caught, instead of silently corrupting state.
- If a working harness exists nearby (e.g. `rcbios-in-c/mame_disk_test.lua`),
  copy its pattern when fixing — it's a known-good reference.
- Related: [[feedback_lua_no_port_reads]], [[feedback_display_addr_from_dma]],
  [[feedback_verify_pass_condition]] (a green test must justify itself).
