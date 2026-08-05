---
name: todo-zsdcc-issues-check-upstream-sdcc
description: TODO (later) — the 8 open ravn/z88dk zsdcc issues are upstream-SDCC problems; find the SDCC project and check whether they still reproduce on the newest SDCC before reporting upstream
metadata:
  type: project
---

**TODO, later (noted 2026-08-05).** The remaining pure-**zsdcc** open issues on
ravn/z88dk are SDCC-backend bugs (z88dk only bundles SDCC), so their home is
**upstream SDCC**, not the ravn/z88dk fork — per [[no-local-zsdcc-fixes]].

**The task:** find the upstream **SDCC project** and check whether each still
reproduces on the **newest SDCC version** (several were filed 2026-05, SDCC may
have since fixed them). For each: if fixed upstream → close the ravn/z88dk issue
noting the fixing SDCC version; if still open → produce a minimal repro and
report upstream, then mark the ravn/z88dk issue won't-fix-locally.

**The 8 zsdcc issues (as of 2026-08-05):**
- #13 — ralloc.c:1190 defensive spillLoc clear suggests an underlying bug (blocks #10)
- #12 — candidate peephole `jr cc,lbl -> jr cc,target` (peep 84) miscompiles
- #11 — expand rematerialization to cover address arithmetic (cross-call spill)
- #10 — `--fomit-frame-pointer` falls back to full IX frame when spills survive a call
- #7  — block-scope `extern` decls don't emit GLOBAL symbol; z80asm rejects cross-TU call
- #6  — `-clib=sdcc_ix + --sdcccall 1` silently miscompiles AES-256 (wrong ciphertext)
- #2  — const-qualified 16-bit pointer uses byte-wise load instead of `LD rr,(nn)`
- #1  — block-scoped variable undefined in deeply nested code (`--std-c11`)

**Why not now:** out of scope for the z80_smallc session; batched as a separate
upstream-SDCC triage pass. **How to apply:** `no-local-zsdcc-fixes` (upstream
reports only, no local fork patches); the valuable artifact is a minimal repro
per bug against current SDCC trunk.
