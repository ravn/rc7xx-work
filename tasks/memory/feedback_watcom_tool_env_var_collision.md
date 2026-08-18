---
name: feedback_watcom_tool_env_var_collision
description: Never export/name a shell variable WCC/WASM/WLIB/WLINK when scripting Open Watcom tools — the tools themselves read an env var named after themselves for implicit default switches.
metadata:
  type: feedback
---

Open Watcom's `wcc.exe`/`wasm.exe`/`wlib.exe`/`wlink.exe` each read an
environment variable **named after themselves** for implicit default
command-line switches (a DOS-era convention, still live in the 2026
fork). If a wrapper script does `export WCC=/path/to/wcc.exe` (e.g. to
let a caller override which compiler binary the script invokes), that
same string is ALSO handed to `wcc.exe` itself as bogus extra
command-line content — it tries to parse the path as another source
file and fails with `E1139: Command line contains more than one file to
compile`.

**Why this was hard to spot:** the exact same argv, run directly in an
interactive shell where `WCC` was only a local (unexported) variable,
succeeds every time; the identical command run from inside a script
that had `export WCC=...` at the top fails every time. Looks like
nondeterminism (env-dependent) but is fully deterministic once you
check whether `WCC` is *exported*, not just *set*.

**How to apply:** any script wrapping `wcc`/`wasm`/`wlib`/`wlink` (e.g.
`open-watcom-v2/contrib/ravn/watcom-cpm86-libc/build-*.sh`) must:
- name its own path-override variables something else — this project's
  convention is `OWCC_BIN`/`OWASM_BIN`/`OWLIB_BIN`/`OWLINK_BIN`
  (`${OWCC_BIN:-<default path>}`), not `WCC`/`WASM`/`WLIB`/`WLINK`.
- defensively `unset WCC WASM WLIB WLINK` near the top, in case the
  CALLER's shell happened to export one of those names for an unrelated
  reason.

Found and fixed 2026-08-18 while building `build-farheap.sh`
(`[[reference_cpm86_big_model]]`'s Stage A far-heap seam work) — see
`build-lib.sh`/`build-farheap.sh` for the working pattern.
