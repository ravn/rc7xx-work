# dcc-bench — three-compiler CP/M comparison harness

A differential benchmark/comparison harness that builds the same C sources
with **dcc**, **clang (llvm-z80)** and **zsdcc**, runs them under a CP/M
emulator (`ntvcm` / `vcpm`/`runticks`), and reports per-test agreement,
size and timing (with consensus verdicts and hang guards).

## Provenance

These files were authored on top of the [davidly/dcc](https://github.com/davidly/dcc)
fork (`ravn/dcc`) but are **RC7xx project tooling, not part of the dcc
compiler**, so they live here in `rc7xx-work` instead. Extracted verbatim
from the fork's `main` (the 18 files that were added on top of upstream
`davidly/main`); nothing in the dcc compiler itself was modified.

## Layout

- `scripts/compare3.sh` — the main sweep (dcc vs clang vs zsdcc, consensus verdicts)
- `scripts/compare3_html.py` — color-coded HTML report generator
- `scripts/ma.sh` — build/run helper (auto-finds `ntvcm`)
- `runall.sh`, `runcpm.sh`, `runticks.sh` — run/timing drivers
- `tests/` — benchmark sources: firmware-representative micro-benchmarks
  (`fw*.c`), classics (`whetston.c`, `ackerman.c`, `hanoi.c`, `tak.c`)
- `compare3_results.csv` — a sample results snapshot

## Running from the superproject

The harness is wired to discover every compiler and tool from the
`rc7xx-work` submodules relative to its own location — no hardcoded
`/Users/...` paths — so it runs straight from the workspace root:

```sh
dcc-bench/scripts/compare3.sh --csv fwdelay sieve   # CSV for two tests
dcc-bench/scripts/compare3.sh --all                 # whole TEST_LIST
dcc-bench/scripts/compare3.sh --html                # HTML report
```

Discovered from the workspace root (`dcc-bench/..`), each overridable by an
env var of the same name:

| Tool                    | Default location                          |
|-------------------------|-------------------------------------------|
| dcc + m80/l80/DCCRTL    | `dcc/` submodule (`DCC_DIR`)              |
| clang (llvm-z80)        | `llvm-z80/build-macos\|linux\|build/bin` (`CLANG_BUILD`) |
| zsdcc (`zcc`) + ticks   | `z88dk/bin` (`Z88DK_BIN`, `TICKS`)       |
| `VirtualCpm.jar`        | `cpnet-z80/tools` (`VCPM_JAR`)           |

## Test sources — two locations

`compare3.sh` resolves each test via `find_test_src`, checking:

1. `dcc-bench/tests/` — the RC7xx firmware micro-benchmarks (`fw*.c`,
   `whetston.c`, `ackerman.c`, `hanoi.c`, `tak.c`) added by this project.
2. `dcc/tests/` (submodule) — davidly's canonical dcc suite (`sieve`, `e`,
   `nqueens`, `fact`, `triangle`, `ttt`, `tstring`, …).

The local benchmark dir wins on a name clash. This split lets the default
`TEST_LIST` mix both without copying davidly's tests out of the submodule.
