---
name: reference-rc759-82730-graphics
description: How RC759 Piccoline "graphics mode" actually works in the Intel 82730, and how MAME renders it. Solved 2026-08-30.
metadata:
  node_type: memory
  type: reference
---

## RC759 graphics = programmable-char-generator framebuffer, NOT a bitmap plane

The Intel 82730 is a **pure text coprocessor with no native bitmap graphics
plane** (its datasheet, `mame/docs/i82730_datasheet.pdf`, mentions "graphics"
only on the cover). Even on a "graphics" screen the 82730 display list feeds
**character codes** in the row buffer (`data[]`), never pixels. Any code that
treats `data[i]` as pixel bytes (e.g. `data[i] >> 8`) is wrong and produces
garble — that was Mistral's bug in the original 58c65ba "graphics support".

How the RC759 (and Myresnak) actually draw:

1. The CPU **swaps the whole 82730 mode block** to switch layout. There is **NO
   dedicated graphics bit** anywhere in the mode block (all 18 words checked;
   `wdef/dbl_hgt/blk_row/rvv_row` are 0 in both modes). PPI port C **bit 6**
   (the old `m_gfx_mode`) is **NOT** the graphics signal — it reads 0 during the
   graphics screen. The real distinction is the cell geometry:
   - text:     80 char/row, cells 10 scanlines tall (`m_mb.lpr = 9`)
   - graphics: 35 char/row, cells 16 scanlines tall (`m_mb.lpr = 15`)
   Both span the same **560 px** active field (`(hfldstp-hfldstrt)*16 = 35*16`),
   so cell pitch = `560 / chars_per_row` → **7 px** text, **16 px** graphics.
2. The CPU renders a **560×256** bitmap into the programmable character-generator
   RAM (`m_vram`, CPU `0xD0000-0xD7FFF`, mirror 0x08000) and **tiles the screen
   with unique cell codes = `(col << 4) | row`**, so each of the 35×16 cells is a
   distinct 16×16 glyph. Rendering is the ordinary font lookup
   `m_vram[(code<<4) | lc]`, bit 15 = leftmost pixel.

## MAME fix (rc75x.cpp + i82730)

- Detect graphics by the mode-block field, exposed as
  `i82730_device::rows_per_char()` ( = `m_mb.lpr + 1`): text=10, graphics=16.
  Branch `if (m_txt->rows_per_char() >= 12)` in `txt_update_row`.
- `gfx_update_row`: render `cell_w = 560 / x_count` (=16) full-width bits per
  cell from the font word; NO proportional-width guard, NO zero-low-byte skip
  (those low bytes are pixel data in graphics).

## Oracle & how to run

- Oracle: `rc700-gensmedet/docs/PICCOLINE_Myresnak_mar1985.pdf` — the "KLAR TIL
  MYRESNAK" screen has a centred turtle triangle (△). It now renders.
- Run: `./myresnak.sh` (workspace root) — boots `30004078.imd` directly into
  Myresnak. `--debug` for the MAME debugger.
- Empirical method that cracked it: instrument the `I82730_UPDATE_ROW` callback
  to dump `data[]` — it revealed ASCII codes, not pixels. When a display format
  is unknown, DUMP the row buffer; do not guess from docs.

## Handover / open items

- MAME changes committed on branch `rc759-82730-graphics` in `ravn/mame` (fork).
- Interactive drawing pages (KASSE/FIRKANT/circles, manual pp.12/29-32) not yet
  visually verified — a GSX-86 test disk reportedly exists at
  `scratch/rc759-gsx-test/` (GRAPHICS.CMD, SCRN*.CMD demos) worth trying.
- `m_gfx_mode` / `set_gfx_mode` (PPI bit6 plumbing) is now dead for rendering;
  can be removed later (also referenced by sibling `rc750.cpp` — check first).
