---
name: feedback_parallel_compiler_builds
description: Reuse the existing ccache-enabled build across branch switches; separate builds only for simultaneous comparisons
metadata:
  type: feedback
---

Standard for sequential builds: bevar lokale ændringer, skift branch i det
eksisterende checkout, og genbrug det eksisterende builddir med ccache
aktiveret. Kontrollér de genererede compilerkommandoer og cache-statistikken.
En separat worktree ændrer typisk kilde- og include-stierne i ccache-nøglerne,
så den er ikke en måde at forbedre cache-hits på.

Den 2026-10-04 gav branchskift i det eksisterende build 792 nye cache-hits
og kun 3 nye misses mod målingen før skiftet. Det separate build havde
ingen nye hits. Brug derfor ikke et separat builddir til sekventielle
branch-eksperimenter.

Måling 2026-11-03 på et isoleret S4-build: ccache var aktiv via den genererede
Ninja-launcher, men gav kun 6 hits og 101 misses af 107 cacheable calls. Det
bekræfter, at aktiv ccache ikke i sig selv giver genbrug mellem worktrees.

Brug kun separate worktrees, når to compiler-versioner faktisk skal bygges
samtidigt. Hold ccache aktiveret, men forvent ikke genbrug på tværs af dem.
`rsync --link-dest` nedenfor reducerer diskforbruget for build-katalogerne;
det normaliserer ikke kilde-stier og forbedrer ikke i sig selv ccache-hitrate.
En tidligere `base_dir`-prøve gav heller ikke genbrug på tværs af worktrees
og ændrede cache-nøglerne, så ændr ikke den globale ccache-konfiguration for
at forsøge dette uden en afgrænset før/efter-måling.

Når samtidige builds er nødvendige, kan dette mønster bruges for at dele
uændrede build-filer på disk:

```bash
# 1. Worktree — separat checkout af branchen
git -C /Users/ravn/z80/llvm-z80 worktree add ../llvm-z80-<name> <branch>

# 2. Hardlink-kopi af build — kun ændrede filer kopieres fysisk (sparer ~2 GB)
rsync -a --link-dest=/Users/ravn/z80/llvm-z80/build-macos \
  /Users/ravn/z80/llvm-z80/build-macos/ \
  /Users/ravn/z80/llvm-z80/build-<name>/

# 3. Rekonfigurér mod worktree-kilden
cmake -C clang/cmake/caches/Z80.cmake \
      -G Ninja \
      -S /Users/ravn/z80/llvm-z80-<name>/llvm \
      -B /Users/ravn/z80/llvm-z80/build-<name>

# 4. Byg kun ændrede filer
ninja -C /Users/ravn/z80/llvm-z80/build-<name> clang llc
```

**Why:** LLVM-bygget er ~2.3 GB. Uden `--link-dest` kopierer rsync alt. Med `--link-dest` er inode'erne delte for uændrede filer — kun de få filer der faktisk ændres (f.eks. Z80TargetTransformInfo.o) fylder noget nyt. For en 1-commit PR er det typisk <10 MB ekstra.

**How to apply:**
- Brug altid `--link-dest` når du opretter et parallelt LLVM-byg til sammenligning
- Ryd op bagefter: `git worktree remove ../llvm-z80-<name>` + `rm -rf build-<name>`
- Genbrug normalt `build-macos-asserts` efter branchskift. Separate builds
  navngives `build-<prname>` eller `build-<feature>` og kræver aktiv ccache.
  `--link-dest` er diskoptimering; worktree-stier kan stadig give cache misses.
- Isolated firmware builds must also override `MAME` to a private output path:
  `make prom` copies its ROM into `$(MAME)/roms/rc702/roa375.ic66`.
