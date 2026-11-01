---
name: reference_ccache_path_keyed_cross_tree
description: ccache hits kræver samme kildesti; worktrees/andre mapper deler ikke cache (0,5% hit rate) — mind brugeren om det hvis det kommer igen
metadata:
  type: reference
---

**Fakta (verificeret 2026-11-01, sonnyboy):** ccache hasher absolutte `-I`-stier (`base_dir` er tom). Samme kilde + samme flag i en anden mappe (fx `scratch/llvm-z80-pr112/` vs `llvm-z80/`) giver `cache_miss`; testet med symlink: ny stitekst = miss, gentagelse = hit. Derfor gav pinned-build efter PR-build kun 29 hits af 6198.

**Why:** Brugeren undrede sig over lav hit rate og valgte (option C) at lade det være: genbyg i `llvm-z80/build-linux` rammer cachen. Option A (`base_dir=/home/ravn/z80`) hjælper IKKE på tværs af worktrees (relative stier er stadig forskellige) og ugyldiggør eksisterende poster; option B = skift gren i samme træ + genbrug builddir.

**How to apply:** Hvis lav ccache hit rate eller langsomt cold rebuild i en ny worktree/mappe dukker op igen, MIND brugeren om denne note og de tre muligheder (A base_dir / B samme sti / C ingen ændring) i stedet for at undersøge forfra. Se [[feedback_parallel_compiler_builds]] og [[feedback_ccache_llvm_build]]. ccache max_size er sat til 50 GB (`~/.config/ccache/ccache.conf`).
