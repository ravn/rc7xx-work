# Handoff — 2026-06-06 — merge cleanup + sonnyboy bootstrap

**Where we are:** Long session on the macbook.  Pulled the 4940-commit
upstream LLVM merge into `ravn/llvm-z80` main, fixed the only
post-merge regression (SLP-emitted vector ops crashing the Z80 GISel
Legalizer in `vec3_dot()`), restored CI to green, then pivoted to make
the workspace fully clone-and-go so the user can switch between mac
and sonnyboy depending on what's available.  GitHub Actions on
`ravn/llvm-z80` is currently **disabled repo-wide** (`gh api --method
PUT /repos/ravn/llvm-z80/actions/permissions -F enabled=false`).

**Last touched:**

* `ravn/llvm-z80` → HEAD `2c3d594c06f9` (re-enable runtime-tests YAML, on
  top of the legalizer fix `b91f99686408` and the upstream merge
  `2b971123e3bd`).  Workflow YAML is updated but Actions are off at the
  repo level.
* `ravn/rc700-gensmedet` → HEAD `e589579` (sem702-raster minimum-viable
  demo + wait-state bench).  Pushed.
* `ravn/z88dk` → branch `rc700-gensmedet-1` pushed with upstream
  tracking; HEAD `523ad8661ac7`.
* Workspace `ravn/z80-compiler-suite-workspace` → HEAD `8eb88fd`
  (BOOTSTRAP.md + memory updates + finishing-roadmap + llvm-z80 submodule
  bump).
* GitHub-side: PR #17 closed (by maintainer earlier), issues #18-#25
  withdrawn with "Closing for reevaluation" comments per option D.

**Next action:**

The user said "5-bug analysis (option C in earlier menu)" is the next
direction, file-quality bug reports against `llvm/llvm-project`:

> "you have previously found several root bugs in llvm that we tried
> getting fixed in llvm-z80 but were rejected.  The goal now is to file
> high quality bug reports on the underlying issues in the upstream
> upstream project.  This requires the bugs to be verifiable with a
> simple test case (perhaps with an accompanying PR adding a XFAIL
> test) but without any z80 specific code or trying to solve the bug,
> we just want to show it.  Remember the bug must not have a previous
> bugreport.  I need you to have me understand it so I can prepend text
> to the suggested text explaining to the humans what the bug is and
> why it should be accepted or they will reject your work too."

Candidate bugs (from the session-77 retraction):

1. `deleteDeadLoop` malforms SSA on shared exit (ravn#182, was
   llvm-z80/llvm-z80#18 — closed).
2. `TruncInstCombine` "narrow through function `Argument` leaf" (was
   llvm-z80/llvm-z80#19; **verify still present** — session 76 noted
   "fix landed in `a5d49e9`" upstream; if so, drop from candidate list).
3. `SimplifyCFG::foldTwoEntryPHINode` no cost gate on no-branch-predictor
   targets (was llvm-z80/llvm-z80#20).
4. `TruncInstCombine` icmp / and-mask outside-graph user allowlist (was
   llvm-z80/llvm-z80#21).
5. `InstCombine` folds small memcpy to load+store of target-illegal int
   width (was llvm-z80/llvm-z80#22).

Process per the new memory rules (`feedback_explain_before_filing`,
`feedback_upstream_routing_two_targets`, `feedback_no_upstream_issues`):

1. Route each to `llvm/llvm-project` (these are target-agnostic generic
   bugs; the routing miss in session 77 sent them to the Z80 fork
   instead).
2. **Check known bugs first** at `llvm/llvm-project` issue tracker
   before drafting.  If a matching issue exists, reference it; do not
   duplicate.
3. Reproduce each on sonnyboy's freshly-built upstream `opt` / `clang`
   at `~/llvm-upstream/llvm-project/build/bin/`.  Drop any that no
   longer reproduce.
4. For each surviving bug: write a target-agnostic minimal test case
   (no Z80 anything) + a clear root-cause explanation in plain English
   + suggested issue body **without** a fix proposal.
5. **Show to the user one bug at a time, get explicit per-bug "go ahead"
   before filing.**  Bundling is what got PR #17 rejected.
6. Once user understands and approves, the user prepends their own
   framing to the suggested text and files.  I don't `gh issue create`
   without that approval per filing.

**Open questions for the user:**

* On the migration question: I asked "both" (start bug analysis from mac
  while sonnyboy bootstrap runs in parallel) -- the user pivoted to the
  workspace-portability work, which is now done.  Confirm "now start the
  5-bug analysis from whichever host you're on" is still the direction.
* For Claude Code on sonnyboy: I gave 3 install paths (system Node from
  apt, NodeSource Node 24, nvm via the upstream script).  User wanted
  nvm-as-a-package; I confirmed it's not in Ubuntu 26.04 apt and
  recommended Option A (system Node + user-prefix npm).  No install
  yet -- user hasn't said "fire it".

**Pinned context:**

* The session has been long; today's CLAUDE.md update should record:
  session 78 = "merge cleanup + workspace portability + new memory
  rules: explain-before-filing, cross-machine workflow, routing
  correction."  I left the timeline update to a future segment; not
  blocking.
* The user is explicitly working bilingually — I switched back to
  English mid-session per user direction ("this project is
  international").  Stay in English unless the user explicitly switches
  back.
* The 5-bug audit must verify each bug STILL reproduces on the current
  upstream HEAD (sonnyboy's `~/llvm-upstream/llvm-project/` was cloned
  earlier today at `de59f9ed12db`).  Some session-77 candidates may
  have been fixed upstream already.

---

## Addendum — sonnyboy session, 2026-06-06 (direct)

* Claude Code now runs DIRECTLY on sonnyboy (`~/.local/bin/claude`,
  system Node v22 — Option A happened).  Host facts recorded in
  `tasks/memory/reference_host_sonnyboy.md`.
* SSH key for sonnyboy added to GitHub; verified.  Global git rewrite
  ravn/* https -> ssh installed; a stale opposite (ssh -> https)
  rewrite removed.  `gh` CLI still needs `gh auth login`.
* **ACTION NEEDED ON MACBOOK:** `rc700-gensmedet` HEAD `e589579` pins
  z80pack at `b2eb2f36`, but that commit was never pushed to
  ravn/z80pack — `git pull --recurse-submodules` on sonnyboy fails
  with "not our ref".  Next macbook segment: `git -C
  rc700-gensmedet/z80pack push`.  (The failed fetch also left
  sonnyboy's z80pack working tree emptied; repaired with `reset --hard`
  to `c37fd9c1` = origin/master.)
