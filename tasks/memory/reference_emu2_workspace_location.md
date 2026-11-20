---
name: reference_emu2_workspace_location
description: emu2 CP/M-86 emulator er i workspace-roden — ikke et eksternt værktøj der mangler
metadata:
  type: reference
---

emu2 er checked in i workspace-roden:

- **macbook**: `/Users/ravn/z80/emu2-cpm86/emu2` (Mach-O arm64)
- **sonnyboy**: `/home/ravn/z80/emu2-cpm86/emu2`

Build-scripts i `open-watcom-v2/contrib/ravn/watcom-cpm86-libc/` auto-detekterer begge stier.

**PTY-krav**: emu2 kræver en TTY på stdin. Når det køres ikke-interaktivt (f.eks. via Claude Code):
```bash
script -q /dev/null "$EMU2" -P 255 prog.cmd | sed -e $'s/.\x08//g' -e $'s/.\x08//g' | tr -d $'\r'
```
`script -q /dev/null` giver pseudo-TTY; dobbeltsed fjerner `^D\b\b`-headeren som script præpenderer.

Se [[reference_emu2_tpa_pool_fidelity]] for TPA-kalibrering.
