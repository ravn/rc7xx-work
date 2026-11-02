# llvm-z80 patch series S1–S4 (local, NOT pushed to ravn/llvm-z80)

Base: `da06bcd8acc2` (pinned llvm-z80 = ravn/llvm-z80 origin/main, 2026-10-27).
Local branches in `llvm-z80/`: `s1/z80-intrinsics-nocallback` → `s2/z80-constant-port-in-out`
→ `s3/z80-im-set-i-intrinsics` → `s4/z80-clang-builtins` (each stacked on the previous).
These patches are a backup copy so the work is in the pushed workspace repo.
Apply with `git am` on top of the base. See `tasks/memory/project_z80_intrinsics_static_frames_2026-11-02.md`
and `tasks/plan-z80-intrinsics-static-frames-2026-11-02.md`.
