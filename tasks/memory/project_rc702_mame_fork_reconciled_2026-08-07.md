---
name: project_rc702_mame_fork_reconciled_2026-08-07
description: ravn/mame fork brought up to date with upstream after PR #15805 merged — how, and the SDL2/SOURCES build facts that came out of it
metadata:
  type: project
---

After mamedev/mame PR #15805 merged ([[project_rc702_mame_upstream_pr]]), the
ravn/mame fork `master` was reconciled to the post-merge `upstream/master`
(2026-08-07). Method: `git reset --hard upstream/master` + rebuild the fork-only
layer as **5 small targeted commits** instead of replaying ~60 dev commits.

Commits on top of `upstream/master` (origin head `d2b090f`):
1. luaengine_mem `invoke()` not `invoke_direct()` (tap-crash fix) — upstream-ready
2. z80pio `check_interrupts` port-N.ius fix (`ius_above` scan) — upstream-ready
3. z80pio `set_mode(MODE_OUTPUT)` set `m_mode` before output callback — upstream-ready
4. cpnet_bridge PIO-port card, relocated to `src/mame/regnecentralen/pio_port/` — fork-only
5. README restored + build command updated — fork-only doc

The three z80pio/luaengine fixes were deliberately committed WITHOUT the fork's
µs-timestamp `LOG` layer so they are clean upstream candidates (the old dev
commits mixed the two). µs-logging can be re-lifted from the backup branch if a
debug session needs it.

Old dev master preserved as branch **`master-predev-2026-08-07`** (= `9d08457`),
pushed to origin. `master` was force-pushed (`--force-with-lease`).

**Build facts discovered (macbook), now the durable how-to:**
- Upstream changed the **macOS default OSD to `sdl3`**; only SDL2 is installed
  here (`/Library/Frameworks/SDL2.framework`) and "no brew". So MAME must be
  built with **`OSD=sdl`** (SDL2). Without it: `'SDL3/SDL.h' file not found`.
- pio_port is now **driver-local**, so `SOURCES=` must list the pio_port files
  explicitly (comma-separated, no spaces), not just rc702.cpp — else link fails
  with undefined `RC702_PIO_PORT`/keyboard/cpnet symbols. Verified command:
  ```
  make SUBTARGET=regnecentralen \
    SOURCES=src/mame/regnecentralen/rc702.cpp,src/mame/regnecentralen/pio_port/pio_port.cpp,src/mame/regnecentralen/pio_port/keyboard.cpp,src/mame/regnecentralen/pio_port/cpnet_bridge.cpp \
    OSD=sdl REGENIE=1 -j10
  ```
  (add `DEBUG=1 SYMBOLS=1 SYMLEVEL=3 TOOLS=1` for the `regnecentralend` debug binary.)
- The `SUBTARGET=x SOURCES=...` path is self-contained: it generates a correctly
  filtered drivlist and needs **no** `scripts/target/mame/x.lua` / `x.lst`. The
  fork's old `regnecentralen.lua` was vestigial and is now broken on the new base
  (no `.lst` filter → full mame.lst drivlist → `_driver_zzyzzyxx2` link error; and
  a hand-curated `.lua` also drags in undependent optional devices like sun_kbd).
  Dropped it — use SOURCES=.
- Verification bar met: build exit 0, `-validate rc702` exit 0, `-listslots`
  shows `piob -> cpnet_bridge`. Full end-to-end `cpnos-polypascal-test` (needs
  MP/M + NDOS orchestration, [[project_cpnos_mame_prereqs]]) not re-run this session.

Gotcha re-learned twice this session: `git checkout <rev> -- <path>` **stages**
the file, so a later `git commit` (which commits ALL staged) silently sweeps it
into an unrelated commit. Use explicit per-file `git add` AND a clean index
(`git reset --mixed`) when building targeted commits.
