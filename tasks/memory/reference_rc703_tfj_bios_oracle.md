---
name: reference-rc703-tfj-bios-oracle
description: The datamuseum RC703_Div_BIOS_typer disk (Bits:30003297) carries a fully assembled, RUNNABLE CP/M BIOS in its system tracks (rel. TFj) — a byte-level golden oracle for the rcbios reconstruction. Preserved in rc703-div-bios-typer/.
metadata:
  type: reference
---

The datamuseum disk **`RC703_Div_BIOS_typer.bin`** (datamuseum.dk
**Bits:30003297**, 5.25" rc703-qd, 819200 B) is a real 1980s working disk.  We
had already extracted its **36 user-0 files** (the .MAC sources etc.) into
`rc700-gensmedet/rc703-div-bios-typer/`.  Analysed 2026-07-02: the **system/boot
tracks** (`boottrk 4` → tracks 0-3 = 20480 B) that `cpmcp` does NOT copy carry
the **fully assembled, runnable** bootstrap + BDOS/CCP + BIOS.  Preserved as
`rc703-div-bios-typer/RC703_Div_BIOS_typer.systemtracks.bin`.

**New knowledge from the system tracks:**
- Assembled signon = **`RC703  56k CP/M vers. 2.2  rel. TFj`** — the binary is
  self-labelled `rel. TFj`, though the source TITLE says `RELEASE 1.1
  83.09.14`.  Hard evidence it is Torben Fjerdingstad's personal build.
- Embedded `BIOS BESTÅR AF:` manifest = the definitive **13-module link order**:
  BIOS703, BIOSTYPE, INIPARMS, DANISHOF, INIT, CPMBOOT, SIO, QDISPLAY, FLOPPY,
  HARDDSK, QDISKTAB, INTTAB, PIO.
- Runtime strings: `Waiting`, `Cannot read configuration record.` (config-record
  read), `Wrong CP/M Version (Requires 2.0)`, a STAT-style capacity table.
- RC763/RC763B hard-disk support present.

**Why it matters:** this is a **byte-level golden oracle** for validating the
**rcbios** reconstruction (boot flow, load addresses, BIOS binary) — reach for
it when checking rcbios against a genuine RC703 build.  Caveat: it's TFj's fork
(diverged from RC rel.1.1 in 1983, evolved to 1987), NOT the RC702 rel.2.0–2.3
line, so differences can go either way — see `rc703-div-bios-typer/README.md`
and [[reference-rc700-family-proms]].  MAME boot of the full disk:
`rcbios/mame_boot_test.sh` runs `rc703 … RC703_Div_BIOS_typer.imd` expecting
`56k CP/M vers. 2.2`.
