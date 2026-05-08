---
name: Timeout commands on macOS
description: How to bound the runtime of a shell command on macOS without GNU coreutils
type: reference
---

macOS does **not** ship GNU `timeout` (no `coreutils`). Linux scripts that use `timeout 30 some_command` will fail with `command not found`.

**Project policy: no brew**, so do not suggest `brew install coreutils`.

**Best option (when running via Claude Code):** use the `timeout` parameter on the Bash tool itself instead of trying to wrap commands with a shell-level timeout. The Bash tool accepts `timeout` in milliseconds (max 600000ms / 10min). This is the cleanest solution because it's enforced by the harness, not the script.

**For shell scripts that must be portable:**

1. **`perl -e 'alarm shift; exec @ARGV' SECONDS cmd args...`** — perl is always present on macOS, exec'ing the target command lets it inherit stdin/stdout cleanly. Most portable, smallest dependency.

2. **Background + sleep + kill:**
   ```sh
   ( cmd args ) & pid=$!
   ( sleep 30 && kill -TERM $pid 2>/dev/null ) & watcher=$!
   wait $pid; rc=$?
   kill $watcher 2>/dev/null
   ```
   Verbose but pure POSIX. Use when perl isn't appropriate.

3. **`gtimeout`** — only available if user installed coreutils via brew, which is forbidden by project policy. Don't rely on it.

**Anti-patterns to avoid:**
- `timeout SECONDS cmd` — fails on stock macOS
- `brew install coreutils` — violates no-brew rule
- Writing a Python wrapper just for timeout — overkill, perl one-liner is shorter

**Why this matters:** when a Z80 emulator run hangs (e.g. infinite loop in compiled benchmark), an unbounded `z88dk-ticks` call will block the entire investigation. Always bound emulator runs.
