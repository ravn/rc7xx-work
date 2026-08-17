---
name: Which emu2 is which — stock dmsc/emu2 (DOS tools) vs forked emu2-cpm86 (DR C headless)
description: The workspace has TWO distinct emu2 builds plus a copy and a vendored source. Use the FORK for DR C; the stock one is DOS-only and hangs DR C via double emulation.
metadata:
  type: reference
---

# emu2 variants in the workspace (verified 2026-08-17)

There are **two distinct emu2 builds** (binaries differ), plus one identical copy
and one vendored source tree. Picking the wrong one is why DR C hung on
"Stop DRC (Y/N)?".

## 1. Stock `dmsc/emu2` — DOS emulator only
- `open-watcom-v2/contrib/ravn/cpm86-crossdev/emu2/emu2`
  (+ `.../cpm86-crossdev/bin/emu2` = an IDENTICAL copy).
- Remote: `https://github.com/dmsc/emu2` (master). Unmodified upstream.
- Role: runs **DOS `.exe` programs** — the Aztec C86 tools (cc/cgen/as/obd, via
  the `aztecNN_*` wrappers) and the DOS-hosted `cpm86.exe` (Lopushinsky CP/M-86
  emulator, via the `bin/cpm86` wrapper).
- ⚠ DR C via the `bin/cpm86` wrapper runs it as **double emulation**
  (emu2 → cpm86.exe → DRC.CMD). It needs a real TTY and BLOCKS on the DR C
  console prompt ("Stop DRC (Y/N)?"). Do NOT drive DR C this way.

## 2. Fork `ravn/emu2-cpm86` (branch `cpm86-drc-headless`) — DR C headless
- `scratch/cpm86-tools/emu2-cpm86/emu2`.
- Remote: `git@github.com:ravn/emu2-cpm86.git`, branch `cpm86-drc-headless`.
- Three CP/M-86 patches (FCB bit-7 masking, auxiliary-group loading, BDOS 47
  chaining — captured in `scratch/rc759-cmd-toolchain/emu2-patches/`) that make
  it emulate **CP/M-86 natively (single layer)** and run DR C 1.11 **fully
  headless**.
- This is the one `scratch/rc759-cmd-toolchain/drc-oracle.sh` uses (its default
  `EMU2=$HERE/../cpm86-tools/emu2-cpm86/emu2`).

## 3. `emu2-cpm86/` at the repo root — vendored source
- Tracked in the MAIN repo (origin = `ravn/rc7xx-work`, main). A committed source
  copy, not a separate role.

## Rule of thumb
- **DR C 1.11** → always the FORK (via `drc-oracle.sh`), never crossdev stock.
- **Aztec / DOS tools** → crossdev stock `dmsc/emu2` (the `aztecNN_*` wrappers).

## Bonus: DR C reports code size directly
The DR C code-gen pass prints `code: N static: N extern: N` — `code:` is the
emitted function code size in bytes (no OMF parsing needed). Verified on the
Byte sieve: DR C small model (default) `code: 121`, large model (`-b`)
`code: 151`.
