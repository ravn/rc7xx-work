---
name: Z80 backend work — staged collaboration model
description: Z80 LLVM backend work targets llvm-z80/llvm-z80 (active fork org parent of ravn/llvm-z80) FIRST via collaboration with its owner; submission to official llvm/llvm-project is a long-term aspiration contingent on reaching maturity
type: project
originSessionId: 986bb359-738f-4014-bfb2-add9f26e34f5
---
The compiler work in `/Users/ravn/z80/llvm-z80/` follows a **staged
collaboration model** clarified by the user 2026-05-02:

  > "I want to collaborate with the owner of the llvm-z80/llvm-z80
  >  project to reach maturity and then see if it can be submitted
  >  to the official project."

**Concrete near-term target: `llvm-z80/llvm-z80`.**  This is the
active org repo that is the GitHub parent of `ravn/llvm-z80` (last
push 2026-04-25 per upstream research).  Work here means:

  - Land changes in their repo via PR (not just our fork-only branch).
  - Follow whatever conventions they have (read their CONTRIBUTING,
    CODEOWNERS, README, etc.).
  - Quality bar is "owner of llvm-z80/llvm-z80 would accept this PR."

**Collaboration timing — IMPORTANT (user clarified 2026-05-02):**
Do **not** engage `llvm-z80/llvm-z80` (file upstream issues, open
PRs, comment on @zlfn's tracking issues, etc.) until **something
substantial is ready**.  Premature engagement wastes maintainer
attention on speculative directions.

Concretely, "substantial" means at minimum:
  - All correctness bugs (#28, #36, #38, #63, #81) closed locally,
    with lit tests proving each fix and no regressions.
  - A coherent next-direction story (e.g., regalloc cluster
    closed) ready to present as one body of work.
  - Test coverage that lets a reviewer evaluate the changes
    without re-running the full integration suite.

Until substantial: work happens entirely on `ravn/llvm-z80`
working branches.  Issue tracking stays on `ravn/llvm-z80`.  When
substantial is reached, batch-deliver to `llvm-z80/llvm-z80` —
open issues + PRs as a coordinated set, not piecemeal over weeks.

**Long-term aspiration: `llvm/llvm-project`.**  Currently NOT
achievable directly because llvm/llvm-project has no Z80 backend
(verified 2026-05-02).  Adding Z80 as a new experimental target
upstream requires:

  - RFC on LLVM Discourse with named maintainer and active community.
  - Multi-patch series, all LGTM'd by reviewers.
  - 3-month stability window for graduation from experimental.
  - Public buildbot infrastructure.
  - Organizational backing (M68k, CSKY, Xtensa precedents all had it).

This is a multi-year effort and is **explicitly deferred** by the
user until llvm-z80/llvm-z80 reaches maturity.

**Predecessor history (for context):**
  - `jacobly0/llvm-z80` is **archived** (2017); moved to
    `jacobly0/llvm-project` (z80 branch).
  - `jacobly0/llvm-project:z80` is **dormant** (last substantive
    commit 2023-11-16).
  - `llvm-z80/llvm-z80` org repo is the current active fork-of-
    interest.  Owner identity needs verification before outreach.

**What this means for code quality:**

  - LLVM coding standards still apply (clang-format, license headers,
    naming conventions, lit-test conventions) — both the near-term
    parent and the long-term destination expect this.
  - Architecture must use proper LLVM patterns (TableGen, GISel
    combiners, target hooks) over ad-hoc peepholes.
  - **Collaboration etiquette**: don't surprise the owner with large
    PRs.  Discuss direction first.  Each change should match their
    style and the existing codebase spirit.
  - Tests: lit `*.ll` IR fixtures with FileCheck.  No BIOS/cpnos-rom
    dependence in upstream-bound tests.

**What NOT to do:**

  - Do not file issues on `llvm/llvm-project` (per
    `feedback_no_upstream_issues.md`).  Issue tracking stays on
    `ravn/llvm-z80`.
  - Do not preemptively chase llvm/llvm-project submission while
    llvm-z80/llvm-z80 is the actual collaboration target.
  - Do not assume PRs to llvm-z80/llvm-z80 will be accepted without
    coordination — establish contact with the owner first.

**This memory supersedes the prior version (2026-05-02 morning) which
incorrectly stated official LLVM was the immediate target.**  The
staged model is the correct framing.

Pairs with `project_z80_backend_unfinished.md` (backend is
preliminary — finishing it is a precondition for either parent or
upstream submission).

**Sharpened goal (user 2026-06-07).**  Overarching objective:

  > "Get our work accepted upstream.  Upstream here means finishing
  >  the z80 backend and try to have it accepted with the llvm bugs
  >  that really are generic.  We also need to focus intensely then on
  >  identifying the underlying bugs in z80 and have them described
  >  in issues in a way that will get them accepted."

Implications:
  1. Tier II Z80 correctness sweep is the dominant priority — a
     backend with known miscompiles will not be accepted anywhere.
     Items: icmp-narrow soundness decision, #217 (Bug 1), #150
     residue, #159, #169/170/171, #136, #125, #2 inline-asm
     crash.  Close each one with [[feedback_no_commit_first_version]]
     discipline.
  2. Generic-LLVM bug filings go to llvm/llvm-project alongside
     the eventual backend submission.  Each one follows the
     [[feedback_file_bugs_not_fixes]] discipline: bugs, not patches.
  3. Z80-specific upstream issues are described in a way that
     would get them accepted as bugs (clean repro, root cause,
     evidence, no fix proposal).  The maintainer drives the fix
     discussion.
  4. The user must understand each filing well enough to defend
     it in maintainer discussion — see
     [[feedback_explain_before_filing]].

Operating model: I am a bug analyst, not a patch author, when it
comes to upstream engagement.  Workaround patches still ship to our
fork; upstream-bound filings are bugs only.
