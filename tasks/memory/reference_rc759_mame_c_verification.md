# RC759 CP/M-86 C-program verification via MAME (harness)

**How to prove a compiled CP/M-86 C program runs correctly on real RC759
hardware** — the user's requirement (verify in the emulator, NOT emu2/unicorn,
whose DR C file read path is confounded and non-deterministic).

## One command
`scratch/rc759-cmd-toolchain/mame-tests/run-mame.sh [prog.c]`
Pipeline: `cc-cpm86.sh -m l` build → cpmtools disk swap → MAME boot → snapshot.
The on-screen `RESULT: PASS n/n` line (viewed from the PNG) is the oracle.

## Key facts
- **Binary:** `mame/regnecentralend` MUST contain the FDC/DMA fix (commit
  59b21dc1312). Rebuilt 2026-08-13; the older 75 MB `mame` and any debug binary
  older than the fix commit do NOT load CMDs (spurious WD2797 LOST DATA). Rebuild:
  `make SUBTARGET=regnecentralen DEBUG=1 SOURCES=src/mame/regnecentralen/rc759.cpp OSD=sdl -j10`.
- **Autoboot:** `rm -f nvram/rc759/nvram` before each run to force the seeded
  autoboot (rc759.cpp nvram_init). Without it you land at the ROM monitor
  "PICCOLINE TEST V.2.1 *" prompt.
- **Boot is slow:** ~290 emulated seconds; post-boot appears around frame
  12500–15000 (screen ~50 Hz). Use `-seconds_to_run 400` (~150 s real at ~267%).
- **Autostart a program:** the turnkey disk `scratch/rc759-pce/images/mandel.img`
  runs `menu imenu` from `startup.0`. Install your CMD as `menu.cmd` (via
  cpmtools, format `drc-rc759`, run FROM `images/`) and it autostarts. Disk is
  packed (~10K free) — delete unused utilities (comal80/diskvedl/help + old menu)
  to fit a ~55K large-model CMD.
- **Invocation:** `./regnecentralend rc759 -bios 0 -skip_gameinfo -rompath roms
  -flop1 <abs .img> -autoboot_script snap.lua -seconds_to_run 400 -nothrottle
  -sound none -video bgfx -window -nomax`. Snapshot lua:
  `emu.register_frame_done(function() ... manager.machine.video:snapshot() end)`
  → `snap/rc759/000N.png`. `.img` is accepted (rc759 format, `-flop1`).
- **cpmtools** at `$HOME/.local/bin` — INVOKE by full path; never `find`/`ls`
  inside home. `kill $VAR` is blocked by a hook — kill by literal numeric PID.

## Result achieved (2026-08-13)
`mtest.c` → 17/17 PASS: long mul/div/mod, `<<20`, u16 wrap, gcd, sieve, signed
div, popcount; full binary file round-trip (fopenb/fputc/fgetc/putw/getw/fwrite/
fread/ftell/fseek/ungetc/rewind). Proof PNG committed as
`mame-tests/MTEST_PASS_17of17.png`. The file I/O emu2 garbles is correct here.
