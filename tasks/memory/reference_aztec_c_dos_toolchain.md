# Aztec C86 (MS-DOS/CP/M-86) toolchain — location, working recipe, docs

Verified 2026-08-17 on macbook. The user is interested in **Aztec C's code
generation** and wanted the **DOS version** to work. It works today.

## Where the toolchain lives
- Fully-installed, run-ready copy: `open-watcom-v2/contrib/ravn/cpm86-crossdev/`
  (a git SUBMODULE = ravn's fork of tsupplis/cpm86-crossdev). Wrappers in `bin/`,
  emu2 in `bin/emu2` + `emu2/emu2` (native arm64), tools + libs under
  `share/aztec34/{bin,lib,include}`.
- `bin/` POSIX wrappers drive the DOS `.exe` tools under **emu2**:
  `aztec34_cc` (cc.exe), `aztec34_link` (ln.exe), `aztec34_lib` (lb.exe),
  `aztec34_as`, `aztec34_obd` (object dump/disassembler), `aztec34_sqz`,
  `aztec34_hex86`. Add `bin/` to PATH; the wrappers set EMU2_DRIVE_D/E, CLIB,
  INCLUDE, PATH inside emu2.
- Archive of the distribution: `contrib/ravn/cpm86-crossdev/archive/az8634b.zip`
  (also `contrib/ravn/aztec-libc/work/az8634b.zip`). Do NOT re-download.

## Two versions — BOTH work for DOS (verified 2026-08-17)
- **aztec34 = Aztec C86 3.40a/b (K&R)** — FULLY installed (bin+lib+include).
  K&R only: `int main(void){...}` is REJECTED; use old-style `main(){...}`.
- **aztec42 = Aztec C86 4.10d (v4.2, almost-ANSI, the NEWEST — user prefers it)**
  — NOW fetched+unpacked and working. `AztecC86.zip` cached at
  `contrib/ravn/cpm86-crossdev/archive/AztecC86.zip` (~1 MB, from
  aztecmuseum.ca); unpacked into `share/aztec42/{bin,lib,include,src}`. Accepts
  ANSI `int main(void)`. Pipeline is Pass1+Pass2 (`cc.exe`→`cgen.exe`) + `as.exe`
  → `.o`; `ln.exe` links. Same wrappers `aztec42_cc`/`aztec42_link`/`aztec42_obd`.
  (Re-fetch: `src/fetch/aztec42` + optionally `buildaztec42` to rebuild the
  CP/M-86 c86.lib/d11.lib from sources; the shipped DOS libs work as-is.)

## Working DOS build — the one-liner recipe (VERIFIED, both versions)
K&R (3.40) vs ANSI (4.2) source differs, but the build steps are identical
(swap `aztec34_` ↔ `aztec42_`):
```c
#include <stdio.h>
int main(void){ printf("Hej fra Aztec C paa DOS\n"); return 0; }  /* 4.2 ANSI */
```
```sh
cd open-watcom-v2/contrib/ravn/cpm86-crossdev
export PATH="$PWD/bin:$PATH"
aztec42_cc  -I. t.c            # -> t.o   (Pass1->Pass2->as; ANSI)
aztec42_link -o t.exe t.o -lc  # -> t.exe (real "MS-DOS executable")
emu2 t.exe                     # prints the line
```
- Memory-model / target is chosen by the **library** at link (the wrapper picks
  the matching startup from `-l`): `-lc` = MS-DOS **small** (startup sbegin.o),
  `-lcl` = MS-DOS **large** (lbegin.o), `-lc86` = **CP/M-86** .cmd (begin86.o).
- The lib pulls its own startup for programs that reference libc, so a standalone
  `sbegin.o`/`lbegin.o` in `lib/` is NOT required for ordinary programs (the
  wrapper only needs it for programs that reference no libc, e.g. bare `return 0`).
  Extract on demand: `aztec34_lib share/aztec34/lib/c.lib -x sbegin`.

## GOTCHA that cost time
Compiling with `-D__CPM86__` and then linking `-lc` (DOS) produced
`ERROR: Code and data regions overlap`. Compile clean for the DOS target (no
`__CPM86__`) and link `-lc`; the overlap disappears. `-D__CPM86__` belongs only
with the `-lc86` CP/M-86 path.

## Seeing the code generation
`aztec34_obd file.o` / `aztec42_obd file.o` disassembles the Aztec object.
- 3.40 `printf("Hello")` body: `55 8b ec` (push bp;mov bp,sp) / `b8 .. 50`
  (mov ax,&str;push) / `e8 ..` (call printf_) / `83 c4 02` (add sp,2) /
  `33 c0 8b e5 5d c3` (xor ax,ax;mov sp,bp;pop bp;ret) — clean 8086.
- 4.2 `int sq(int n){return n*n+3;}`: `55 8b ec` / `8b 46 04` (mov ax,[bp+4]=n) /
  `f7 e8` (imul ax → n*n) / `40 40 40` (inc ax ×3 = +3) / `8b e5 5d c3`
  (ret) — reasonable; uses hardware IMUL + 3×INC for the constant add.

## Documentation locations (read these, don't re-fetch)
- In-zip release notes: `AZ8634B/DOC/README` inside `archive/az8634b.zip`
  (3.40a/b changes: linker `-N` not `-n`; CLIB is a `;`/space path list; new
  3-step linker object search; lib/util/linker fixes).
- Toolchain how-to: `cpm86-crossdev/README.md` (script->program mapping, models,
  emu2/tnylpo) + `examples/Makefile` (canonical build recipes per language) +
  `examples/` (helloc.c etc.).
- The library-source-recompile experiment (SEPARATE effort, see routing below):
  `contrib/ravn/aztec-libc/README.md`.
- Full user manual is ONLINE only (not in workspace): MS-DOS 4.10C —
  `https://www.aztecmuseum.ca/docs/Aztec_C_MSDOS_4.10C_Commercial_Apr88.pdf`
  (linked from cpm86-crossdev/README.md). The local `cpm_compilers/manx aztec c
  v10x/*.pdf` are the older **CP/M-80** manuals (C80.COM), not the 86 version.

## Routing note
This is a STANDALONE look at Aztec's code generation, NOT interop. It does not
revive the retired Watcom<->Aztec bridging
(`reference_watcom_interop_retired_drc_oracle.md`).
