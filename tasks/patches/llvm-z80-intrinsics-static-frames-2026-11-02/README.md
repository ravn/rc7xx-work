# llvm-z80 patch series S1–S4 (pushed as branches to ravn/llvm-z80; patches are a backup)

Base: `da06bcd8acc2` (pinned llvm-z80 = ravn/llvm-z80 origin/main, 2026-10-27).
Local branches in `llvm-z80/`: `s1/z80-intrinsics-nocallback` → `s2/z80-constant-port-in-out`
→ `s3/z80-im-set-i-intrinsics` → `s4/z80-clang-builtins` (each stacked on the previous).
These patches are a backup copy so the work is in the pushed workspace repo.
Apply with `git am` on top of the base. See `tasks/memory/project_z80_intrinsics_static_frames_2026-11-02.md`
and `tasks/plan-z80-intrinsics-static-frames-2026-11-02.md`.

The same four commits are on GitHub as branches `s1/…`–`s4/…` in ravn/llvm-z80 (pushed 2026-11-02).
`repro/` has the small reproducers used for the measurements. Start with `tasks/HANDOFF-z80-intrinsics-2026-11-02.md`.
