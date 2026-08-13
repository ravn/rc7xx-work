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

## Completion signal (guest → host) — added 2026-08-13
Instead of snapshotting on a blind fixed timer, the guest tells the host exactly
when it is done: `#include "mame-tests/mamedone.h"` and call `mame_done(code)` as
the last statement. It emits `OUT 0x2FE,AX` (`#pragma aux`). Port **0x2FE is
undecoded** by rc759_io (floppy ends 0x290, iSBX starts 0x300) → no hardware
effect, but `mame-tests/done_signal.lua` installs a MAME **io-space write-tap**
on 0x2FE: on the first write it snapshots, prints
`DONE-SIGNAL word=0x…  pass=N fail=M`, and calls `machine:exit()`. Passing run
now stops in **~24 s real** (frame ~4028) vs waiting out the 400 s cap; the host
reads pass/fail from the word (mtest.c convention: low byte=pass, high byte=fail,
`0x0013`=19/0) with no OCR. `-seconds_to_run 400` stays only as a safety cap — no
`DONE-SIGNAL` line ⇒ guest hung/regressed ⇒ failure. Tap object MUST be held in a
Lua global (a GC'd tap stops firing). Reusable by any program.

## Result achieved (2026-08-13)
`mtest.c` → **19/19 PASS** (real MAME rc759, large model): long mul/div/mod,
`<<20`, u16 wrap, gcd, sieve, signed div, popcount, **loop-carried long**
(`lfact 12!`=479001600, `lpow10 5`=100000 — the pattern that exposed the __I4M
bug); full binary file round-trip (fopenb/fputc/fgetc/putw/getw/fwrite/fread/
ftell/fseek/ungetc/rewind). Proof PNG `mame-tests/MTEST_PASS_19of19.png`. The
file I/O emu2 garbles is correct here.

## stdcbench 0.8 on real MAME (2026-08-14) — clock source: BDOS, not XIOS
`mame-tests/scb-mame.sh [s|l]` builds stdcbench (`-DMAME_DONE`) and boots it on
MAME; it ends with `mame_done(score)` so the run auto-stops. Result: **final
score 13** (c90base 8, c90lib 5) on the real rc759, small model. Proof PNG
`mame-tests/STDCBENCH_score13_mame.png`.

**Root cause of the earlier hang (VERIFIED, not guessed):** stdcbench self-times
by polling a clock in a tight, syscall-free loop "until elapsed >= 8 s". The
original `portme.c` clock read the PICCOLINE XIOS **Int 28h fn 19 "16 ms
counter"**. On this turnkey disk under **Concurrent CP/M-86 3.1**, that XIOS does
NOT maintain the counter — the `clktest.c` probe read it after a busy loop, after
20000 BDOS syscalls, and after another busy loop, and every field stayed **0**
(snapshot `mame/snap/rc759/0000.png` from that run). So the loop's `end - start`
was always 0 < 8000 → spin forever → banner shown, no score.

**Fix:** `portme.c` `stdcbench_clock()` now uses the ordinary BDOS call
**T_SECONDS (fn 155 / 0x9B)** via `INT 0E0h` — the same time-of-day the CCP/M
status-line clock reads, which *does* advance. 1-second resolution is coarser
than 16 ms, but the score formula divides by the *actual* measured elapsed
(`SECONDS / (end - start)`), so it only quantises, does not bias. **Policy going
forward: use only BDOS (INT 0E0h) calls in this glue, no XIOS calls.**
TOD struct is `{unsigned day; unsigned char hour, min, sec;}` (hour/min/sec are 2
BCD digits); must be a **static** (DGROUP/DS) struct, not a stack local, so the
BDOS write lands where we read (DS != SS in large model).

**stdcbench covers NO math (verified):** the `c90float`/`c90double` modules are
upstream stubs returning 0 ("NOT YET IMPLEMENTED" in stdcbench 0.8), and no
`<math.h>`/libm is used anywhere — c90base is integer, c90lib is string/hashtable
work. So score 13 measures only integer + standard-library performance and says
nothing about DR C float/double/transcendental correctness. The DR C math bridge
status is analysed separately in `../DRC_FLOAT_ANALYSIS.md` (transcendentals are
real software routines & correct in genuine DR C; only *double-returning* library
calls fail to bridge under Watcom `-fpi87`). Tracked as ravn/rc7xx-work#3.
Large-model stdcbench on MAME is unverified (small-model only) — tracked as #4.
