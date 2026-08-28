---
name: project_owcc_cpm86_open_issues
description: Open issues on ravn/open-watcom-v2-ccpm86 for the CP/M-86 toolchain -- status 2026-08-28.
metadata:
  type: project
---

Open issues on ravn/open-watcom-v2 CP/M-86 port:

## Closed (2026-08-28)

| # | Title | Fix |
|---|-------|-----|
| [#38](https://github.com/ravn/open-watcom-v2-ccpm86/issues/38) ✓ | Trailing `^Z` in `>file` redirect | `diskio.c`: redirect output opened with `O_BINARY` → LRBC exact size on close |
| [#40](https://github.com/ravn/open-watcom-v2-ccpm86/issues/40) ✓ | `main()` return value ignored | All four crt0s: `push ax` before redirect close, `pop ax` + `mov dl,al` before BDOS fn 0 |

## Open

| # | Title | Key detail |
|---|-------|-----------|
| [#36](https://github.com/ravn/open-watcom-v2-ccpm86/issues/36) | `OPTION NEARHEAP=<size>` | `WC_ARENA_BYTES=36352` hardcoded in `lowlevel.c` |
| [#37](https://github.com/ravn/open-watcom-v2-ccpm86/issues/37) | Pipe operator `\|` | Temp-file + P_CHAIN; `redirect_one()` needs `\|` case |
| [#39](https://github.com/ravn/open-watcom-v2-ccpm86/issues/39) | `argv[0]` hardcoded `'UNZIP'` | `cstartcpm.asm`; no program name in CP/M-86 base page |
| [#41](https://github.com/ravn/open-watcom-v2-ccpm86/issues/41) | All-models test gate via Docker + stdcbench | `run-all-models.sh` uses native tools; needs Docker-native mode |
| [#42](https://github.com/ravn/open-watcom-v2-ccpm86/issues/42) | Freestanding DATA-fixup test requirements | begdata+STACK+zm layout needed; documented for future test writers |

## Also fixed this session (open-watcom-v2 only, no issue)

- **owcc `-mm` flag** (`ceafcb9bc4`): single-letter memory model flags were silently dropped in `owcc.c`; `-mm`/`-ms`/`-mc`/`-ml`/`-mt` now pass through to wcc. Use `-mm` (not `-mcmodel=m`) for owcc.
- **All 4 clib models in Docker**: `build_open_watcom_docker.sh` now builds s/m/c/l clib models with Linux-x64 tools and installs into `rel/lib286/cpm86/` before Docker packaging.

**Why:** Context for how complete the CP/M-86 clib is.
**How to apply:** #36/#37/#39 are remaining feature gaps; #41 is a test infrastructure gap.
