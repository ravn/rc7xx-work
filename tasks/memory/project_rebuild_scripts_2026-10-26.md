---
name: project_rebuild_scripts_2026-10-26
description: Root rebuild-*.sh scripts (mame, llvmz80, z88dk, open-watcom) with ccache + progress; gotchas found, and the exact pending state at the 2026-10-27 reboot
metadata:
  type: project
---

**Scripts (workspace root, committed + pushed; last commit 8638ac9, 2026-10-27):**
`rebuild-mame.sh` (release `mame/regnecentralen` + debug `mame/regnecentralend`; `--release/--debug/--regenie/--clean/--stats`),
`rebuild-llvmz80.sh` (build-linux, default TOOLS list as `make toolchain`; `--reconfigure/--clean/--stats`),
`rebuild-z88dk.sh` (`--clean` => `make clean` then `all libs`),
`rebuild-open-watcom.sh` (default target `rel`; `--clean` = OW clean.sh; no -j knob, serial builder).
Shared helper `scripts/build-progress.sh`: refuses to start if ninja/make/wmake/builder runs, live progress line, status file `scratch/tmp/<log>.progress` (`watch -n2 cat ...`), Ctrl-C forwarded as SIGINT. Logs in `scratch/tmp/*.log`.

**ccache:** limit raised to 50 GB (`ccache -M 50G`, lives in ~/.config/ccache, not in repo). Scripts set `CCACHE_BASEDIR` per project, so the first build after adopting them is all misses (LLVM: 64 min, 0 hits; later `--clean` rebuild: 78 s, 3534 steps, 100% hits). MAME `--clean` release rebuild: 71 s from cache.

**Gotchas found (verified this session):**
- MAME: objects from the old PCH-era build were NOT rebuilt after the Oct 25 mame checkout (stale `.d`, my hypothesis) -> link error `undefined device_state_entry::formatstr(char const*)` with BOTH ld.lld and GNU ld. Fix = delete objects older than the checkout / `--clean`. Use `--clean` after any mame submodule update. lld was wrongly blamed first; whether lld works for MAME is untested (script uses default ld).
- MAME `LDOPTS`/`OVERRIDE_CC` are baked into generated gmake files: changing them needs `--regenie`.
- z88dk: `make clean` deletes `lib/clibs/*.lib` (361 files) and `make all` does NOT rebuild them (needs `libs`). Builds need `z88dk/bin` on PATH + `ZCCCFG=$Z88DK/lib/config/` (set_environment.sh), else `z88dk-z80asm: not found` rc127 (this killed the first clean attempt). The PATH fix is in the script but NOT yet re-verified.
- Open Watcom: a clean `rel` build is ~47 min, 3333 builder dir markers (progress denominator). Its host-gcc compiles DO go through the ccache shim (first clean build: 3756 misses / 48 hits) - my earlier "ccache barely applies" was wrong, based on incremental runs.

**State at reboot (2026-10-27):**
- Submodules updated to the macbook's bump: llvm-z80 = 35d80b2f59, z88dk = a561d15208. The LLVM toolchain and z88dk binaries were built from the OLD sources -> stale. Next: `./rebuild-llvmz80.sh`, then `./rebuild-z88dk.sh --clean`.
- MAME debug clean build was interrupted (~3519 steps): `mame/regnecentralend` may be incomplete -> `./rebuild-mame.sh --debug`. New binaries never smoke-booted (use Makefile targets / mame_capture.sh only).
- z88dk repo has branch `backup/pre-submodule-update-20261027` pinning old commit 58d636e4b2 (otherwise unreferenced). Lib backup: `scratch/tmp/z88dk-lib-backup` (gitignored).
- Pending offer: second `rebuild-open-watcom.sh --clean --stats` to demonstrate ccache hits.

**Why:** user asked for optimized, progress-showing rebuild scripts for all four trees. **How to apply:** use these scripts instead of ad-hoc make/ninja; see [[feedback_builds_optimized_with_progress]], [[feedback_ccache_llvm_build]], [[feedback_never_concurrent_or_kill_builds]].
