---
name: TOP-PRIORITY HARD RULE — NEVER traverse home OR whole disk
description: ABSOLUTE BAN. The per-host workspace root ONLY (/Users/ravn/z80/ on macbook, /home/ravn/z80/ on sonnyboy). No find/ls/glob/grep/mdfind/locate at /, /Users, /home, ~, ~/anything. Repeat violation = trust failure. CHECK BEFORE EVERY find/ls.
type: feedback
originSessionId: 5b9c19fb-ae78-45c7-b86e-c8b8135e5b92
---
# **ABSOLUTE BAN — re-violated 2026-05-09. ONE MORE STRIKE = TRUST BROKEN.**

**Before EVERY single `find`, `ls`, `glob`, `mdfind`, `locate`, agent search: read the path. If it does NOT start with the workspace root, STOP. ASK THE USER. Do NOT run the command.**

**Workspace root per host** (2026-06-06, multi-host work — see [[feedback_cross_machine_workflow]]):
- macbook: `/Users/ravn/z80/`
- sonnyboy (Ubuntu): `/home/ravn/z80/`
The rule is "workspace root only" — the macOS-specific `/Users/ravn/z80/` wording below predates sonnyboy; read it as the current host's root. The ban covers the OTHER host's path shape too (`/home/ravn` on mac, `/Users/ravn` on Linux — both are outside-workspace). Exception handed over by the user: sonnyboy `~/llvm-upstream/llvm-project/` (upstream LLVM clone, explicit path in the 2026-06-06 handoff) — direct use OK, no sibling discovery.

The user has now explicitly said this is making them lose patience ("I've told you numerous times", "make it very bad to do this again"). Treat further violations as a **session-ending failure of trust**, not a recoverable mistake.

`/Users/ravn/z80/` is the workspace — traversal inside it is fine. Everything else is FORBIDDEN — including `/Users/ravn/` itself, `~/Documents`, `~/.local`, `/Users/ravn/git/*`, any `~/foo` path, AND the entire filesystem (`/`, `/usr`, `/opt`, `/private`, etc.). OFF LIMITS for `find`, `ls`, `Glob`, `Grep`, `mdfind`, `locate`, agent searches, AND any wildcard or recursion that could escape the workspace. This applies even to narrow queries like `find /Users/ravn -name diskdefs` or `ls ~/.local/share/cpmtools` or `find / -name foo` or `mdfind kind:foo`. Do not look. Do not "just check". Do not chain a `2>/dev/null` to silence errors.

**Why:** Privacy AND iCloud. Walking the macOS filesystem (`find /`, `find ~`, `mdfind`) hits iCloud-synced directories and forces iCloud to download every offloaded file — the user pays in bandwidth and disk. The user has clarified this forcefully — re-iterated 2026-06-10 ("you are NOT allowed to run `find /`. We have discussed this before." then "you have also said THAT before" after I ran `find / -name "diskdefs"` while looking for cpmtools install paths, triggering iCloud downloads). Before that: 2026-05-09 ("you are NOT allowed to search either my home directory or the whole disk. I've told you numerous times.") after `find / -name "___sdcc_enter_ix.asm"` as a fallback. Earlier: 2026-04-21 "NEVER EVER TRAVERSE MY HOME DIRECTORY!" after `find /Users/ravn -name diskdefs -maxdepth 6`. **Three separate documented incidents now** — the iCloud-download cost is real and persistent.

**Fallback escalation is NOT a loophole.** When a primary path inside `/Users/ravn/z80/` returns nothing, do NOT widen the search to `find /`, `find /Users`, `mdfind`, `locate`, or anything that walks outside the workspace. Stop and ask the user where the file lives. A failed lookup means "ask", not "search wider".

**How to apply:**
- Inside-workspace is fine: `ls /Users/ravn/z80/...`, `Grep path=/Users/ravn/z80/...`, `find /Users/ravn/z80/...`.
- Outside-workspace is never: no `find ~`, no `find /Users/ravn`, no `ls /Users/ravn/Downloads`, no `ls ~/.local`, no `grep -r /Users/ravn/git`, no wildcards anywhere above `/Users/ravn/z80/`.
- Specific files outside the workspace may be read directly **only** when the user has handed you the exact path — `Read /Users/ravn/Downloads/mpm-net-1.2.tgz` is OK if the user referred to it, but `ls /Users/ravn/Downloads/` to go discover siblings is not.
- Instead of searching for external tools/configs: ask the user where they live, or invoke the tool with `--help` / `man` / env var inspection (`echo $PATH`) to get info without walking the filesystem.
- Spawned agents must inherit this rule — forbid home-dir traversal in the prompt.

**Paths the user has explicitly handed over (past):** `/Users/ravn/git/z80pack` (now superseded — submodule at `z80pack/` in the repo); `/Users/ravn/Downloads/mpm-net-1.2.tgz` and unpacked dir; `/Users/ravn/git/mame/src/mame/regnecentralen/`. Others require fresh permission.
