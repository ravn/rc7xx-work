---
name: fingerprint-build-after-two-no-change-edits
description: After two consecutive edits show no observable behaviour change, stop and fingerprint the build (unique string / deliberate crash / OUT to side channel) before editing again — the build/install pipeline is probably stale.
metadata:
  type: feedback
---

After two consecutive source edits that ought to change behaviour but
produce no observable change (same wire trace, same output, same error
code), **STOP editing.** Do not make a third edit. Instead, fingerprint
the build with something undeniable — a unique magic string in `.rodata`,
a `mvi a,'X'; out N` to a host-visible port, a deliberate `halt` — and
prove that bytes from the new build are actually executing. Only resume
editing after the fingerprint shows up.

**Why:** session 2026-06-10 burned 6+ edit/test cycles tracking a "bug"
in CP/NET FNC 105 dispatch. SERVER.RSP source was rebuilt, byte-compared
to the disk copy (matched), reinstalled via `cpmcp`. Every test showed
the same `FF 0C` wire reply. After eight rounds of "edit val0 / val1 /
sndbak / fnctab / fncptr" with no change at all, I finally added 8
`OUT 3` instructions across the dispatch path and verified that
`printer.txt` was never created — proof none of my bytes were running.
The actual cause was that MP/M II bakes SERVER.RSP into `MPM.SYS` at
GENSYS time; editing `server.rsp` on disk is inert until `MPM.SYS` is
regenerated. The user couldn't have told me this (they didn't know
either); but the *general* fingerprint rule would have surfaced it in
2 cycles instead of 8.

**How to apply:**

- **Trigger:** two consecutive non-trivial edits produce byte-identical
  outputs (same length, same content, same error code). One iteration
  with no change is normal noise — two is a signal.
- **Especially strong signal:** the running behaviour matches the
  *pre-edit* source exactly (same fold, same opcode lookup, same error
  payload). That's "I'm running the old binary" in neon.
- **Action:** before edit #3, choose a fingerprint that's easy to
  detect from outside the system. Options in order of preference:
  1. Side channel the host can read directly (printer port → file,
     stdout via host BDOS, an `out` to a logged port).
  2. Unique string in the binary, grep both the build artifact AND the
     loaded image / system file for it.
  3. Deliberate behavioural break (different SIZ, different reply
     bytes, a deliberate hang) that's unmistakable on a wire trace.
- **Don't trust prior-session "Solved:" notes blindly** — if the prior
  rebuild/reload worked, my third edit should propagate too. If it
  doesn't, re-verify the pipeline rather than re-trusting the note.

See [[reference_mpm_sys_baked_via_gensys]] for the specific build trap
this rule was forged from, and `cpnet/REBUILDING_MPM_SYS.md` in the
rc700-gensmedet repo for the project-level writeup.
