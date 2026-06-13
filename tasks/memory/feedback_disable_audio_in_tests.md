---
name: feedback-disable-audio-in-tests
description: For RC700 MAME tests, ALWAYS pass `-sound none` to MAME. The motor sounds annoy the user, the beep is unnecessary, and CoreAudio's pipe semantics cause SIGPIPE crashes (exit 141) under sustained background-test load. No exception unless the test explicitly evaluates audio output.
metadata:
  type: feedback
---

For ANY MAME invocation against an rc702 / rc702mini / rc703 / rc702sem702 machine in a test or instrumented run, pass `-sound none` to MAME.

**Why:**
1. **The user dislikes the audio.** RC702 motor sounds (FDC seek + spin samples) and the system beep are noise. Quoting the user (2026-06-13): *"it has motor sounds (I strongly dislike those) and a beep which we can do without for now."*
2. **CoreAudio causes intermittent SIGPIPE (exit 141) crashes** under sustained-load background-tests. Observed during `cpnos-polypascal-test-trace` with LOG=1 + debugger trace: MAME exits at ~1 sim sec with exit code 141 even with stdin closed. `CoreAudio: Sink graph created` followed by audio-buffer activity correlates with eventual SIGPIPE.
3. **No audio test exists in this project.** Every test we run looks at SIO-B output, screen/video capture, or trace files. None looks at audio. So `-sound none` loses nothing.

**How to apply:**
- Default `-sound none` in `cpnos-shared/scripts/mame_capture.sh` (universal for every `mame_capture.sh`-launched run).
- Direct MAME invocations in scripts/Makefiles: add `-sound none` to the args.
- Exception: ONLY skip `-sound none` if the test explicitly captures + evaluates audio output. None exist today.

**How to verify:** A passing test should NOT show `CoreAudio: Sink graph created successfully` in its output. If you see that line, the test forgot `-sound none`.

Related:
- [[feedback_mame_full_speed]] — `-nothrottle` (companion: removes throttle, often combined with `-sound none`).
- [[feedback_mame_windowed_only]] — `-window` (companion: never fullscreen for tests).
