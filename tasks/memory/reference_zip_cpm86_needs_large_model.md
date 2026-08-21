# Info-ZIP `zip` på CP/M-86 kræver LARGE model (ikke medium)

2026-08-21. Under portning af Info-ZIP `zip` 3.0 til CP/M-86 (`owcc -bcpm86`,
repo `infozip-cpm86-builds`) viste det sig at **medium model (`-mm`/`-mcmodel=m`)
ikke duer** for zip, i modsætning til hvad Stage B-planen antog.

## Årsag (near/far type-mismatch, ikke en størrelses-ting)
`zip.h:834` prototyper `flush_block` som `char far *`, men K&R-definitionen i
`trees.c:1014` er `char *`. I **near-data**-modeller (small OG medium) er de to
ikke samme type → `trees.c(1018): Error! E1129`. Samme latente mismatch løber
gennem hele deflate-datastien (`window` er `far` via `DYN_ALLOC`, men flyder
gennem `char *`-parametre i `flush_block`/`copy_block`/`flush_outbuf`).

Kilden må **ikke** editeres: `src/zip30` er den pristine kilde DOS-buildet
(`build.sh` → `build/zip30` → `wmake msdos/makefile.wat`) reproducerer
byte-for-byte ("no C source file is changed"). Så fixet skal være model/flag, ikke edit.

## Empirisk matrix (owcc -bcpm86 -mcmodel=X, zip-kernen)
| model | far code | far data | trees.c | kerne |
|-------|:-:|:-:|:-:|:-:|
| s | ✗ | ✗ | E1129 | — |
| m | ✓ | ✗ | E1129 | — |
| c | ✗ | ✓ | OK | kode >64K → kan ikke linke (near code) |
| **l** | ✓ | ✓ | **OK** | **alle 11 objekter rent, nul edits** |

Large virker fordi far data gør `char *` == `char far *` (prototype matcher def),
og far code lader koden spænde flere 64K-frames (map: frame 0001 ~58K + 0002 ~52K).
Compact fejler fordi zip's kode ikke er ét ≤64K segment.

## Følger for large-model support (ny)
- `build-lib.sh` bygger kun s/m/c → skal have `MODEL=l` (`-ml -zm` + ny
  `crt0lm.asm` der definerer `_big_code_` + far-heap som crt0cm + far-code som crt0mm).
  Prøve-link viste `_big_code_` udefineret (large-runtime-markøren).
- DGROUP endte 68K (~3K over 64K); CONST alene 38K strenge → brug `-zc` (konstanter
  i kodesegmentet, far i large) for at tømme DGROUP. Flag, ikke edit.
- match.c (C-udgaven) SKAL med i objektsættet (`_longest_match`/`_match_init`);
  asm-`match` er kun en DOS-optimering.

Plan: `infozip-cpm86-builds/ZIP_CPM86_PLAN.md` (M1b = large clib). Kontrast:
unzip klarede sig med SMALL model (mindre kode, ingen far-data-mismatch) —
`[[reference_stageb_farcode_reloc_verified]]`.

## M1b FÆRDIG 2026-08-21: large-model clib bygget + valideret
- `build-lib.sh MODEL=l` (`-ml -zm`) → `clibl.lib` + `cstartlm.obj` (staged
  `lib286/cpm86/`). Ny `crt0lm.asm` = crt0mm's far-code startup.
- **Far-argv-finesse (vigtig):** i far-data-model er `char **argv` en far pointer
  (offset BX, segment CX) og hvert `argv[i]` en 4-byte far `char *`. crt0mm's near
  2-byte-argvtab gav tom argv[0]; crt0lm bygger far-pointer-slots med runtime-DS.
  Samme bug er LATENT i `crt0cm` (compact) — aldrig testet der; skal have samme fix.
- Valideret: emu2 `CLIBHELL FOO BAR` → argc=3, argv[0..2]=ZIP/FOO/BAR; og
  `run-all-models.sh` (udvidet med `l`): model l heap/stdio/float/math/fltfmt/
  scanf/**disk**/argv PASS. 2 fejl (conin, redir) = far-data stdin/redirect-input-
  hæng (samme klasse som medium's kendte stdin-issue), IKKE på zip's sti — zip
  bruger disk-FILE* (PASS). Se harness-task #12.
- Harness fik en **per-test timeout** (`guard()` via perl alarm, default 25s,
  override `TEST_TIMEOUT`) så et far-data-hæng ikke staller hele matrixen (den
  spandt 6+ min før). `[[feedback_show_progress_on_long_runs]]`.
