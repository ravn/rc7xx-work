# Bug 4 unpark plan — investigation findings and concrete steps

**Authored 2026-06-15** after a careful re-read of the bug 4 artifacts:
`draft-bug4.md`, `rfc-icmp-narrow-outside-user.md`,
`issue-165-trunc-outside-user.ll`, `avr-triage-2026-06-07.md`,
`llvm-z80/tasks/session-2026-06-08-clang-vs-sdcc-speed-investigation.md`,
`tasks/memory/project_aes_kr_speed_gap_accepted.md`, and the current
`llvm/lib/Transforms/AggressiveInstCombine/TruncInstCombine.cpp` on
`llvm-z80/main`.

## Headline finding: the production fix is already in the fork

The TruncInstCombine extensions that bug 4 proposes — `#160` sound
version of icmp narrowing through the graph + `#165` and-mask
outside-user path — **already ship in `llvm-z80/main`**.  Commits:

- `fa1606f34c6b` — `[AggressiveInstCombine] icmp-narrow-through-graph: sound version`
- `c4f52eb17a76` — `[AggressiveInstCombine] icmp-narrow v2: add and-mask outside-user path`

Production wins from these are already accruing.  rcbios at 5462 B and
cpnos at 2015 B today include the bug-4 deltas in their accumulated
backend-gain history.  Verified by running the repro against
`llvm-z80/build-macos/bin/opt -passes=aggressive-instcombine` on
2026-06-15: `and_mask_outside_user` narrows cleanly; the sound gate
correctly denies `icmp_nonconst_outside_user` because `%x` is
unrestricted (proving `%add` fits in 16 bits is impossible from
KnownBits alone).

**Implication:** "fix bug 4 in the Z80 backend" has no remaining content
— the fix landed.  What's HOLD on task #4 is the **upstream filing**,
not the implementation.

## The two HOLD conditions, reconciled

From `STATUS.md` row 4: *"micro-shapes equalise on AVR; the gf_log-scale
claim is untested there AND our Z80 numbers are contaminated by the
icmp-narrow soundness gate until the gate-fix + re-measure"*.

- **"icmp-narrow soundness gate"** — the `canNarrowIcmpThroughGraph`
  KnownBits gate.  It's doing the right thing (denying unsound
  narrowings).  Earlier in this thread I read "gate-fix" as
  "make the gate less conservative" — that was wrong.  The gate is
  correctness; bypassing or weakening it produces miscompiles
  (witnesses `test_220` / `test_221` / `test_222`).
- **"gate-fix and re-measure"** more likely refers to the work to
  separate bug 4's clean delta from the **CVP-strips-narrowness-marker
  issue** (the AES +51 % speed gap, accepted per
  `tasks/memory/project_aes_kr_speed_gap_accepted.md`).  Today's
  Z80 numbers reflect both effects; the bug 4 RFC needs numbers that
  reflect only bug 4.
- **"AVR re-triage"** — the 2026-06-07 AVR triage was on the *micro-
  shapes* in `issue-165-trunc-outside-user.ll`, where AVR equalised.
  The 2026-06-08 speed investigation (Z80) shows AVR's
  AggressiveInstCombine Phase 2 narrowness signal *survives* CVP and
  fires the gf_log narrowing — but no one has measured the AVR gf_log
  size delta directly.  That's the gap.

## The CVP-strip issue is NOT bug 4

This is the key reframe.  The CVP-strips-narrowness-marker issue is:

- A separate concern (`AggressiveInstCombine` **Phase 2** synthetic-
  trunc-root narrowing, not the **Phase 1** outside-user logic that
  bug 4 fixes)
- A separate draft (`tasks/upstream-5bug/draft-cvp-strips-narrowness-marker.md`)
- Already triaged via 5 options; option (1) ACCEPTED per memory note
- Not on the four-finishing-component critical path

Conflating it with bug 4 in the original HOLD note is what made my
earlier "TTI hook" proposal look attractive but actually wrong.  Bug 4
and the CVP-strip issue need to be tracked separately or one will
contaminate the other's measurements.

## The plan: four phases, ~4-5 h of focused work (was ~3-4 h before
adding the simavr cycle oracle to Phase 1)

### Phase 1 — AVR gf_log-scale oracle (~2-2.5 h)

