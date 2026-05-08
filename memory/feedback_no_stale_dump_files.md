---
name: No stale dump files
description: HARD RULE — always rm dump/log files before re-running the producer; never read a /tmp/* artifact without confirming the producer wrote it this iteration
type: feedback
originSessionId: de6f9865-d9ee-4776-abd2-c579088d6b91
---
HARD RULE: when reading a dump or log file produced by a previous run
(`/tmp/sdcc_ram_dump.bin`, `/tmp/cpnos_boot_result.txt`, MAME screenshots,
captured serial logs, etc.), ALWAYS verify the file is from the current
iteration before drawing conclusions from it.  Either:

- `rm -f /tmp/foo` immediately before the producer command, OR
- write to a fresh, iteration-unique path (`/tmp/foo.$(date +%s)`), OR
- check `mtime`/`ls -la` against the producer's start time.

**Why:** session 47 (2026-05-07) — I read `/tmp/sdcc_ram_dump.bin` and
concluded the SDCC relocator's chunk-A LDIR was broken (RAM 0xEE00 = 0xFF
when PROM had real bytes), spent ~30 min debugging a non-existent codegen
bug.  The dump file was from the build BEFORE my SP fix landed; the
current build was actually copying chunks correctly.  A stale file is
indistinguishable from a fresh one without an explicit check, and the
wrong conclusion drives wasted investigation deeper into the wrong layer.

**How to apply:** in any debug loop that involves a long-running tool
(MAME, z80pack, captured ISRs, etc.) emitting files to a known path,
the first command in the iteration must remove the artifact -- not the
last command, not "before the next iteration", THIS iteration's first
step.  Treat every read of a `/tmp/*` artifact like a read from a cache
that may not have been invalidated.
