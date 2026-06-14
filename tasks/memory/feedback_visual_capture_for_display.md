---
name: feedback-visual-capture-for-display
description: HARD — any change that touches the display refresh path (CRT ISR, DMA refresh, 8275 cursor, display BSS region) requires a video / multi-frame visual verification.  Binary diffs and PASS lines do not catch display garble; only watching the display does.
metadata:
  type: feedback
---

Any change that touches code on the display refresh path — VRTC ISR,
8237 DMA channel 2 (display) or 3 (attribute), 8275 CRT controller
programming, display memory region (0xF800..0xFFCF), cursor position
writes — requires **visual verification via a multi-frame capture**
(MP4 from `scripts/mame_capture.sh` plus frame extraction, OR direct
screenshot at multiple stages of a test).

Reason: textual PASS conditions (test_runner returncode, "PASS:
PPAS PRIMES" in result file) verify FUNCTIONAL correctness but say
nothing about display correctness.  Binary diffs say even less — a
display-garble bug is by definition not caught by `cmp`.  A change
can flip display refresh from "working" to "broken-in-a-way-that-
makes-the-text-unreadable-but-still-runs" and the textual test
still passes because the BDOS layer doesn't care what's on screen.

**Why:** 2026-06-14 had a concrete instance.  Step 0 of #115 stripped
the per-VRTC DMA reload from cpnos's `isr_crt`, leaving 8237 autoinit
mode (0x5A, programmed in init.c) to handle refresh alone.  Textual
test PASS was easy: `cpnos-polypascal-test COMPILER=clang` completed
in 50.51 sim sec, "PPAS PRIMES ran to completion, 29989 primes
output, Q returned to E>".  That tells us BDOS / CP/NET / disk I/O /
character output all still WORK, but it does NOT tell us if the
characters were rendered correctly on screen.

The visual check (5 frames across banner / PPAS load / L PRIMES load /
mid-flood / late-flood) was the proof of correctness — autoinit was
actually carrying refresh as claimed.  Without the visual check, we
might have shipped a bug where the display fades / tears / freezes
after the first frame's worth of DMA terminal count, and the test
suite would still say PASS.

**How to apply:** when changing code on the display refresh path:
1. Use `scripts/mame_capture.sh <slug> -- ...mame args...` to capture
   the full test run as MP4.  Saved to `scratch/mame-videos/`.
2. After the test, extract 4-6 frames spread across the run via
   `docker run jrottenberg/ffmpeg:7-alpine -i <mp4> -vf "select=eq(n,N)+..." <pngs>`.
3. View each frame (`Read` the PNG) and verify text is crisp, no
   tearing, no garble, cursor position correct.
4. If any frame looks wrong, fail the change.  Textual PASS is NOT
   sufficient.

The cost is ~5 minutes for a clean run-with-capture.  The cost of
shipping a display bug that the textual test missed is much higher
(user discovers in actual use; repro is hard; "but the test passed"
is misleading).

Related: [[feedback_screenshot_to_verify]] (single-screenshot
variant for boot verification); [[feedback_black_screen_fatal]]
(extreme failure mode of unverified display change);
[[feedback_black_screen_crt_isr]] (debug path when the visual
check fails); [[feedback_display_addr_from_dma]] (related: trust
the DMA chip state, don't hardcode display behavior).