**Goal:** answer the question "does the bug 4 fix help AVR at the
gf_log scale, not just on the micro-shapes?" — measure both **size**
(primary) and **execution cycles** (secondary, hardening the upstream
RFC against "but the cycle count didn't shrink" review challenges).

**Method:**
1. Locate the gf_log K&R helper source (`tasks/aes256-corpus/` or
   `compiler-comparison-corpus/`).  The 2026-06-08 investigation
   prepared a `/tmp/gflog_kr.c` repro; that or an equivalent.
2. Build under `clang --target=avr -mmcu=atmega328p -Os` against
   current llvm-z80 main.
   - Note `avr-size` output (`.text` bytes of the helper function).
   - Check the IR (`-emit-llvm -S`) to confirm the icmp-narrow path
     fires (look for narrowed icmp + zext rewrite).
   - Disassemble (`avr-objdump -d`) to confirm the codegen shows
     narrower ops in the hot loop.
3. **Cycle-count fixture (simavr).**  The repro becomes a self-
   instrumenting AVR program:
   - main() loops the gf_log helper N times (N chosen so the run is
     ~1-2 simavr-seconds: enough samples to amortise per-call
     overhead).
   - Output two bytes to a probe port at start + end of the hot loop,
     letting simavr's existing `avr_cycle_count` accessor capture
     before/after deltas.
   - Add it to `tasks/upstream-5bug/avr/Makefile` as a new target
     `gf_log-cycles` following the existing `bug2-test` / `bug4-test`
     docker-shim pattern (HARD rule `feedback_docker_shim_batch`:
     link + simavr in one `sh -c` invocation).
