---
name: reference-ticks-canonical-exit-trap
description: z88dk-ticks's canonical termination is the ED FE syscall trap (A=CMD_EXIT=0), not HALT. Pin this so Z80 test/bench harnesses use the same mechanism z88dk's own testsuite uses. Read before designing any new ticks-based harness, OR before "deriving" how to terminate a Z80 program from first principles.
metadata:
  type: reference
---

## Canonical exit mechanism

z88dk-ticks terminates a Z80 program cleanly via the undocumented `ED FE`
opcode with `A = CMD_EXIT = 0`.  The chain:

  - Z80 program: `ld a, 0; defb 0xED, 0xFE` (or just `xor a; .byte 0xED, 0xFE`)
  - ticks: `ticks.c:4793-4795` -> `PatchZ80()` -> dispatches on `A` -> `cmd_exit()`
  - `hook.c:39`: `printf("\nTicks: %llu\n", st); exit(L)`

ticks prints **Ticks: <cycles>** to stdout and exits with the **L register**
as the process exit code.  Both are reliable signals for a harness:

  - cycle count -> parse stdout `Ticks:` line
  - PASS/FAIL  -> load match status into L before the trap; ticks
    exit code IS that L value (Unix convention: 0=PASS, 1=FAIL)

z88dk's own testsuite uses this — `zcc +test`'s CRT
(`lib/target/test/classic/test_crt0.asm:100`) emits the trap when `main`
returns.  Our compiler-comparison-corpus uses it directly via inline asm
in `test_main.c` (works under both clang Z80 and zsdcc).

Full command table in `z88dk/src/ticks/cmds.h`.  Other `A` values dispatch
to console I/O, file I/O, IDE, time queries — same trap, different `A`.

## What HALT does NOT do

HALT (`0x76`) does NOT terminate ticks.  See `ticks.c:1039-1051`:
  - HALT sets `halted=1` and decrements `pc` (so PC stays pinned at the
    HALT instruction's address, re-executing every iteration)
  - The `halted` flag is only cleared by an interrupt firing (`:980`).
  - The cpu_run loop terminates only on `pc == end` or `st >= counter`
    (`:3093`).

HALT terminates ticks ONLY when the HALT instruction happens to be at
the address passed via `-end` (default `0x0000`).  This is fragile and
not the canonical mechanism.

## `-output` does NOT survive the trap

`-output <file>` (RAM dump) is invoked from `write_output()` in
`ticks_main.c:421`, AFTER `cpu_run()` returns normally.  The trap calls
`exit(L)` directly from `cmd_exit()` (`hook.c:43`), bypassing
`write_output()`.  No atexit registration covers it.

So a trap-exit harness CANNOT rely on a `${prefix}.ram` sentinel dump for
PASS/FAIL.  Move verification to the L-register exit code (set L before
the trap) and parse `Ticks: <N>` from stdout for cycles.

## Meta-lesson

Before deriving "how to terminate a Z80 program under ticks" or any
similar infrastructure question, grep the repos for how the project
already does it.  This rule was learned the slow way on 2026-06-08:
spent ~40 min reverse-engineering ticks's HALT semantics from
`ticks.c:1039` before realizing `z88dk/test/suites/make.config` and
`lib/target/test/classic/test_crt0.asm` already demonstrated the trap
pattern, in repos we have full access to.  See related
[[feedback_grep_repo_docs_before_deriving]] — same spirit, broader scope:
grep existing project harnesses + tests, not just `*_REFERENCE.md`.

## Harness adoption

`rc700-gensmedet/tasks/compiler-comparison-corpus/`:
  - `test_main.c` emits the trap inline (both clang and zsdcc); loads
    `_ticks_exit_code` into L first.
  - `sweep/reset_clang.s` `_done:` is the trap too (safety net if main
    returns).
  - `sweep.sh` no longer passes `-end` or `-output`; captures `Ticks:`
    via awk, uses ticks's process exit code for PASS/FAIL.
