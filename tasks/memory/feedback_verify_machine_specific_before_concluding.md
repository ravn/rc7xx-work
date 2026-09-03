---
name: Verify machine-specific facts before concluding; consult the authoritative memory map first
description: Before empirically probing a hardware question, read the machine-specific primary doc's memory map. Don't trust addresses a driver inherited from a sibling machine. When a search comes up empty, question the search bounds, not just the hypothesis. Name the machine-specific verified fact each conclusion rests on.
type: feedback
---
# Verify machine-specific facts before concluding

**Incident (2026-09-03, MAME rc750 Partner font):** I spent many turns concluding the Partner's
character generator font "wasn't loaded / needed a production boot-PROM dump," when the real 9x14 font
was sitting in the pixel memory at **0xF0000** the whole time (Partner Programmer's Guide §4.1.2). I had
that guide saved and never consulted its memory map; instead I trusted the MAME driver's inherited
`vram@0xD0000` (copied from the RC759 Piccoline), and my RAM dumps stopped at 0xDFFFF so I never saw
0xF0000. I then generalised from RC759 behaviour to the RC750. The user's correction — *"rc759 and rc750
are siblings, not the same machine; you cannot conclude anything for rc750 based on rc759"* — was exactly
right, and came only after I'd built on the wrong foundation.

**How to apply (in priority order):**
1. **Consult the machine-specific authoritative primary source FIRST** — especially its memory map /
   register map — *before* empirical probing. If I already have the doc (Programmer's/Service Guide),
   grep it for the address/mechanism before writing any probe. The answer is often one lookup away.
2. **Don't trust addresses/assumptions a driver (or my earlier note) inherited from a sibling machine.**
   Verify each against the target machine's own doc. `vram@0xD0000` was an RC759 value never confirmed
   for RC750.
3. **When a search returns empty, question the search BOUNDS, not just the hypothesis.** "The font isn't
   in RAM" was really "I didn't dump far enough / scanned unreliably." Check coverage before concluding
   absence.
4. **State the one machine-specific, verified fact each conclusion rests on, and where it was checked.**
   If asked to name it, "0xD0000 is empty" would have exposed itself as resting on an unverified,
   inherited address — sending me to the guide instead of down a multi-turn detour.

Siblings/variants (RC750 vs RC759, or any two machines sharing a base driver) can differ in exactly the
detail under investigation. Treat "same as the sibling" as a hypothesis to verify, never a premise.

**When a knowledgeable user asserts a mechanism and my evidence seems to contradict it, suspect MY
premise — and test THEIR claim directly.** In this incident the user said repeatedly "the boot PROM must
set the character set," and I kept effectively refuting it — because I had silently translated it into
"does the boot PROM write to 0xD0000?" (my wrong char-gen address), saw 0xD0000 empty, and concluded "no."
I was testing my own model, not their hypothesis. Their claim had one direct test — a **write tap during
POST to see where the boot ROM writes font data** — which I only ran at the very end; it confirmed them in
one shot (routine @F9CE2 -> 0xF0000). Rule: contradicting evidence against a system-savvy user almost
always means one of my premises is wrong, not that they are. Design the most direct test of the user's
stated mechanism *first*, before weighing it against conclusions built on an unverified assumption.

Related: [[feedback_check_memory_before_coding]], [[feedback_ask_about_design_decisions]].
