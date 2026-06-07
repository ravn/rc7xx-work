# Handoff 2026-06-07 — Fix A MERGED, full oracle green (incl. test_27 on macbook)

Host: macbook. Branch state: `avr-style-wide-access` merged to `main` via `--no-ff`,
pushed to origin. Commits on main:
- `e2f66fa2658d` — Merge Fix A
- `1b7be46a07c0` — test_27: fix typo (ref_asc target was @buf2, should be @ref2)

## Macbook oracle (ALL PASS)

- Lit: 149 PASS + 4 XFAIL (was 143+4 baseline).
- test-runner clang: 1092 tests, 836 PASS / 0 FAIL / 0 FATAL / 256 SKIP.
  test_223_wide_copy_block_move 6/6 PASS.
- AES 13-config sweep: byte-identical, tstate-identical. Fix A doesn't fire on AES.
- Production byte-compare (cpnos, BIOS, autoload): byte-equivalent to main modulo
  banner timestamps + 1 pre-existing BIOS BSS-address non-determinism (1351/1485,
  `LD HL,$EC??`); confirmed by main-vs-main rebuild showing same 75-byte diff.
- llc test_27_wide_copy_overlap O0+O1 PASS — Fix A's LDDR/LDIR direction is
  correct in both overlap directions. Initial failure was a test typo, not codegen.

## CI status: Actions DISABLED at the repo level (intentional)

`gh api repos/ravn/llvm-z80/actions/permissions` → `{"enabled":false}`.  Disabled
2026-04 (timeframe TBC) because stuck processes could run very long and burn
runner minutes.  Local oracle is the gate.

The Z80 backend CI workflow (`.github/workflows/z80-ci.yml`) still defines
`build-and-lit` + `runtime-tests` jobs and remains `state=active` on the
workflow object — re-enable Actions to use them.  When/if reactivating:
- `gh api -X PUT repos/ravn/llvm-z80/actions/permissions -f enabled=true -f allowed_actions=all`
- Stuck workflow_dispatch run 27100367803 (queued since 17:58:53 UTC on the
  merge commit, won't cancel via API: HTTP 500) will then either start or
  expire; either is harmless.

## llc-suite plumbing on macbook (RESOLVED this session)

Macbook had no native sdasz80/sdar/sdldz80/makebin (no SDCC bundle).  Built a
small `sdcc-tools` Docker image (`ubuntu:24.04` + `apt install sdcc
sdcc-libraries`) and installed wrapper shims in `~/.local/bin/`:

```
sdcc-tools image: Dockerfile is `FROM ubuntu:24.04 / RUN apt-get install -y sdcc sdcc-libraries`
Wrappers: ~/.local/bin/{sdasz80,sdar,sdldz80,makebin}
  → docker run --rm --platform linux/amd64 \
      -v /Users/ravn/z80:/Users/ravn/z80 \
      -v /tmp:/tmp \
      -w "$PWD" \
      sdcc-tools <tool> "$@"
```

Same-absolute-path mount is essential — cmake-generated absolute paths must
resolve inside the container.

After `cmake -B build-macos -S llvm` (re-detects), `ninja Z80Runtime` builds
both ELF (`z80_rt.a`) and SDCC (`z80_rt.lib`) archives.

z88dk does NOT ship these binaries: it provides its own `z80asm` and
`z88dk-zsdcc` at the same layer (different object format).  The compiler-rt
builtins are written in sdas syntax, so the raw SDCC tools are what we need.

## Memory rule updates this session

- `feedback_avr_density_oracle` — added macbook caveat: build-macos/bin/ now
  targets Z80;SM83;AVR;MSP430.  Caveat: AVR codegen on macbook goes through
  the llvm-z80 middle-end fork (carries the Argument-leaf TruncInstCombine
  patch etc.); for pure-upstream evidence use sonnyboy or hand unnarrowed IR
  directly to `llc -mtriple=avr`.

## Task list state at handoff

- #1-#7 completed.  Fix A is in main, full local oracle green.
- #8 pending: simavr-based AVR runtime oracle (user-requested follow-up).

## Next session(s)

1. Fix B (#27 IDX pseudos extend to 16-bit limbs) — generic wide-limb win for
   i32/i64/float arithmetic.  Keep behind `-z80-idx-addr`.  Measure AES.
2. icmp-narrow-soundness-tests decision (revert vs sound gate).  Failing matrix
   already on branch `icmp-narrow-soundness-tests`.
3. ravn/llvm-z80#217 fix (Bug 1: caller-contract restoration).
4. Upstream drafts 3/4/5: per AVR triage, recommend NOT filing 3, hold 4,
   decide 5 after the icmp-narrow decision.
5. Task #8: simavr-based AVR runtime oracle.

## Open trackers (not blockers, worth noting)

- BIOS build non-determinism at bytes 1351/1485 — pre-existing, swaps two BSS
  addresses between rebuilds.  Not a Fix A regression but should be filed as
  its own issue (deterministic-build hygiene).
