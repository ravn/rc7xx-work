---
name: reference_pce_rc759_headless_automation
description: Proven, end-to-end technique for driving PCE/rc759 headlessly — real X11 key injection without xdotool, breaking into the monitor from a live real-time run, and swapping floppy media via PCE's own emu.disk.eject/insert messages (no file overwriting).
metadata:
  type: reference
---

2026-08-18, sonnyboy. Built while proving out `pce/` (submodule, fork
`ravn/pce` of `retrohun/pce`, see `[[project_pce_rc759_vs_mame_accuracy]]`) as
an RC759 hardware oracle. Full pipeline verified: headless boot (Xvfb) →
scripted keyboard input → live disk swap via PCE's proper API → screenshot,
all without touching the running emulator's open disk-image file.

## Screenshot: parse XWD manually, no ImageMagick needed

`xwd -root -out shot.xwd` + a ~20-line Python `struct`/`PIL` script. XWD
header is 25 big-endian `>I` fields (100 bytes); `header_size - 100` bytes of
null-terminated window name follow, then `ncolors * 12` bytes of an
`XWDColor` table (skip it for truecolor), then raw pixel bytes
(`bytes_per_line * height`). For 32bpp/`byte_order=0` (LSBFirst, the normal
case), `Image.frombytes('RGB', (w,h), pixels, 'raw', 'BGRX', bytes_per_line, 1)`.
Also usable in-emulator: `m term.screenshot "file.ppm"` (PNM, no xwd needed) —
but see below, only reachable from the monitor.

## Keyboard: send real XSendEvent, no xdotool/sudo needed

A ~50-line Python `ctypes` wrapper around `libX11.so.6` (stdlib only, no
`python-xlib`, no pip, no sudo): `XOpenDisplay`, build an `XKeyEvent`
ctypes.Structure matching the C layout, `XStringToKeysym`/`XKeysymToKeycode`,
then `XSendEvent(dpy, win, False, KeyPress|KeyReleaseMask, &ev)` for down then
up. PCE's terminal driver does not check `send_event` (synthetic-event flag),
so this works exactly like a real keypress. Find the window id via
`xwininfo -root -tree | grep pce-rc759`. Full script content: see this
session's `sendkeys.py` (not committed — recreate from this description if
needed, it's short).

