---
name: feedback_verify_process_state_full_enumeration
description: "HARD — never assert 'nothing is running / clean' from a ps grep that matches only what you EXPECTED; enumerate fully and reconcile against the harness's own shell/task count, especially after a known runaway-class bug"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 37474951-7f75-44a2-bc39-c1f224708083
---

HARD. Sibling of [[feedback_audit_oracle_not_just_fix]] (verify with a check that
would actually FAIL if the claim were false) and the state-known-vs-guessed
discipline: this one is about **process / resource state specifically.**

**Trigger — when you are about to say "nothing is running", "no runaways",
"clean", "shell is idle", or otherwise assert the absence of live work.**

**Rule:** prove the negative with a check that would actually catch it.
- **Enumerate fully, don't expectation-grep.** A `ps | grep -E "<patterns>"` only
  proves "none of the things I LISTED are running." Use a bare `ps aux` (or sort by
  RSS/elapsed, or grep the build-dir PATH like `build-macos/`), so a process you
  didn't anticipate still shows up. The runaway is, by definition, the thing you
  weren't looking for.
- **Reconcile against the harness's own signal.** If the status line / task list
  says "1 shell" (the user sees it; you don't), treat that as ground truth and
  hunt the discrepancy — do NOT override it with your narrower `ps`. A missing
  completion notification for a task you launched is itself the tell.
- **A failed wrapper does not mean the wrapped command died.** `( ulimit ...; llc
  ... )` keeps running `llc` even when `ulimit` errors; seeing the error and moving
  on plants an orphan. Confirm the CHILD exited, not just that the line printed an
  error.
- **After a known runaway-class bug, assume an orphan until disproven.** If a bug
  already OOM-crashed the machine once (or caused an infinite loop), a process from
  that buggy-binary era can still be alive — rebuilding the binary file does NOT
  kill an already-running instance.

**Why:** in this session I twice said "nothing important is running" from a
`ps | grep` whose pattern omitted `llc` — the exact runaway. A buggy pre-fix
`llc` (garbage-K infinite loop from an ImmArg mistake) launched under a failed
`ulimit -v` had been spinning for **3h38m at 4.5 GB RSS**, headed for the same OOM
crash the user had already hit once. The user's status line showed "1 shell" the
whole time; I substituted my incomplete `ps` for that signal. Only when the user
asked "is the shell still running important?" and then "you have 1 shell" did a
wider grep (including `llc`) find it.

**How to apply:** before asserting idle/clean, run an UNFILTERED enumeration (e.g.
`ps -o pid,rss,etime,command -ax | sort -k2 -n | tail`), explicitly account for the
harness shell/task count, and `kill -9` any orphan. Phrase the conclusion as what
you actually verified ("ps -ax shows no build/emulator process > Xs old") not the
broad claim ("nothing is running").
