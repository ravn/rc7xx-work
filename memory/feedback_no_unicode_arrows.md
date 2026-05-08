---
name: Avoid Unicode arrows in output
description: Use ASCII arrows (-> <-) not Unicode (→ ←), they overlap following characters in user's terminal
type: feedback
originSessionId: 57254a72-8bad-4840-ab6e-f5fbc35df805
---
**Rule:** Use ASCII `->` not Unicode `→` in chat output (and anywhere else that renders in the user's terminal, including code comments rendered in code blocks).

**Why:** User reported 2026-04-16 in iTerm2 that `→` (U+2192) overlaps the first character of what follows — e.g., `FDC→CPU` renders garbled. Likely a font/width issue (character reported as 1-cell but glyph draws wider). Other arrow glyphs (`←`, `↑`, `↓`, `⇒`, etc.) may have the same problem.

**How to apply:**
- `->` instead of `→`
- `<-` instead of `←`
- `=>` instead of `⇒`
- Same in bullet lists, prose, tables, and source code comments.
- Safe Unicode in practice: box-drawing (│ ├ └), bullets (•), dashes (— –) — these have not been flagged.
