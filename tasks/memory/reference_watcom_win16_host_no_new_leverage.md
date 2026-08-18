---
name: reference_watcom_win16_host_no_new_leverage
description: Investigated whether Open Watcom's Win16/Win386 host build or the official win16 installer offer anything new for CP/M-86 work — they don't; both are the same 32-bit protected-mode toolchain already built locally.
metadata:
  type: reference
---

2026-08-18, sonnyboy. Triggered by noticing `rel/binw/` (built as part of the
already-verified full non-bootstrap build, [[reference_openwatcom_full_build_linux]])
and the official GitHub release asset
`open-watcom-2_0-c-win16.exe` (repo `open-watcom/open-watcom-v2`, tag
`Current-build`).

## Finding 1: `binw/` is NOT a genuine 16-bit-hosted compiler

`rel/binw/wcc.exe` / `wcc386.exe` are **LE-format 32-bit protected-mode**
executables (`file`: "MS-DOS executable, LE for unknown OS 0x1"), built from
the `dos386/` host target (`bld/wl/builder.ctl`, `bld/wstuba/builder.ctl`) and
using the **WIN386 DOS extender** (`bld/win386/builder.ctl`, adds
`wdebug.386`/`wemu387.386` VxDs for integration when launched from a Windows
3.x 386-Enhanced-mode DOS box). This is architecturally the SAME class as
`rel/binp/` (DOS4GW/Causeway-extended 32-bit tools) — both require a 386+ CPU
and a protected-mode extender. Neither is a true 16-bit real-mode host.

The only genuine NE-format (true Win16) binaries under `binw/` are small
helper DLLs used *by* the IDE/debugger (`codeview.dll`, `mapsym.dll`,
`madaxp.dll`) — not the compiler itself.

## Finding 2: the official `c-win16.exe` release installer bundles the identical payload

Downloaded and compared all three C installers from the `Current-build`
release (`gh release download Current-build --repo open-watcom/open-watcom-v2`):

```
open-watcom-2_0-c-win16.exe:   NE version 5 for MS Windows 3.10, Watcom Win386 extender (EXE) (GUI)  — 127.7 MB
open-watcom-2_0-c-dos.exe:     LE for unknown OS 0x1                                                  — 127.6 MB
open-watcom-2_0-c-win-x86.exe: PE32 for MS Windows 4.00 (GUI), Intel i386                              — 127.7 MB
```

Only the outer installer **wrapper** format differs (so each can be
double-clicked from its own target host — NE so it launches directly under
Windows 3.1 File Manager). `strings` on the win16 installer's embedded ZIP
payload shows it ships the SAME `binl/`, `binl64/`, `binnt/`, `binnt64/`,
`binp/`, **and `binw/`** directories as every other installer — i.e. the
*exact* toolchain already built locally, no exclusive 16-bit-hosted `wcc`
inside.

## Finding 3 (established earlier same session): Win16 clib offers no new low-level seam for CP/M-86

`bld/clib/_dos/a/io086.asm` (the DOS Int21h low-level I/O source we already
replaced for the CP/M-86 BDOS seam, see
`[[reference_watcom_cpm86_startup_initfini]]`) is compiled **byte-identical**
into both `msdos.086` (DOS) and `windows.086` (Win16) library trees
(`bld/clib/builder.ctl` lines 18-43 vs 100-113) — no `#ifdef WINDOWS`
branching. No `sbrkwin.c` exists either (only NT has an OS-specific
`sbrkwnt.c`) — Win16 reuses the same DOS `__brk` heap seam. Everything Win16
clib adds on top (`WinMain`, message pump, `commdlg`/`ddeml`/`ctl3d`) is GUI
machinery irrelevant to CP/M-86's text/BDOS environment.

## Conclusion

Three independent angles (own host build, official installer payload, clib
source) all converge: **there is nothing to gain from the Win16/Win386 route
for the CP/M-86 retarget project.** The existing `watcom-cpm86-libc/` port
(built from the shared `msdos.086` clib source) is already the best available
starting point — see `[[project_finishing_firmware_components]]` context and
the CP/M-86 retarget durable facts in the top-level `MEMORY.md`.