**rc759 has NO monitor-break hotkey.** `doc/keys.txt`'s "Generic Terminal
Keys" (ESC-m = break to monitor, ESC-s = screenshot, etc.) is real but only
wired up for ibmpc/macplus/atarist — `src/arch/rc759/keyboard.c`
`rc759_kbd_set_key()` explicitly no-ops `PCE_KEY_EVENT_MAGIC` ("unhandled
magic key"). So ESC-sequences cannot break a running rc759 session back to
the monitor; only an OS signal can (below). `doc/rc759-keymap.txt` has the
full PC-key-name → RC759-scancode table if a specific key mapping is ever in
doubt.

## Breaking into the monitor: SIGINT, but beware a real race

The `-r` (run-immediately) `g` free-run loop only checks `sim->brk`, which is
only set by `sig_int`/`sig_term` signal handlers (`src/arch/rc759/main.c`).
So `kill -INT <pid>` correctly breaks a live `g` back to the monitor prompt —
**without killing the process** (confirmed: it logs `pce-rc759: sigint` and
falls back to reading monitor commands from stdin). SIGTERM ALSO does this
(sets `brk=PCE_BRK_ABORT` vs. SIGINT's `PCE_BRK_STOP`) but SIGINT is the
intended "graceful stop" signal — don't use a stray `pkill -f pce-rc759`
near a live session, it'll trigger this same break unintentionally.

**Real bug/race found:** `pce_start(&sim->brk)` resets `*brk = 0` at the
*start* of every `rc759_run()` call. If SIGINT arrives before the monitor has
actually dispatched the pending `g` command and entered `rc759_run()`, the
signal's effect is silently wiped the instant `g` does start, and the run
continues forever with no way back in (this produced a real multi-minute
hang this session, second and third `kill -INT` attempts after the first
successful one never landed). **Fix: retry-send `kill -INT` in a loop,
confirming success by polling the log file for a new `sigint` line** (compare
`grep -c sigint "$LOG"` before/after each attempt) rather than firing once
and assuming success. Pitfall when implementing the retry: `grep -c` with
zero matches still prints `0` to stdout AND exits 1 — `grep -c ... || echo 0`
double-prints (`"0\n0"`), breaking `[ N -gt M ]` integer comparisons. Just use
`$(grep -c sigint "$LOG")` alone (always emits a single valid integer).

## Disk swap: PCE's own message API, not file overwriting

`m disk.eject <drive>` then `m disk.insert <drive>:<path>` (message names are
documented in `doc/messages.txt`; prefixes `emu.disk.*` may be abbreviated to
`disk.*` or the bare verb). Sent via the monitor's `m` command over a
persistent FIFO stdin (see below) — this is the sanctioned, safe way to swap
media on a live session; confirmed the emulator picks up the new disk
content correctly (BATCH read new files off the swapped image). The eject
logs `ejecting drive 0`; insert did not print a confirming log line but its
effect was directly observed (new disk's directory contents were read).

## Feeding the monitor without hanging: a persistent FIFO, never let stdin EOF

`mkfifo cmdpipe; pce-rc759 ... < cmdpipe & exec 3> cmdpipe; printf 'cmd\n' >&3 ...`.
Piping a single `echo "cmd" | pce-rc759 ...` closes stdin after one line;
the monitor's read loop does not handle that EOF cleanly and can busy-hang
(observed: a `c <N>`-based batch script hung 2+ minutes with zero output).
Keep fd 3 open across the whole session via `exec 3> fifo ... exec 3>&-` at
the end.

## `c <N>` (monitor cycle-stepping) is NOT free/instant

`rc759_cmd_c` calls `rc759_clock` directly with no throttling (unlike `g`'s
real-time-synced `rc759_clock_delay`), so it was expected to run at max
interpreter speed. Measured: 50,000,000 cycles took **more than 8 seconds**
— i.e. raw interpretation throughput is only around the same order as the
emulated 6 MHz clock rate (~1x realtime), not meaningfully faster. **`c` is
not a fast-forward trick** for this emulator; prefer real-time `g` + wall
clock `sleep` (which is what boot timing (~38s to reach `A>`, ~6s more to a
BATCH `PAUSE` prompt) was calibrated against across many runs this session).

## Known-good calibration for this specific CDOS disk (Bits:30002654)

- ROM: `mame/roms/rc759/rc759-1-5.1.rom` (or `-1-2.1.rom`), copied to
  `rc759-1-2.1.rom` in the working dir (config's hardcoded default filename).
- Boot disk: `scratch/rc759-cmd-toolchain/ddhf-cache/bits/30002654.bin`
  ("CDOS systemdisk", 1,261,568 B, matches `rc759-drc` diskdef geometry).
- ~38s real time from launch to the `A>` prompt.
- ~6s more after typing `gem<CR>` to reach the `GEM.BAT` `PAUSE` prompt.
- GEM disk mismatch: `Bits:30002668` "GEM systemdisk" is actually a **FAT12
  RC-DOS disk** (`file`: OEM-ID "Rc Dos X", 1,228,800 B) — wrong format
  entirely, do not use for CP/M-86 GEM. `Bits:30002727`/`30002728`
  ("SW1648 GEM Collection Release 1.1 Disk 1/2, 2/2", 1,261,568 B each) ARE
  correct CP/M-86-format GEM disks (contain `gem.exe`/`gemvdi.exe`/fonts) but
  this specific CDOS build's `GEM.BAT` expects a `0GEMSYS` directory/user-area
  layout this particular release doesn't provide — a real disk-version
  mismatch, not a technique failure. Finding the exact matching GEM release
  for this CDOS build is unfinished (deprioritized, user 2026-08-18: "vi
  behøver ikke få gem i luften lige nu").

Related: `[[project_pce_rc759_vs_mame_accuracy]]` (why PCE/rc759 matters as
an oracle), `[[reference_rc759_mame_sonnyboy_headless]]` (the equivalent
MAME-side headless-boot technique).
