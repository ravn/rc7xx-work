---
name: COMAL80 language reference manual (RCSL 42-I-1758)
description: RC700 COMAL80 keyword-reference PDF at datamuseum Bits:30000018 (Dec 1981, older than disk rev 1.07)
type: reference
---
The RC700 **COMAL80 language** has two datamuseum manuals, and the version gap
between them explains the COMAL-disk `.PRG` puzzle:

- **Comal80 Programmerings vejledning**, RCSL 42-I-1758, Jørgen Hansen, **Dec 1981**
  — [Bits:30000018](https://datamuseum.dk/bits/30000018).  Keyword-by-keyword
  reference (TOC on PDF p.3–4).  **No `CHAIN`, no `EXTERNAL`/`.EXT`** — base language.
- **RcComal80 Brugervejledning**, RCSL 42-I-2339, Niels Bach, **June 1983**
  — [Bits:30008320](https://datamuseum.dk/bits/30008320).  Structured user manual;
  **documents external procedures in §8.5 "Externe procedurer" (p.76–77)** (an
  external proc must be `CLOSED`, lives in its own file, forms a "procedurebibliotek").

Both are 159/large scanned PDFs with **no text layer** → render pages with
dockerised `pdftoppm` to read.

**Language evolution (drives the COMAL-disk work):** base 1981 (no CHAIN/external)
→ education-disk `comal80 rev 1.07` 1983 (has CHAIN; `logon` uses it; runs plain
programs) → `.PRG` apps (`RACE`, `FUTTOG`, `TEGNGEN`) that use **external
procedures** (`CHRHENT.EXT`) need the external-capable **RcComal80** (the 1983
manual's line).  That is why rev 1.07 cannot `LOAD`/`CHAIN` those `.PRG` files
(`error 0214`).  Extracted files: `rc700-gensmedet/sem702-comal/`.  Full analysis:
`rc700-gensmedet/docs/RC702_COMAL_SEM702_CHARSETS.md`.
