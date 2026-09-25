# Session 2026-09-25: llvm-z80 PR-per-issue split (IN PROGRESS, needs resume)

## Goal
User wants each staged z88dk-integration fix as its own small, clean PR
within `ravn/llvm-z80` (branch -> `upstream-main`), not accumulated via
direct pushes to `upstream-main` as had been done. Decided via
AskUserQuestion: PR target = `ravn/llvm-z80` (not llvm-z80/llvm-z80 directly
yet — that still needs `feedback_explain_before_filing` go-ahead per item
later); structure = one branch+PR per issue.

## State BEFORE this session (still live on origin right now)
`origin/upstream-main` currently holds all of this, as 13 commits stacked
directly on `upstream/main` (b904185a3465), no PRs:
- `1f7f9ef8cb36` ccache (Z80.cmake) — infra only, not an issue, not for PR
- `98c6a836a7ea`,`29c6f93dd469`,`ccd88f3e35e7` — issue #366 (f32 sdcccall0)
- `f73faff6e268`,`adbddfce4048` — issue #367 (classic-libc-cc)
- `68a7bdaead0a`,`77d705dae0ec` — `-mdouble=` (already upstream PR #43,
  cherry-picked from `origin/upstream-mdouble`; NOT one of our staging
  issues, does not need a new PR)
- `5482c42a4129` — issue #368 (`.quad` split)
- `53fdc7ca108f`,`b2cf2b9076b0` — issue #369 (i32 divmod fusion)
- `858936bc3018`,`fd223096edcb` — issue #370 (`-O3` fast div/mod)

Local git in `/home/ravn/z80/llvm-z80` is currently reset to MATCH
`origin/upstream-main` exactly (safe, no divergence) — the plan below was
interrupted mid-way and rolled back to this safe point before shutdown.

## Plan (what still needs doing, on any machine)
1. Rebuild a clean `upstream-main` = `upstream/main` (b904185a3465) +
   ccache (`1f7f9ef8cb36`) + mdouble (`68a7bdaead0a`, `77d705dae0ec`) only.
   Already done once this session as a LOCAL branch state (not pushed) —
   redo: `git reset --hard b904185a3465 && git cherry-pick 1f7f9ef8cb36
   68a7bdaead0a 77d705dae0ec`.
2. **Force-push that onto `origin/upstream-main`.** This was BLOCKED this
   session by the auto-mode permission classifier ("Git Destructive") —
   needs the user to either run it themselves or grant a Bash permission
   rule for `git push --force-with-lease`. Command:
   `git push --force-with-lease origin upstream-main`
   (rewinds the remote branch from 13 commits down to 3 — ccache + the 2
   mdouble commits — so per-issue PRs have something real to diff against).
3. For each of the 5 issues, from the rebuilt `upstream-main` tip:
   `git branch -f pr-NNN-<slug> upstream-main && git checkout pr-NNN-<slug>
   && git cherry-pick <that issue's original commit hashes above>`
   then `git push -u origin pr-NNN-<slug>`, then
   `gh pr create --repo ravn/llvm-z80 --base upstream-main --head
   pr-NNN-<slug> --title ... --body ...` (reference the staging issue
   #NNN in the body, matches the commit messages already written).
   - **#366** branch `pr-366-float-sdcccall0-libcalls`: ALREADY DONE this
     session — cherry-picked, pushed to origin. Still need: open the
     actual `gh pr create` (not done yet).
   - **#367** `pr-367-classic-libc-cc`: not started.
   - **#368** `pr-368-quad-split`: not started.
   - **#369** `pr-369-divmod-fusion`: not started.
   - **#370** `pr-370-div-fast-o3`: not started.
4. Verify each branch builds + passes its own lit test in isolation
   (cherry-picking onto the leaner base instead of the cumulative branch
   may or may not apply cleanly — recheck, especially #369 which touches
   the same file, `Z80LegalizerInfo.cpp`, as #366, in a different region).
5. Once all 5 PRs exist and are reviewed/merged by the user on GitHub,
   `origin/upstream-main` becomes the accumulated integration branch again
   — naturally, through merges this time instead of direct pushes.

## z88dk side (already done, no action needed)
- `z88dk` repo (github.com/ravn/z88dk), branch `master`, commit
  `d2f09530aa`: `zcc` auto-injects `-mllvm -z80-split-quad-directive`
  (pushed already — this one was a normal push, not a PR, per existing
  house convention for the z88dk-side bridge work).
- Full `test/clang` suite against the (now-reverted-locally, but
  currently-still-on-origin) `upstream-main` build: 56 PASS / 7 FAIL, all
  7 remaining fails are pre-existing z88dk runtime-library/test-infra
  issues, zero compiler-side gaps.

## Key learning
Direct-push to `origin/upstream-main` for #366-#370 was the WRONG pattern
per explicit user correction ("jeg skal have 370 som en pr, ikke direkte
pushet" / "jeg er ikke sikker på det skal gøres ved at pushe direkte til
upstream-main"). Going forward: each new staged fix should get its own
branch off `upstream-main` and a `gh pr create` against it, never a direct
push to `upstream-main` itself (ccache and the mdouble PR#43
cherry-pick are the sole exceptions — infra and already-upstream-reviewed
work respectively).
