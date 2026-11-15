---
name: Don't kill ninja mid-build — corrupts .ninja_log and .ninja_deps
description: HARD. SIGKILL on a running ninja truncates .ninja_deps / .ninja_log; next run emits "premature end of file; recovering" and rebuilds everything (1700+ steps). Stop with SIGINT/SIGTERM (Ctrl-C/kill -2/kill -15), and recover corrupted deps instantly with `ninja -t recompact`.
type: feedback
---

**HARD: never SIGKILL (`kill -9`) a running ninja process.**

**Why:**
Ninja incrementally updates its dependency log `.ninja_deps` and execution log `.ninja_log`. If terminated abruptly with `SIGKILL` (`kill -9`), the log record is truncated mid-write without closing headers. Subsequent invocations print:
`ninja: warning: premature end of file; recovering`
and Ninja discards cached header dependencies, conservatively triggering an unnecessary 1700+ step rebuild of LLVM.

Running TWO ninja processes against the **same build directory** simultaneously causes lock contention, stalls both processes at 0% CPU, and leads to truncation if killed.

**How to stop Ninja safely:**
1. **Graceful signals only:**
   - Ninja installs signal handlers for `SIGINT` (2) and `SIGTERM` (15).
   - Interrupt with **Ctrl-C once** or send `kill -2 <pid>` / `kill -15 <pid>`.
   - Ninja will stop child subprocesses, flush and close `.ninja_deps` and `.ninja_log` cleanly, and delete partially written target files.
   - Give it 2–3 seconds to exit. **NEVER use `kill -9` or `killall -9 ninja`.**

2. **Instant recovery with `ninja -t recompact`:**
   - If `ninja: warning: premature end of file; recovering` appears:
     ```bash
     ninja -C <build-dir> -t recompact
     ```
   - `ninja -t recompact` cleans up truncated entries and packs `.ninja_deps` in seconds, restoring clean incremental state without doing an unneeded full rebuild.
   - Do NOT delete `.ninja_deps` manually unless recompact fails.

3. **Incremental workflow discipline:**
   - Build only specific targets during development:
     ```bash
     ninja -C llvm-z80/build-macos-asserts llc
     ```
   - Run tests directly with `llvm-lit` rather than rebuilding the universe with `check-z80` (which triggers 4800+ targets):
     ```bash
     llvm-z80/build-macos-asserts/bin/llvm-lit -v llvm-z80/llvm/test/CodeGen/Z80/ix-allocatable-pointer.ll
     ```

4. **Background runs and progress:**
   - Log ninja output to `scratch/ninja-build.log` so the user can follow along.
   - Check `pgrep -f ninja` before starting a build to ensure no other ninja is running on the same build directory.
