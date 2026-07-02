---
name: COMAL80 language reference manual (RCSL 42-I-1758)
description: RC700 COMAL80 keyword-reference PDF at datamuseum Bits:30000018 (Dec 1981, older than disk rev 1.07)
type: reference
---
The RC700 **COMAL80 language** is documented keyword-by-keyword in
*Comal80 Programmerings vejledning*, **RCSL 42-I-1758**, Jørgen Hansen,
December 1981 — datamuseum **[Bits:30000018](https://datamuseum.dk/bits/30000018)**
(159-page scanned PDF, no text layer → render pages with `pdftoppm` to read).
Table of contents on PDF pages 3–4 lists every keyword A–Z with its page.

**Version note (matters for the COMAL disk work):** this Dec-1981 manual is an
**older COMAL80** than the rev-1.07 runtime on the education disk (Bits:30003268).
It documents the base language and has **no `CHAIN` and no `EXTERNAL`/`.EXT`**
entry.  Language evolution seen: base 1981 (no CHAIN/external) → rev 1.07 1983
(has CHAIN; `logon` uses it) → the `.PRG` apps (`RACE`, `FUTTOG`, …) that use
**external procedures** (`CHRHENT.EXT`) need a still-newer COMAL80.  This is why
rev 1.07 cannot `LOAD`/`CHAIN` those `.PRG` files (`error 0214`).  Full analysis:
`rc700-gensmedet/docs/RC702_COMAL_SEM702_CHARSETS.md`.
