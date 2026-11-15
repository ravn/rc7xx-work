---
name: project_ccache_single_config_2026-11-14
description: One shared ccache config scripts/ccache-z80.conf (30G provisional) used by every build; why the old setup produced 0 hits
metadata:
  type: project
---

**Config:** `scripts/ccache-z80.conf` (`max_size = 30G`, `compression`) is the ONLY ccache config. Selected via `CCACHE_CONFIGPATH` by `scripts/ccache-wrapper` (cmake launcher), root `Makefile` (exported), `scripts/build-progress.sh` (sourced by all `rebuild-*.sh`) and `scripts/verify-firmware.sh`. The old root `ccache.conf` is deleted: ccache reads a workspace `ccache.conf` as a *directory config* and rejects `max_size` there.

**TODO (user 2026-11-14):** 30G is provisional — investigate real usage across LLVM/MAME/z88dk/Open Watcom builds and adjust. Notes elsewhere say 50G; user's `~/Library/Preferences/ccache/ccache.conf` says 20G.

**Verified 2026-11-14:** on macOS the user config is `~/Library/Preferences/ccache/ccache.conf` (not `~/.config`). Inside the agent sandbox it is not readable, so a bare `ccache` there falls back to the 5 GiB default and trims the shared cache (seen: 5.5/5.0 GiB, 109.8 %, 152 cleanups). Always go through the wrapper / `CCACHE_CONFIGPATH`.

**Unexplained:** two full LLVM builds on `reimpl` (`build-macos`, `build-macos-asserts`, ~25 min each) had 0 new ccache hits (hits stuck at 30455). Suspected: cache trimmed to 5 GB by config-less runs and/or cache-key change from `CCACHE_BASEDIR`; NOT confirmed. Re-measure after the shared config is in use.

**Not changed:** `build-macos` cmake cache still has bare `ccache` as launcher (works only with `CCACHE_CONFIGPATH` exported); `z88dk/Makefile` wraps `ccache $(CC)` itself (inherits the env var). The root `Makefile` hardcodes a CLion `NINJA`/`CMAKE` path that does not exist on this Mac (ninja/cmake are in `~/.local/bin`; pass `NINJA=... CMAKE=...`).
