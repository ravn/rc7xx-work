# Handoff — 2026-09-27 — triple-z88dk-and-agents-protocol

**Where we are:**
Implemented target triple `z80-unknown-none-z88dk` (`Triple::Z88DK`) in `ravn/llvm-z80` as requested by the fork owner in `llvm-z80/llvm-z80#39`. The triple activates native `z80asm` output, `sdcccall(0)` for float libcalls, `__smallc` for synthesized standard C libcalls, and predefines `__Z88DK__` macros. It is based on `pr-combined-z88dk-features` (combining upstream features #68, #69, and #70). Tests added test-first and fully pass (136/136 LLVM CodeGen Z80, 11/11 Clang CodeGen Z80, 4/4 MC Z80). PR #389 and tracking issue #391 created on `ravn/llvm-z80`.
In addition, `AGENTS.md` was updated with the mandatory Session Startup Protocol (reading `CLAUDE.md`, `tasks/memory/MEMORY.md`, and staleness check against canonical); PR #2 opened on canonical `ravn/AGENTS.md` and propagated to `rc7xx-work`, `rc700-gensmedet`, `infozip-cpm86-builds`, and `z88dk`.

**Last touched:**
- `llvm-z80`: branch `upstream-triple-z88dk` (commit `b3839824a12e`), `pr-combined-z88dk-features` (commit `d8f8e4b5fd0c`). Both pushed to `origin`.
- `ravn/llvm-z80#389` (PR for triple) and `ravn/llvm-z80#391` (tracking issue).
- `rc700-gensmedet`: commit `781ce3f` (sync `AGENTS.md`), pushed to `origin/main`.
- `infozip-cpm86-builds`: commit `452abf7` (sync `AGENTS.md`), pushed to `origin/cpm86-port`.
- `z88dk`: commit `9ef200c80a` on `master` (sync `AGENTS.md`), pushed to `origin/master`. Working branch remains `pr-clang-abi-headers` (PR #80).
- `AGENTS.md`: PR #2 on `ravn/AGENTS.md`.
- `ccache`: configured to 10 GB limit (`ccache -M 10G`) at `/Users/ravn/z80/ccache/install/bin/ccache`.

**Next action:**
1. Wait for upstream review/merge of #58, #59, #60 or go-ahead to submit `z80-unknown-none-z88dk` PR upstream to `llvm-z80/llvm-z80`.
2. Resume Trin 3 in `z88dk`: update `zcc` driver in `src/zcc/zcc.c` to use `--target=z80-unknown-none-z88dk` instead of manual `-mllvm` flags once the triple compiler is active.

**Open questions for the user:**
1. Should we file the tracking issue for Trin 3 in `ravn/z88dk` now? (Draft provided in summary).
2. For `rc700-gensmedet`, unstaged edits remain in `cpnos-in-c/src/hal.h` (dynamic port I/O fallback using `in (c)` / `out (c)`) from prior work. Should these be committed or kept for the firmware sprint?

**Pinned context:**
- Upstream fork owner naming rule: NEVER write or mention the fork owner's username or real name in chat, PRs, issues, or commits. Always refer to him as "the fork owner" or "upstream fork maintainer".
- Ccache statistics: report `ccache -s` after every build.
