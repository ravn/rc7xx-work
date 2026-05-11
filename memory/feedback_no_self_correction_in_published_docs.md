---
name: No self-correction text in published docs
description: When drafting docs/specs, drop self-correction asides ("Wait, that's wrong, let me re-read...") before commit; narrate aloud in chat but publish only the final version
type: feedback
originSessionId: d49656b8-663b-4e0e-91a6-0a48af163349
---
When writing structured documents (specs, READMEs, docs/*.md, timeline
entries) DO NOT leave stream-of-consciousness self-corrections in the
final committed text.  Even when the corrected version follows
immediately, the leading "wait, that's wrong" aside undermines the
doc's authority and confuses readers who don't share the writer's
debugging context.

**Why:** Caught 2026-05-10 in `cpnos-rom/CPNET_WIRE_PROTOCOL.md` — the
spec doc for CP/NET wire protocol leaked "Wait, that's wrong. Let me
re-read..." into a published reference document.  User flagged.
Required a follow-up commit (`78505d8`) to remove it cleanly.

**How to apply:**
- Narrate self-checks aloud in the chat (per `feedback_show_thinking`),
  not in the file you're about to commit.
- Before saving any structured doc, scan for: "wait", "actually",
  "let me re-read", "hmm", "no, that's wrong", "let me reconsider".
  These are deliberation markers that don't belong in published
  artifacts.
- If you DO catch a mistake mid-draft, REPLACE the wrong text — don't
  leave both versions side-by-side with an apologetic transition.
- For technical docs, this rule is stricter than for casual writing
  because the doc becomes the authoritative reference; readers cite
  it without re-checking.
