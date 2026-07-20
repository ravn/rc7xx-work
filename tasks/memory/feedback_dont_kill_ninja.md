---
name: Don't kill ninja mid-build — corrupts .ninja_log
description: HARD. SIGTERM/SIGKILL on a running ninja truncates .ninja_log; the next ninja invocation emits "premature end of file; recovering" and conservatively rebuilds everything (1700+ steps for a single-file edit in llvm-z80). Wait builds out; if you must abort, prefer Ctrl-C once and let ninja exit cleanly.
type: feedback
---

**HARD: never SIGTERM/SIGKILL a running ninja process.**

**Why:** ninja's `.ninja_log` records "what was built when" across runs.
ninja writes it incrementally and not atomically — if killed mid-write,
the log is truncated and the next ninja run prints
`ninja: warning: premature end of file; recovering`.  Once recovered,
ninja has lost knowledge of which `.o` files are up-to-date and which
aren't, so it conservatively schedules a near-full rebuild.  On
llvm-z80 today this expanded a 3-step single-file edit
(`Z80CallLowering.cpp` only) into a 1773-step cascade — about 8 minutes
of rebuild on M1 vs the ~10 seconds the edit would normally take.

The cascade is bounded by tablegen and linkage: stale libraries trigger
`llvm-tblgen` re-link, which forces `Z80Gen*.inc` regeneration, which
forces every Z80 `.cpp.o` to rebuild, then `libLLVMZ80CodeGen.a`
re-link, then `llc` re-link.  Once that runs to completion the state
is clean again.

A secondary failure mode: running TWO ninja processes against the **same
build directory** (`build-macos/`) at the same time.  They contend on the
log file's lock; both ninjas stall in `S` state with 0% CPU; killing
either one causes the truncation symptom above.

**But separate build directories are FINE to run concurrently** (user
clarification 2026-07-12): `ninja -C build-macos` and
`ninja -C build-macos-asserts` at the same time is safe — each dir has its
OWN `.ninja_log`/`.ninja_deps`, so there is no lock contention, and the
only shared state is sccache, which is built for concurrent clients. Use
this to parallelize a Release + an asserts rebuild after a backend edit.
The rule is strictly: never two ninjas on the SAME dir, never SIGKILL any
ninja.

**How to apply:**

1. Don't start a second ninja invocation while one is already running
   in the same build directory.  Wait for the first to finish, then
   start the next.

2. If a build is taking too long and you really need to interrupt:
   - Use **Ctrl-C exactly once** in the terminal.  ninja catches
     SIGINT, finishes the currently-running compile jobs, writes its
     log atomically, and exits cleanly.
   - Don't `kill <pid>` or Ctrl-C twice.  Either truncates the log.

3. If you've already killed ninja and see `premature end of file;
   recovering`: either let the conservative rebuild finish, or
   `rm build-macos/.ninja_log build-macos/.ninja_deps` and re-run
   ninja.  With no log, ninja falls back to pure file-mtime
   comparisons, which works correctly for the common cases.  Don't
   `rm` the build directory entirely — the .o files are still valid;
   only the dependency DB is corrupted.

4. The harness's `run_in_background: true` for ninja invocations is
   fine — the background process is not killed unless YOU send a kill.
   Do NOT poll it with `kill -0 $(pgrep ninja)` / signal-based existence
   probes either — `kill -0` sends no signal but it reads as "killing
   ninja" and alarms the user; just wait for the harness completion
   notification (or `tail` the log file), never `pgrep|kill`.

5. **Log ninja output to a stable, followable path so the user can watch
   progress** (user directive 2026-07-12).  Background ninja lands in an
   opaque `/private/tmp/claude-.../tasks/<id>.output`; symlink or tee it
   to `scratch/ninja-build.log` (e.g. run `ninja … 2>&1 | tee
   scratch/ninja-build.log`, or `ln -sf <bg-output> scratch/ninja-build.log`)
   and tell the user that path so they can `tail -f` it live.

**Reinforced 2026-07-12** (second reminder): the user restated both the
never-kill rule AND the "don't run multiple ninjas" rule, plus added the
progress-logging directive above.  Read this file BEFORE launching any
ninja build.

This rule emerged from session 58 (2026-05-11) implementing
ravn/llvm-z80#131.  I killed three ninja processes that were running
concurrently against the same build-macos/ directory (one from
cmake --build, one from a parallel ninja llc, plus a third I started
to "speed things up").  Result: ~25 minutes of rebuild time waiting
for the cascade to clear, vs ~10 seconds for the actual single-file
edit.
