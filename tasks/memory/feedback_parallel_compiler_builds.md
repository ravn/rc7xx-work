---
name: feedback_parallel_compiler_builds
description: Use git worktree + rsync --link-dest to maintain multiple Z80 clang builds simultaneously without duplicating disk space
metadata:
  type: feedback
---

Brug dette mønster til at sammenligne to compiler-versioner side om side uden at ødelægge hoved-buildet og uden at bruge unødigt diskplads:

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
- build-macos er altid hoved-buildet (vores main branch). Andre builds navngives `build-<prname>` eller `build-<feature>`
