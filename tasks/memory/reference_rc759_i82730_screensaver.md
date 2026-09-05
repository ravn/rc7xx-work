---
name: reference-rc759-i82730-screensaver
description: How the RC759 CCP/M-86 screensaver blanks the screen via 82730 list_switch + EOF + blk_row. Diagnosed and fixed 2026-08-31.
metadata:
  type: reference
---

# RC759 i82730 screensaver / screen-blank mechanism (ravn/mame-rc702-rc759-rc750#28, FIXED 2026-08-31)

## What the screensaver does

After ~15 min 41 s emulated idle (frame 58816), the CCP/M-86 XIOS issues an
`LD CUR POS` command with `list_switch=1`. This redirects the 82730's display-
list reader from list 0 (cbp+6/8) to list 1 (cbp+10/12). Any keypress makes
the XIOS reissue list_switch=0 and restore the normal menu.

**The screensaver is a PARTIAL blank** — it hides the title row and status line,
but leaves the config-menu body (rows A-G) visible.

## Mechanism: row 0 blanked via EOF (0x81)

List-1's datastream for the top row (row 0) ends with **EOF (cmd 0x81)** as the
first word of the character-data string. On real hardware, EOF de-asserts VIDEO
ENABLE and blanks the rest of the field. MAME had `dscmd_eof()` returning false
("not implemented"), so load_row() continued past EOF and rendered garbage data
from address 0x00faa2 onwards (uninitialised memory, `0xcccc...` pattern).

Key addresses at t=942s (post-flip):
- `cbp = 0x00f7f6` (command block pointer, static)
- list-1 base: `cbp+10/12 -> 0x00f95c`
- list-1 entry 0 (pre-ENDSTRG sptr): `0x00f95c -> 0x00f9e4` (shared with list-0)
- list-1 entry 1 (post-ENDSTRG sptr): `0x00f960 -> 0x00fa9a`
- entry 2 (post-second-ENDSTRG sptr): `0x00f964 -> 0x00faa2`
- `0x00faa2`: `0x8100` = EOF command — first word of the character data string

## Mechanism: status line blanked via blk_row=1 (FULROWDESCRPT)

The status row sptr = `cbp+34/36 = 0x00f9f0` (direct address, not a pointer).
At 0x00f9f0, the screensaver writes:
```
8301  FULROWDESCRPT param=1
0400  blk_row=1, lpr=0       <- blank this row
8a50  REPEAT 0x50 (80 chars)
0000  char 0x00 repeated
0820  ' ' (start of actual text, never rendered due to blk_row)
...   "Konsol=0  Dynamisk MENU  Skriver=0  HH:MM:SS"
```
The XIOS writes blk_row=1 when the screensaver activates. Previously MAME parsed
blk_row from FULROWDESCRPT but never checked it in row_update.

## The fixes (branch rc759-82730-graphics, committed 2026-08-31)

All in `src/devices/video/i82730.cpp`:

1. **blk_row**: skip render callback + fill bitmap scanline with black when
   `m_mb.blk_row` is set. Bitmap coordinate: `y - m_mb.vsyncstp` (not `y`),
   matching the convention the driver callback uses.

2. **EOF (m_eof_hit flag)**: `dscmd_eof()` sets `m_eof_hit = true` and returns
   `true` (terminates load_row). In row_update: cleared at y==0 (frame start);
   when set, suppresses `m_update_row_cb` AND `load_row()` for all subsequent
   rows AND the status row. Bitmap fill at `y - m_mb.vsyncstp` same as above.

3. **Bitmap coordinate bug**: render callback writes at `y - vsyncstp`; our fill
   loop must use the same offset or it writes to the sync-blanking region (wrong
   rows, old pixels remain visible).

## SL SCROLL (0x84/0x85)

SL SCROLL START/END commands implement "blød rulning" (soft scrolling). The RC759
config menu does NOT use it — "CRT scroll mode" in the NVRAM (byte 18, high nibble)
is 0 = jump scroll. Tracked in ravn/mame-rc702-rc759-rc750#23 (not implemented, not urgent).

## Diagnostic scripts (scratch/mame-shots/)

- `dump_list1_postflip.lua` — runs at t>942s, dumps list-0/list-1 base addresses,
  both sptrs, raw hex + decoded datastream for top row and status row.
- `dump_faa2.lua` — runs at t>942s, dumps and decodes 0x00faa2 (the garbage addr)
  to find the EOF command; also shows list-1 entry0/entry1.
- `snap_after_flip.lua` — takes a MAME snapshot at t>943s for visual verification.

Run under `-nothrottle -seconds_to_run 950`; flip arrives in ~4-5 min wall time.

## Oracle

After fix: screensaver shows entirely blank (black) screen except for the config
menu body (rows A-G) which remains visible. Status line and title row are blank.
Snapshot `snap/rc759/0129.png` confirms correct behavior.

## Related

- ravn/mame-rc702-rc759-rc750#28 — filed issue with full instrumentation trace (CLOSED by this fix)
- ravn/mame-rc702-rc759-rc750#30 — dead m_gfx_mode cleanup (CLOSED 2026-08-31)
- ravn/mame-rc702-rc759-rc750#31 — MYRESNAK BB/HENT freeze (CLOSED 2026-08-31)
- [[reference-rc759-82730-graphics]] — graphics mode (Myresnak) fix
- [[reference_rc759_i82730_display]] — general 82730 display facts
