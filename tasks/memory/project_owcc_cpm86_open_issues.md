---
name: project_owcc_cpm86_open_issues
description: Open issues on ravn/open-watcom-v2-ccpm86 for the CP/M-86 toolchain -- filed 2026-08-27, awaiting implementation.
metadata:
  type: project
---

Open issues on ravn/open-watcom-v2 CP/M-86 port (all filed 2026-08-27):

| # | Title | Key detail |
|---|-------|-----------|
| [#36](https://github.com/ravn/open-watcom-v2-ccpm86/issues/36) | `OPTION NEARHEAP=<size>` | `WC_ARENA_BYTES=36352` hardcoded in `lowlevel.c`; analogous to `OPTION FARHEAP` |
| [#37](https://github.com/ravn/open-watcom-v2-ccpm86/issues/37) | Pipe operator `\|` | Temp-file + P_CHAIN mechanism; `redirect_one()` in `diskio.c` needs `\|` case |
| [#38](https://github.com/ravn/open-watcom-v2-ccpm86/issues/38) | Trailing `^Z` in `>file` redirect | `__close_redirection`: do `ftell(stdout)` before fflush, then `lseek` + zero-length write to truncate |
| [#39](https://github.com/ravn/open-watcom-v2-ccpm86/issues/39) | `argv[0]` hardcoded `'UNZIP'` | `cstartcpm.asm:110`; CP/M-86 base page has no program name — options: liker symbol, EMU2_PROGNAME, or generic placeholder |
| [#40](https://github.com/ravn/open-watcom-v2-ccpm86/issues/40) | `main()` return value ignored | crt0 always calls BDOS fn 0 (warm boot); should use P_TERM (fn 108) with DX=return code |

**Why:** Context for how complete the CP/M-86 clib is and what's missing for production use.

**How to apply:** Check these before declaring the CP/M-86 toolchain "done" — #38 (^Z) and #40 (exit code) are correctness bugs; #36/#37/#39 are feature gaps.
