---
name: MYRESNAK supports colors — oracle for RC759 color screen (>2 values)
description: MYRESNAK (Danish Logo turtle graphics on RC759/Piccoline) renders in color; use it as a differential oracle for future RC759 color-screen work with more than 2 color values. (User fact 2026-08-30.)
metadata:
  type: reference
---

**User fact (2026-08-30):** MYRESNAK supports colors. This is to be used later
as an **oracle for RC759 color-screen work with more than 2 color values**.

Why this matters: most RC759 display verification so far has been on the text /
2-value graphics path (82730 char-gen framebuffer, `reference_rc759_82730_graphics.md`).
When we later exercise a color screen with a palette of >2 values, MYRESNAK is a
known-good, HW-era program that actually drives colored output — so its rendered
drawings give an independent reference to check the color path against, rather
than only trusting our own emulation of it.

Concrete hooks:
- MYRESNAK pen/fill colors are selectable from the turtle vocabulary (e.g.
  FARVE / pen-color commands: BLA, GRØN, HVID, RØD, SORT etc. — confirm exact
  keywords against `rc700-gensmedet/docs/MYRESNAK_programoversigt.md` and the
  manual `PICCOLINE_Myresnak_mar1985.pdf` before relying on specific names).
- Disk: `scratch/rc759-cmd-toolchain/30004078.imd` (MYRESNAK.CMD + 10 `.MYR`
  programs). Headless-run recipe + capture harness documented in
  MYRESNAK_programoversigt.md ("Kørsel og interaktiv indtastning i MAME").
- The 82730 BB/HENT/HUSK freeze fix (ravn/mame, branch `rc759-82730-graphics`,
  commit `2a4b21cdbdb`) is a prerequisite for driving MYRESNAK to the point of
  drawing; keep it in the build when using MYRESNAK as an oracle.

Status: fact recorded for future color-screen work; no color oracle built yet.
