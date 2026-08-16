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

## Path caveat

The scripts were written to run **inside the dcc source tree** and reference
the `dcc` compiler and emulator relative to that layout. After this
relocation the `dcc` submodule sits at `../dcc` (superproject root); the
run/build paths likely need adjusting before the harness runs as-is here.
This directory captures the sources faithfully — wiring the paths to the
`rc7xx-work` layout is a follow-up.
