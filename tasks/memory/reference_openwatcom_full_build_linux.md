---
name: reference_openwatcom_full_build_linux
description: Result and log-size baseline for running the FULL (non-bootstrap) Open Watcom build on Linux (sonnyboy) via ./build.sh, including the CP/M-86 clib — companion to reference_cpm86_toolchain_linux_build.md (bootstrap-only).
metadata:
  type: reference
---

**Run 2026-08-18 on sonnyboy**, submodule `open-watcom-v2` at `21bf032`
(post-merge of local SS/DS crt0 fix + upstream CP/M-86 clib expansion).

## Command

```bash
cd open-watcom-v2
rm -f build-full.log
nohup ./build.sh > build-full.log 2>&1 &
```

`setvars.sh` defaults apply: `OWTOOLS=GCC`, `OWDOCBUILD=0`, `OWOBJDIR=binbuild`
(reused from the prior boot-only run). No env overrides needed beyond that —
`./build.sh` with no arg runs preboot -> `builder boot` -> `builder build`
(full self-hosted second pass) in one shot.

## Timing / log size (for pacing future runs)

- Start 00:46:46, failure 01:27:5x -> **~41 minutes** to the point of failure
  (compiler+linker+clib stages all complete well before that; only the
  Windows/OS2 doc/browser tail remained).
- Final `build-full.log`: **127522 lines / 2.3 MB**.
- Builder's own `build/binbuild/build.log` (near-duplicate, written directly
  by the `builder` tool, not via shell redirection): **127147 lines / 2.2 MB**.
  Both are valid to `tail -f`; the shell-redirected one is the one this repo's
  build launcher actually writes to.
- 16-core box; only `builder build` (single process, internally serial per
  wmake sub-invocation, not obviously parallelized) was running — a `-j`-style
  parallel builder was NOT used. A faster run is plausible if the tool
  supports it, not yet investigated.

## Result: CORE TOOLCHAIN + CP/M-86 CLIB SUCCEEDED, overall run FAILED at the doc/GUI tail

**What matters for this project is DONE and verified present:**
- `bld/cc/386/linux386/binbuild/wcc386.exe` (real, non-bootstrap 32-bit C
  compiler; built 01:10, replaces `bwcc386`)
- `bld/wasm/linux386/wasm.exe` (01:02), `bld/wl/linux386/wlink.exe` (01:03),
  `bld/plusplus/i86/linux386/wpp.exe`, `bld/nwlib/linux386/wlib.exe`
- CP/M-86 clib (`bld/clib/_cpm/...`, `cmdcpm86.obj`/`loadcpm86.obj` —the
  `wl format cpm86` linker support) built successfully ~00:52-01:09, well
  before the failure point.

**What failed:** the very last stage, building Windows/OS2 IDE browser help
(`docs/nt/wbrw.gh` via `bld/browser/.../nt386`):
```
build/mif/wgmlcmd.mif(59): Error(E33): !!! Missing DOSBOX configuration or
unsupported building platform !!!
Error(E02): Make execution terminated
Build failed
```
This is the **same class of issue** already documented for macOS in
`reference_watcom_submodule_build_apple_silicon` — WGML-based help/doc
generation needs a DOSBOX-hosted DOS tool, unavailable here. `OWDOCBUILD=0`
(already set) does NOT suppress this specific browser-help sub-build — it's
gated separately, apparently by GUI-tool building for the nt386/os2386 host
targets, not general docs.

**Consequence:** because `builder build` failed before reaching the final
consolidation/install step, the real non-bootstrap tools are NOT copied into
the top-level `build/binbuild/` (which still holds only the `b`-prefixed
bootstrap tools from the earlier boot-only run). They exist, but scattered
under nested per-target `bld/<tool>/<host-target>/` dirs as listed above.

## Fix VERIFIED 2026-08-18: install real `apt install dosbox` and set `OWDOSBOX=dosbox`

User installed DOSBox (`apt install dosbox`, version 0.74-3) and re-ran:

