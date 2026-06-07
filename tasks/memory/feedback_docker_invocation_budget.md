---
name: docker-invocation-budget
description: All platforms — wherever Docker is used (macbook SDCC/AVR shims, any host's llvm-z80-build image, future containers), track invocation count per recurring workflow; alert when any one routinely exceeds ~100 calls (~30 s of container startup tax)
type: feedback
---
**Scope: all platforms wherever we invoke Docker.**  Sonnyboy (Linux) has the SDCC/AVR tools natively, so it rarely hits this rule — but if a workflow there starts going through Docker (e.g. the `llvm-z80-build` reproducibility image, future MAME-capture containers, anything cross-platform), the tally + threshold apply equally.  Where the tools are native (PATH-resolved binaries, no `docker run`), no tracking needed.

**User directive 2026-06-07 (reaffirmed twice): stay with Docker for now; keep track of invocation counts on EVERY host where Docker is used and report when "too much".**

**Why:** Docker startup is ~150–500 ms per `docker run` on macOS arm64.  Per-call this is invisible; in aggregate it's the dominant wall-clock cost for many recurring workflows.  The user wants to defer the native-build / patch effort (libelf install or simavr `--console-register` patch) until it's actually warranted by measured pain.

**How to apply:**
- Maintain a rough tally of Docker invocations per recurring workflow.  Update the "Current invocation budget" section below as the project evolves.
- **Soft threshold:** ~100 invocations per routine action ≈ 15–30 s of container startup tax.  At that point, mention it to the user and propose a fix (long-lived `docker exec` container, deeper batching, or native-build).
- **Hard threshold:** anything > 500 invocations in a routine pipeline.  Flag urgently regardless of wall-clock — that's a structural problem (per-file fan-out instead of per-step), and the fix is reorganizing the pipeline, not throwing hardware at it.
- Cross-listed [[feedback_docker_shim_batch]] (HARD: collapse multi-step shell into one `docker run sh -c "…"` per Make target).

## Current invocation budget (refresh as it changes)

| Workflow | Docker calls per run | Notes |
|---|---|---|
| `make run` in `aes256-corpus/avr-oracle/` | 1 | batched: link + simavr-run in one `docker run sh -c` |
| `cargo run -- llc <pattern>` (test-runner llc) | ~4 per test × opt-levels | sdasz80 + sdldz80 + makebin per (test, opt); spawns one per shim call.  Full llc suite (26 tests × 6 opts) = ~625 — FLAG-WORTHY if we routinely run it.  Currently only `wide_copy_overlap` is invoked, ~8 calls. |
| `ninja Z80Runtime` (Z80 runtime archive) | ~150 (one per .asm) | One-time per cmake reconfigure; tolerable.  Each call ~0.3 s; ~45 s total — visible but not painful. |
| `cargo run -- clang` (full clang suite) | 0 | Doesn't go through Docker — uses native z88dk-ticks at `/Users/ravn/z80/z88dk/bin/`. |
| AES Z80 13-config sweep | 0 | Native zcc + clang.  No Docker. |

## When to escalate

If we add a workflow that routinely takes the llc suite over the threshold, or if Z80Runtime starts getting rebuilt every session, propose **either** (a) a long-lived `docker run -d --name z80-tools sdcc-tools sleep infinity` + `docker exec` per call (~5 ms exec vs ~300 ms run startup), **or** (b) the simavr `--console-register` patch + libelf install for native-only AVR work.  Do not just keep paying the tax silently.
