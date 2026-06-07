---
name: docker-shim-batch
description: When a build invokes many small Docker-wrapped commands (sdasz80 / sdar / avr-gcc / simavr / etc.) collapse them into ONE `docker run sh -c "…"` per logical step — each container startup is ~150-500 ms
type: feedback
---
**User directive 2026-06-07: Docker invocations may be expensive for small programs; consider batching.**

**Why:** Container startup is ~150–500 ms on macOS arm64.  At ~150 source files (Z80Runtime) or many compile-link-run steps, the cost dominates wall-clock and burns I/O.  Even shims that LOOK fast (the wrapper script is trivial) pay the full docker-runtime tax per call.

**How to apply:**
- Per-file shims like `~/.local/bin/{sdasz80,sdar,sdldz80,makebin}` and `~/.local/bin/{avr-gcc,avr-ld,avr-objcopy,simavr}` are correct for INTERACTIVE one-offs (`sdasz80 -V`) and cmake's `find_program` probes.  Don't remove them.
- For BUILD-DRIVEN multi-step pipelines, write the multi-step shell inside ONE `docker run --rm sh -c 'cmd1 && cmd2 && cmd3'` invocation per Makefile target.  Pattern: see `rc700-gensmedet/tasks/aes256-corpus/avr-oracle/Makefile` — link + simavr-run batched, ~0.54 s wall vs ~1.5 s with two separate invocations.
- For ITERATIVE builds (Z80Runtime, sweeps): if rebuild cost becomes painful, switch to a long-lived container (`docker run -d --name z80-build avr-tools sleep infinity` + `docker exec`).  Don't pre-emptively do this — only when measuring.
- Always mount `/Users/ravn/z80:/Users/ravn/z80` (same absolute path) — cmake-generated and Makefile-generated paths use absolute paths and need to resolve inside the container.
- Per-file shims that ONLY run inside cmake (one config-time invocation each) are fine — they get called maybe 5 times total at configure.

Cross-listed with [[feedback_docker_binaries.md]] (use Docker over native install) — that rule still stands; this one is about HOW to wire the Docker calls efficiently.