4. **Baseline:** revert `c4f52eb17a76` + `fa1606f34c6b` locally on a
   throwaway branch `bug4-avr-baseline` (don't push), rebuild AVR
   clang, rebuild gflog_kr.
   - Note `avr-size`, IR shape (confirm icmp-narrow path is gone),
     cycle count from the simavr fixture.
5. Restore main (`git checkout main`); rebuild clang.
6. Document the deltas in
   `tasks/upstream-5bug/avr-triage-2026-06-07.md` as a "2026-06-15
   gf_log-scale addendum" section.  Record: size delta (bytes), cycle
   delta (count + percent), IR shape change (with/without).
7. Optional belt-and-braces: spot-check the cycle fixture's
   correctness by also running it under z88dk-ticks on Z80 (same
   source, same loop count), to confirm the Z80 path delivers the
   long-claimed 5.4× speed win at scale.  If Z80's cycle delta
   matches the 4× claim in the RFC, the AVR oracle's methodology is
   validated by mirror-symmetry.

**Expected outcomes:**
- AVR shows a comparable gf_log-scale delta in **both size and
  cycles** → upstream story is strong; proceed to Phase 2.
- AVR shows a size delta but no/marginal cycle delta → upstream story
  is still credible (size-only on flash-constrained 8-bit targets is a
  defensible RFC framing), but reviewers may push back; consider
  filing with explicit "size primary, cycles secondary" framing.
- AVR shows no gf_log-scale delta on either axis → bug 4 stays fork-
  internal at `ravn/llvm-z80#219`; close task #4 with that verdict;
  the production fix already shipped on Z80.

### Phase 2 — clean Z80 measurement of bug 4's isolated delta (~1 h)

**Goal:** numbers that separate bug 4's contribution from the CVP-strip
speed gap.

**Method:**
1. On a temporary branch (don't push), revert `c4f52eb17a76` +
   `fa1606f34c6b`.
2. Rebuild rcbios + cpnos + the AES corpus (`tasks/aes256-corpus/`)
   with the reverted compiler.
3. Record sizes + speeds (tstates via z88dk-ticks) for each.
4. Restore the commits; rebuild; record.
5. The delta is bug 4's clean Z80 win.

**Important:** the speed regression vs SDCC (+51 % on AES K&R) is the
*CVP-strip* issue, not bug 4.  The bug 4 measurement should report its
own clean delta against the no-bug-4 baseline, not against SDCC.  The
CVP-strip issue is separately noted and explicitly out of scope.

### Phase 3 — RFC update with clean evidence (~30-45 min)

**Goal:** refresh the RFC at `tasks/upstream-5bug/rfc-icmp-narrow-outside-user.md`
with Phase 1 + Phase 2 numbers.

**Edits:**
1. Update §"Evidence / Z80 (positive)" to use the clean delta from
   Phase 2 (current main → without-bug-4 baseline).  The existing
   `09_Oz_prod_like` 2866 → 2581 B reference predates the CVP-strip
   discovery and may overstate or understate the bug 4 contribution
   specifically.
2. Update §"Evidence / AVR (positive cross-target witness)" — currently
   cites the *soundness probe* (whether unsound narrowing returns
   `0x05` vs `0x63`).  Replace or extend with the gf_log-scale size
   delta from Phase 1.
3. Add an explicit "what bug 4 does not address" section noting that
   the AES K&R +51 % speed gap is a *separate* CVP-strip issue, not a
   bug 4 limitation — so reviewers don't conflate the two.

### Phase 4 — file or close (~1 h + user verdict)

**Per `feedback_explain_before_filing`:** get explicit per-filing
user go-ahead before posting anywhere.

**Two outcome paths:**

- **AVR positive (Phase 1) → file.**
  - Post RFC on LLVM Discourse (`RFC` tag, IR category)
  - Mirror summary at `llvm/llvm-project` issue, reference the
    Discourse thread
  - Optionally file a tests-only PR (per engagement-mode rule, never a
    fix PR)
  - Close task #4 once filed; monitor for maintainer response

- **AVR negative (Phase 1) → don't file upstream.**
  - Update `STATUS.md` row 4 with the verdict: bug 4 was Z80-specific
    in scale, not just micro-shape
  - Keep the fork-internal `ravn/llvm-z80#219` open as a "documented
    fork extension" record
  - Close task #4 with the don't-file verdict
  - The production fix continues to deliver on Z80; the only loss is
    not getting the same fix accepted upstream for cross-target benefit

## Risks and edge cases

1. **Phase 1's revert/rebuild AVR cycle.** Needs clean git hygiene.
   Recommend a local branch (`bug4-avr-baseline`) created from current
   main, with the two commits reverted; switch back to main for the
   "with" measurement.  Don't push the baseline branch.
2. **gflog_kr.c may not exist as a standalone repro.**  If
   `/tmp/gflog_kr.c` from the 2026-06-08 investigation is gone, we'll
   need to extract the K&R loop from the AES corpus source or write a
   minimal repro that exhibits the same outside-user icmp pattern at
   gf_log scale.
3. **AVR build availability.**  llvm-z80's build cache enables Z80
   only by default (`clang/cmake/caches/Z80.cmake`).  May need a
   separate build with AVR enabled (one-time cmake config); the
   AVR backend is upstream-LLVM standard, so this should work.
4. **simavr cycle-fixture overhead.**  simavr ramps up the AVR core
   for each `simavr` invocation; per-call overhead is ~a few thousand
   cycles before main() reaches the gf_log loop.  Choose the loop
   count N so the hot-loop cycle budget dwarfs the startup overhead
   by at least 50× (≈ 100k+ hot-loop cycles).  The probe-port
   bracketing in the fixture isolates the hot loop's cycles from the
   startup, so this is belt-and-braces.
5. **simavr cycle precision.**  AVR cycles are deterministic (no
   pipeline, no cache), so simavr's cycle count is exact to within ±1
   for cleanly-bracketed loops.  No statistical sampling needed.
   simavr reports cycles via `avr->cycle` accessible from the C
   instrumentation in the test harness.
4. **The Phase 2 measurement may show small bug-4 delta on rcbios /
   cpnos.**  The big visible wins (5905 → 5462 B over six weeks) are
   accumulated multi-pass; bug 4's individual contribution may be a few
   bytes only.  This doesn't invalidate the upstream story — the
   gf_log K&R shape is the headline, not BIOS aggregate.
5. **CVP-strip contamination of any AES measurement.**  Even with bug
   4 reverted, the +51 % speed gap remains.  Report bug 4's *size*
   delta to avoid muddling.

## What this plan deliberately does NOT do

- Fix the CVP-strip speed gap (accepted per memory note, off the
  critical path).
- Touch the soundness gate (working correctly).
- Add new TTI hooks (no Z80-only fix has remaining content; the fix
  already shipped on every target where the source pattern triggers
  it).
- File any LLVM issue before user go-ahead per
  `feedback_explain_before_filing`.

## Tracking

This plan supersedes the retired task #14 (TTI hook) and provides the
unpark path for task #4.  When Phase 1 begins, set task #4 to
in_progress; when Phase 4 completes (file or close), mark task #4 done.
