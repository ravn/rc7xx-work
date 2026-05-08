---
name: Docker trace disk danger
description: z88dk-ticks -trace generates GB of output, must always pipe through tail inside Docker
type: feedback
---

NEVER use z88dk-ticks `-trace` without piping through `tail` inside the Docker container. The trace generates one line per Z80 instruction — millions for programs using runtime library calls (div, mul, crc32). This filled the disk to 90GB in Docker.raw.

**Why:** Multiple incidents where compare.py and test scripts used `-trace` with full capture, filling the disk and hanging Docker Desktop. Required computer restarts to recover.

**How to apply:** Any z88dk-ticks invocation with `-trace` must use a shell pipeline: `sh -c "z88dk-ticks -mz80 -trace -end 0xADDR file.bin 2>&1 | tail -20"`. Never capture full trace output via subprocess or shell variable.
