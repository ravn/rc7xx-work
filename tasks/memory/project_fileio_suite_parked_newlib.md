---
name: project-fileio-suite-parked-newlib
description: FILE* test suite fortsættes når z88dk newlib CP/M migration lander upstream (ravn/z88dk#34 åbner op)
metadata:
  type: project
---

**Fact:** De fire XFAIL'ende fil-I/O-tests på classic llvmz80 (runtime_file, runtime_fileio_eof, runtime_fileio_multi, runtime_fileio_rename — alle producerer tomt output) + de 9 newlib-SKIP-tests genoptages når z88dk's newlib CP/M FILE*-driver landes upstream.

**Why:** ravn/z88dk#34 (WONTFIX for newlib disk FILE*) er præmissen for SKIP på newlib. Hvis upstream ændrer holdning og CP/M file-open-driver lander i newlib, fjernes SKIP og XFAIL-markerne, og testene skal PASS på begge clibs. Brugerdirektiv 2026-07-28.

**How to apply:** Når z88dk merger en newlib CP/M file-driver:
1. Fjern alle `runtime_fileio_*.sh` + `runtime_file.sh` entries fra `newlib_skip_reason()` i `run_all.sh`
2. Skift de 4 XFAIL-linjer i classic-tests til FAIL (og fix den underliggende llvmz80-gap)
3. Kør `TEST_CLIB=newlib_iy ./run_all.sh` og forvent PASS på alle fil-I/O-tests
4. Flip `runtime_file_console.sh` XFAIL → PASS når z88dk#3022 er merget (separat tracker)

Related: [[reference_z88dk_direction_classic_not_newlib]], z88dk#3022 (console-after-fopen), ravn/z88dk#34.
