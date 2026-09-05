# RC759 Piccoline graphics mode — SOLVED (2026-08-30)

Status: **working and verified**. MYRESNAK (Danish Logo turtle graphics)
renders correctly in MAME. This supersedes the guess-laden plan in
`tasks/plan-gsx-86-rc759-graphics-2026-08-29.md` (Mistral's), which should be
treated as historical.

## The oracle (independent, from the manual)

`rc700-gensmedet/docs/PICCOLINE_Myresnak_mar1985.pdf` (Release 1.2, Apr 85;
SHA256 4f25304230fb…). The "KLAR TIL MYRESNAK" ready-screen shows a centred
turtle triangle (△ "myren"). That triangle is the pass/fail oracle — it now
appears. Evidence captured in `scratch/rc759-graphics-result/`:
- `myresnak-klar-triangle.png` — graphics screen, correct (△ centred).
- `piccoline-text-boot.png` — text screen still correct (no regression).

## How to run it

    ./myresnak.sh            # interactive window
    ./myresnak.sh --debug    # start in the MAME debugger

The Myresnak disk `scratch/rc759-cmd-toolchain/30004078.imd` boots directly
into Myresnak (flop1); no CP/M system disk needed.

## Root cause (verified, not guessed)

The **Intel 82730 is a pure text coprocessor — it has NO native bitmap
graphics plane.** (Datasheet `mame/docs/i82730_datasheet.pdf` mentions
"graphics" only on the cover.) Even in Myresnak's "graphics" screen the display
list feeds **character codes** in the row buffer, not pixels. Mistral's
`gfx_update_row` read `data[i] >> 8` as raw pixel bytes — fundamentally wrong,
hence the garble.

How the RC759 actually does graphics (the classic
programmable-character-generator-as-framebuffer trick):

1. The CPU loads a **different 82730 mode block** to switch layout. There is
   **no dedicated "graphics" bit** anywhere in the mode block (checked all 18
   words; `wdef/dbl_hgt/blk_row/rvv_row` are 0 in both modes). The distinction
   is the **cell geometry** the CPU programs:
   - text: 80 char/row, cells 10 scanlines tall (`lpr = 9`)
   - graphics: 35 char/row, cells 16 scanlines tall (`lpr = 15`)
   Both span the same **560 px** active field (`(hfldstp-hfldstrt)*16 = 35*16`),
   so cell pitch = `560 / chars_per_row` → **7 px** text, **16 px** graphics.
2. The CPU renders a **560×256** bitmap into the programmable character
   generator RAM (`m_vram`, at CPU `0xD0000-0xD7FFF`, mirror 0x08000) and tiles
   the screen with **unique cell codes = `(col << 4) | row`**, so every one of
   the 35×16 cells is a distinct 16×16 glyph. Rendering is then the ordinary
   font lookup `m_vram[(code<<4) | lc]`, MSB = leftmost pixel.

NB: PPI port C **bit 6** (what Mistral wired to `m_gfx_mode`) is **NOT** the
graphics indicator — it reads 0 throughout the graphics screen. That lead was
falsified.

## The fix (files under the `mame` submodule, uncommitted)

- `src/devices/video/i82730.h` — added accessor
  `uint8_t rows_per_char() const { return m_mb.lpr + 1; }`. This exposes the
  mode-block field the CPU sets, which is the real mode signal.
- `src/mame/regnecentralen/rc75x.cpp`
  - `txt_update_row`: detect graphics by `m_txt->rows_per_char() >= 12`
    (text=10, graphics=16) and delegate to `gfx_update_row`. Replaced the old
    `m_gfx_mode` (PPI bit6) routing, which was wrong.
  - `gfx_update_row`: render `cell_w = 560 / x_count` (=16) full-width bits per
    cell from the font word; no proportional-width guard, no zero-low-byte skip
    (those bytes are pixel data in graphics).
- `src/devices/video/i82730.cpp` — `log(` → `LOG(` in `set_gfx_mode` (macro
  fix; the function is otherwise legacy).

Build (fast incremental, ~30 s):

    cd mame && make SUBTARGET=regnecentralen REGENIE=1 \
        SOURCES=src/mame/regnecentralen/rc759.cpp OSD=sdl -j10

Binary: `mame/regnecentralen` (newest mtime; not the stale `regnecentralend`).

## Cleanup done

Removed all debug scaffolding from the working tree (mine + Mistral's):
`/tmp` PPI/mode/row logging, `<fstream>/<iomanip>`, the `fprintf` and the
duplicated NVRAM-defaults / bit-18 override in `machine_start` (reverted to the
clean HEAD version), and stray untracked files (`plugins/debug_ppi.lua`,
`scripts/premake.lua`, `scripts/base/premake.lua`). `git status` in `mame` now
shows only the three intended source files changed.

## Handover / open items

- Not yet exercised: the interactive **drawing pages** (KASSE/FIRKANT/circles,
  manual pp. 12/29-32). The ready-screen △ proves the pipeline; drawing needs
  keyboard interaction. Worth a follow-up visual check. → ravn/mame-rc702-rc759-rc750#29.
- Cell width is computed `560 / x_count`; if any RC759 program uses a third
  layout this stays correct as long as the active field is 560 px.

## Session 2026-08-31 — screensaver + dead code (all merged to ravn/mame-rc702-rc759-rc750 master)

- **Dead code removed**: `m_gfx_mode`/`set_gfx_mode` (ravn/mame-rc702-rc759-rc750#30 CLOSED)
- **Myresnak BB/HENT/HUSK freeze**: frame-interrupt fix `2a4b21c` verified
  working (ravn/mame-rc702-rc759-rc750#31 CLOSED)
- **Screensaver garbage (ravn/mame-rc702-rc759-rc750#28 CLOSED)**: root cause — two mechanisms:
  1. EOF (0x81) at top of list-1 row-0 string blanks the field — was ignored
  2. `blk_row=1` in status-row FULROWDESCRPT blanks status line — was ignored
  Both fixed in `6352f80`: `m_eof_hit` flag + `blk_row` check + black fill
  at `y - m_mb.vsyncstp` (bitmap coordinate pitfall).
- **Boot status-line "sære tegn"**: same blk_row fix eliminates it.
- New issues filed: #33 (rvv_row), #34 (CA bits), #35 (field_attr_mask),
  #36 (Intensify/palette), #32 (NVRAM L-parameter mapping).
- Branch `rc759-82730-graphics` merged to ravn/mame-rc702-rc759-rc750 master (`d96b498`).
- Boot screen verified correct after all fixes (snapshot 0153.png).
