---
name: Never run concurrent builds, never kill a running build
description: HARD — one MAME/ninja/make build at a time; never start a second while one runs (same obj dir races/corrupts); never pkill/kill a build (deletes partial .o -> forces full rebuild next time). Wait for it to finish or fail on its own.
metadata:
  type: feedback
---
**HARD RULE (2026-07-31): exactly one build process at a time, and never kill one.**

Two prohibitions:

1. **Never start a second build while one is already running.** MAME/ninja/make
   builds share the same `obj/` output directory; two concurrent instances race
   on the same object files and can corrupt the build. Before starting a build,
   confirm none is already running.

2. **Never `pkill`/`kill` a running build.** Terminating make/ninja deletes the
   partial `.o` files it was writing (make cleans partial outputs on SIGTERM) and
   interrupts the dependency state, which forces a **full rebuild** next time --
   very expensive. Let a build finish or fail on its own.

**Why:** reported 2026-07-31 during the rc702 review-fix work. I started a second
`make SUBTARGET=mame SOURCES=...` while the first (which had errored on a compile
bug but whose `-j` jobs were still finishing) was still alive, so two makes ran
against the same obj dir. Then I `pkill`ed both to clean up -- which deleted
in-flight `.o` files (emumem, luaengine, upd765, ...) and set up a costly full
recompile.

**How to apply:**
- Run builds in the background (`nohup ... &` or Bash `run_in_background`) and
  watch via Monitor; do NOT launch another build until the current one exits.
- If a build is compiling the wrong thing or you changed a file, WAIT for it to
  finish (incremental rebuilds are cheap once objects exist), then start a fresh
  one -- do not kill the in-flight one.
- If you truly must stop (e.g. wrong branch), accept that the next build will be
  a full rebuild; but default is: let it run to completion.