```bash
cd open-watcom-v2
rm -f build-full2.log
export OWDOSBOX=dosbox
nohup ./build.sh > build-full2.log 2>&1 &
```

**This SUCCEEDED completely** — `wgml wbrw.gh` (the step that failed above)
now runs fine under real DOSBox (`build/dosbox.cfg` loaded, no error), and the
whole build reaches its final `bld` close marker with 0 grep-matched errors
and no `Build failed` line. Re-run was fast (~4 min, 01:36-01:40, 5413-line
log) because it reused all objects already built by the first (partially
failed) run — only the doc/browser tail plus the trailing `posix` utility
cluster still needed building.

**Corrected understanding of `build/binbuild/`:** it does NOT get the final
`wcc386`/`wasm`/`wlink`/`wpp` copied into it as part of `builder build` at
all — that directory holds only the bootstrap (`b`-prefixed) cross-tools from
the `boot` stage. The real, non-bootstrap tools live permanently nested under
`bld/<tool>/<host-target>/` (e.g. `bld/cc/386/linux386/binbuild/wcc386.exe`,
`bld/wasm/linux386/wasm.exe`, `bld/wl/linux386/wlink.exe`,
`bld/plusplus/i86/linux386/wpp.exe`, `bld/nwlib/linux386/wlib.exe`) — a
separate, not-yet-invoked distribution/install stage (`OWDISTRBUILD=1` /
`builder dist`, default OFF) is what would consolidate/package them. The
earlier "install step never ran because of the failure" theory in this file
was WRONG — there never is an automatic copy-to-`build/binbuild/` step for
release tools; use the nested `bld/` paths directly (e.g. `PATH` them in, or
symlink) for compiler invocations.

`OWGUINOBUILD=1` (the untried workaround below) was NOT needed once DOSBox
was installed — prefer the real-DOSBox path, it's the complete/correct build.

## The actual "install" stage: `./build.sh rel` (separate from `build`)

`bld/builder.ctl` defines named stages/blocks; `builder build` (what `./build.sh`
runs by default) only COMPILES — it never consolidates. Each component's
`builder.ctl` has a separate `[ BLOCK <BLDRULE> rel cprel ]` block that COPIES
the finished binaries into `<OWROOT>/rel/` (e.g. `bld/cc/386/builder.ctl`:
`linux386/binbuild/wcc386.exe -> <OWRELROOT>/binl/wcc386`, extension stripped).
This only runs when you invoke the `rel` stage explicitly:

```bash
cd open-watcom-v2
export OWDOSBOX=dosbox
nohup ./build.sh rel > build-rel.log 2>&1 &
```

(`./build.sh <stage>` always re-runs `boot` first — fast, a few seconds, no-op
if nothing changed.) **Verified 2026-08-18: SUCCEEDED, 0 errors**, populated
`rel/binl/` with the flat, extension-stripped Linux-host tool set:
`wcc`, `wcc386`, `wasm`, `wlink`, `wpp`, `wlib`, `wcl`, etc. — ran `rel/binl/wcc386`
directly, confirmed real (non-bootstrap) version banner ("Version 2.0 beta Aug 18
2026 ..."), not the bootstrap one. CP/M-86 clib landed at
`rel/lib286/cpm86/clibs.lib` + `rel/lib286/cpm86/cstartcpm.obj`. Took under a
minute (pure copy, no compilation) once `build` had already succeeded.

**This `rel/binl/` + `rel/lib286/cpm86/` pair is now the canonical location to
`PATH`/reference for real (non-bootstrap) Linux-hosted CP/M-86 work**, superseding
the nested `bld/<tool>/linux386/` paths above (which still work but are the
build's internal scratch layout, not the intended install target).

Related: `[[reference_cpm86_toolchain_linux_build]]` (bootstrap-only, already
sufficient for `contrib/ravn/build-cpm86.sh`), `[[reference_watcom_submodule_build_apple_silicon]]`.
