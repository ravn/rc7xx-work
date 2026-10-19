---
name: MAME must always run windowed with a timeout
description: ABSOLUTE — never invoke raw MAME binaries. Every launch must go through Makefiles or scripts with -window AND finite -seconds_to_run.
metadata:
  type: feedback
---
**ABSOLUTE BAN: NEVER invoke `mame`, `rc702test`, `regnecentralen`, or `regnecentralend` directly from the shell — no exceptions, not even for quick checks, `--help`, or inline Lua probes.**

All MAME interaction MUST go through:
1. Existing Makefile targets (`make mame`, `make cpnos-polypascal-test`, `make mame-test`), or
2. The project launcher script `rc700-gensmedet/scripts/mame_capture.sh` (or a dedicated wrapper script) that enforces `-window`, `-seconds_to_run N`, `-skip_gameinfo`, and `-sound none`.

Never launch MAME:
- directly as a raw binary in the terminal,
- in fullscreen (i.e. without `-window`),
- headless via `-video none` as a substitute — the user wants to SEE the
  window, so pass `-window` even for automated framebuffer-tap tests (they
  read display RAM from memory and work fine with a real window open;
  reinforced 2026-08-06 after a `-video none` COMAL regression run), or
- without a timeout, i.e. `-seconds_to_run 0` (which runs indefinitely) or
  omitting the flag entirely.

**Why:** MAME defaults to fullscreen exclusive mode with SDL input-grab on macOS, capturing mouse and keyboard and halting indefinitely on modal ROM warnings before any autoboot script executes. This completely locks the user's desktop, keyboard, and mouse cursor, forcing a hard machine reboot.
- Reported 2026-07-31 after a background `regnecentralend rc703 ... -verbose -seconds_to_run 0` launched fullscreen forever.
- Reported 2026-10-19 after an ad-hoc inline Lua probe (`/Users/ravn/z80/mame/rc702test rc702 ... -autoboot_script /tmp/test_baud.lua`) omitted `-window` and `-seconds_to_run`, halting on the red ROM warning screen and freezing the host desktop.

**How to apply:**
- NEVER assemble raw MAME command lines ad-hoc in terminal calls.
- Always use the Makefile targets or wrapper scripts.
- For info that does not need to start the machine, prefer non-emulating
  commands: `-validate`, `-listxml`, `-verifyroms` (these do not open a window).

