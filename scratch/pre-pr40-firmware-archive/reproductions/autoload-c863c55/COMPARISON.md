# Same-source autoload disassembly comparison

This compares the archived `c863c55` autoload source compiled by the
pre-PR-40 compiler with that same source compiled by the current compiler
backend plus a temporary restoration of address-space-2 port I/O.

## Result

| Build | Compiler endpoint | Raw `.text` | ZX0 payload | ROM image |
|---|---|---:|---:|---:|
| Historical | `compiler-pre-pr40` at `d52e233` | 3393 B | 1915 B | 2034 B |
| Current backend | `d6658ad` plus temporary port-I/O patch | 3685 B | 2095 B | 2214 B* |
| Difference |  | +292 B | +180 B | +180 B |

`*` The 2214 B image is for inspection only. The production linker script
rejects it for exceeding the physical 2048 B PROM limit by 166 B. A copy of
the linker script with only that assertion raised to 4096 B was used to
produce the final-layout ELF and disassembly; no MAME boot or runtime test
was run.

## Inputs and method

- Historical source: `source/autoload-in-c/`, exported from `c863c55`.
- Historical output: `evidence/prom.clang.lis`, `prom.clang.bin`,
  `text_raw.bin`, and `text_compressed.zx0`.
- The current build's `boot_rom.c`, `intvec.c`, `rom.c`, `rom.h`,
  `clang/Makefile`, and `clang/rc700_prom.ld` match the corresponding Git
  blobs at `c863c55`.
- The historical evidence listing differs from the committed source-snapshot
  listing only in two source-comment annotations and the embedded build
  banner. The evidence `.text` differs from the committed/decompressed `.text`
  in 14 banner bytes; instruction bytes match.
- Current output: `current-d6658ad-asio/prom.current-overcap.lis`,
  `prom.current-overcap.elf`, `prom.current-overcap.bin`, raw/compressed
  payloads, and the build log under `../../build-logs/`.
- The current source tree is the same archived source; only build outputs
  were generated. Compiler sources were not changed in the main checkout.
- Current compiler source is `d6658ad`. The isolated worktree adds the
  address-space-2 restoration in `current-backend-port-io.patch`; this is
  necessary because unmodified `d6658ad` fails to legalize a port `G_STORE`.
- The historical `+static-stack` and `+shadow-regs` options are no longer
  recognized. The current build uses their current spellings,
  `+static-frame` and `+shadow-isr`, alongside the historical `-Oz -g`,
  section, and `-disable-lsr` settings.
- The current compiler emits `___z80_memset_builtin`, absent from the
  historical firmware link. Its runtime implementation was taken from the
  current Z80 builtins object; `_memset` was localized in that object to
  avoid colliding with the firmware's existing `_memset`.
- The current ROM ELF was linked with an inspection-only linker-script copy
  (`rc700_prom_inspection.ld`). The original 2 KB assertion remains unchanged
  in the archived source.

This is an end-to-end compiler comparison: both compilers receive the same C
source and equivalent optimization/target options, but the Clang frontends
also differ. It therefore shows the emitted-code delta, not a backend-only
causal attribution. The assembly below documents observed differences; it
does not prove why each compiler made its decisions.

## Largest matched function changes

Function byte counts are from the disassemblies: historical instruction
bytes between function labels, compared with current ELF symbol sizes.

| Delta | Function | Historical | Current |
|---:|---|---:|---:|
| +60 B | `_check_sysfile` | 40 B | 100 B |
| +33 B | `_fdc_read_data_from_current_location` | 132 B | 165 B |
| +21 B | `_fdc_select_drive_cylinder_head` | 39 B | 60 B |
| +21 B | `_fdc_read_result` | 39 B | 60 B |
| +17 B | `_fdc_get_result_bytes` | 92 B | 109 B |
| +16 B | `_verify_seek_result` | 44 B | 60 B |

`_main_relocated` shrinks from 486 B to 194 B, while the current listing
emits separate helper symbols also represented in the old function body:
`_display_banner_and_start_crt` (61 B), `_draw_qr` (43 B),
`_display_sw1_status` (37 B), and `_load_chargen_font` (34 B). The separate
`_boot_from_floppy_or_jump_prom1` is 143 B; the historical listing has no
symbol with that name. Compare instructions and call sites rather than
treating extracted code as new source functionality.

The complete symbol-boundary budget reconciles the raw `.text` growth:

| Region / group | Historical | Current | Delta |
|---|---:|---:|---:|
| From `__code_start` to `_eot_gap3_table` | 1658 B | 1910 B | +252 B |
| Remaining `.text` after `_eot_gap3_table` | 1735 B | 1775 B | +40 B |
| Total raw `.text` | 3393 B | 3685 B | +292 B |

Within the first region, `_main_relocated` plus its four display helpers
changes by −117 B (486 B to 194 B + 175 B). The boot path changes by +155 B:
the new 143 B `_boot_from_floppy_or_jump_prom1` plus the existing
`_boot_floppy_or_prom` growing by 12 B (124 B to 136 B). Those two structural
groups therefore net +38 B; the other code symbols before `_eot_gap3_table`
net +214 B. This includes `_check_sysfile` (+60 B),
`_fdc_read_data_from_current_location` (+33 B),
`_fdc_select_drive_cylinder_head` and `_fdc_read_result` (+21 B each),
`_fdc_get_result_bytes` (+17 B), and `_verify_seek_result` (+16 B);
the smaller changes and `_OUTLINED_FUNCTION_1` are included in the net.
These are measured symbol spans, not causal explanations for the code
decisions. The +40 B after the table is a region total, not a claim that all
of it is data.

Two visible examples:

- `_fdc_select_drive_cylinder_head`: historical code uses `OR (HL)` and
  `PUSH AF`; current code loads the drive byte into `C`, uses `OR C`, and
  stores values in IX-relative frame slots. Its measured body grows by 21 B.
- `_fdc_read_result`: historical code saves the loop counter with `PUSH DE`
  across a call and indexes via `ADD HL,DE`. Current code spills the counter
  through an IX-relative slot and zero-extends it into BC before `ADD HL,BC`.
  Its measured body also grows by 21 B.

## Inlining versus separate helper bodies

The listings confirm that some code now emitted as separate helpers was
present inside historical `_main_relocated`. The old listing contains the
character-generator loop directly (around `0x648c`-`0x64ab`), followed by the
screen-clear, banner, SW1-status, and QR drawing bodies (around
`0x64c9`-`0x655e`). The current listing instead calls
`_load_chargen_font` and `_display_banner_and_start_crt` from
`_main_relocated`; the latter calls `_display_sw1_status` and `_draw_qr`.
This is an observed change in emitted structure, not proof of which frontend
or backend inlining decision caused it; the frontends differ between builds.

The current `_main_relocated` body is 194 B versus 486 B historically, while
the extracted helpers add their own code and call overhead. Therefore the
main-function delta alone overstates the image-level saving from extraction;
the total payload must be used to assess its effect.

## Static-frame distinction and attribution limits

The feature names hide a real change in eligibility. In `d52e233`,
`+static-stack` lowers eligible locals into BSS without a whole-module
reentrancy proof. On the frame-pointer path, the old lowering requires locals
beyond callee-saved registers, no fixed objects, and no variable-sized
objects; on the no-frame-pointer path, it skips local SP allocation whenever
`+static-stack` is enabled. In `d6658ad`, `+static-frame` is only permission:
`usesStaticFrame()` also requires the function's `nonreentrant` attribute,
which the `Z80NonReentrant` call-graph/context analysis must establish. Thus
matching the option names or passing both options does not make the frame
policies equivalent.

The saved current post-analysis MIR does not mark `check_sysfile`
`nonreentrant`, so its current IX-relative spills cannot use static storage.
However, the historical `_check_sysfile` is already only 40 B and has no IX
frame; it keeps the loop and pointer state in registers. The current version
is 100 B and introduces IX-relative locals, so static-frame eligibility alone
does not explain this 60 B delta: register allocation and lowering also
differ.

One concrete difference in `_check_sysfile` is comparison signedness. Its
source compares an unsigned `byte` with a plain `char`; with this target's
signed plain `char`, C integer promotions require zero-extending the byte and
sign-extending the pattern character. The current listing does that work,
whereas the historical listing compares only the low bytes. The actual
callers pass ASCII `"SYSM"`/`"SYSC"`, but the historical low-byte comparison
would differ for high-bit pattern characters. This is therefore not counted
as an established missed optimization; no dedicated high-bit runtime test was
run.

The earlier `-ffreestanding` closed-world explanation is also revision-bound.
At `d6658ad`, Clang emits no `"Freestanding"` module flag and
`Z80NonReentrant` does not read one; current reentrancy barriers use the
function-level `target("no-recurse")` feature. The exact-source `-ffreestanding`
probe did not change `check_sysfile`'s analysis result, and changed other IR,
so it is not a clean size experiment.

## Diagnostic frame-only probe: `_check_sysfile`

The source has two direct calls to `check_sysfile`, both from
`boot_floppy_or_prom`; that caller is reached from the main boot path. The
function is a leaf, is not address-taken, and no ISR calls it. In the archived
translation unit, this makes it a suitable *diagnostic* `no-recurse`
candidate: an ISR may interrupt it, but cannot invoke a second activation of
it. The attribute was applied only in a temporary source copy and was not
added to firmware.

I emitted matched `-Oz` LLVM IR from the two source copies, then compared
function-only `d6658ad` codegen. The stack control adds
`target("no-static-frame")`; the diagnostic candidate adds
`target("no-recurse")`. `llvm-diff` found no IR-body changes. Running
`llc -mtriple=z80 -O2` on the extracted function produced:

| Variant | `_check_sysfile` code | Frame storage |
|---|---:|---:|
| Stack-frame control | 115 B | IX-relative stack slots |
| Static-frame diagnostic | 79 B | 6 B static BSS frame |
| Difference | **−36 B** | +6 B BSS |

The whole-module `Z80NonReentrant` pass independently confirms the gate
transition: baseline IR leaves `check_sysfile` without `"nonreentrant"`;
the diagnostic full-module IR adds it. The extracted-function result is not
representative of the complete `-Oz` build: its 36 B saving must not be used
to estimate the PROM delta.

The saved extracted IR, objects, and disassemblies are in
`current-d6658ad-asio/check-sysfile-static-frame-probe/`.

## Full-image `check_sysfile` counterfactual

To measure the whole-image effect, I built a separate copy of the archived
source with only `target("no-recurse")` added to `check_sysfile`. The source
copy uses the same `-Oz` flags, current feature spellings, and exact 46-byte
banner as the saved current image. The temporary address-space-2 patch was
applied to compiler `d6658ad` for this build, then removed. The diagnostic
link uses the saved inspection linker script with its 4 KB limit, not the
production 2 KB assertion.

| Variant | `_check_sysfile` | Raw `.text` | ZX0 payload | ROM image | `.bss` |
|---|---:|---:|---:|---:|---:|
| Current baseline | 100 B | 3685 B | 2095 B | 2214 B | 35 B |
| `no-recurse` diagnostic | 87 B | 3672 B | 2089 B | 2208 B | 43 B |
| Difference | **−13 B** | **−13 B** | **−6 B** | **−6 B** | **+8 B** |

The diagnostic listing uses an 8-byte static frame at
`L_check_sysfile.frame`; the baseline uses IX-relative stack slots. This
confirms that the frame gate changed and measures its effect in the complete
firmware link. Against the historical 1915 B payload, the diagnostic still
has a 174 B compressed regression. The verified 6 B saving explains only
about 3.3% of the current +180 B payload delta. The result does not make the
diagnostic source a production-safe change.

The full-image result is smaller than the isolated function's 36 B estimate.
Use the full-link measurement for attribution. The final 2208 B image remains
160 B above the physical 2048 B limit. No runtime test or MAME boot was run.
The inspection ELF, listing, raw payload, compressed payload, and binary are
preserved under
`current-d6658ad-asio/check-sysfile-static-frame-full-build/`.

The earlier expanded diagnostic added `target("no-recurse")` to
`fdc_select_drive_cylinder_head`, `verify_seek_result`, `fdc_get_result_bytes`,
and `fdc_read_data_from_current_location`. Whole-module analysis did not add
`"nonreentrant"` to those functions, so their isolated-function size deltas
are not credited. A fresh pass-only probe of `fdc_select_drive_cylinder_head`
shows the `-recurse` target feature in MIR, but no `"nonreentrant"` attribute.
The same trace marks `verify_seek_result`, `fdc_get_result_bytes`, and
`fdc_read_data_from_current_location` as reachable from multiple contexts.

`Z80NonReentrant.cpp` skips multi-node SCCs before checking the target
`no-recurse` feature. That ordering can prevent a target assertion from
promoting a function in a cyclic component. The probe does not identify the
specific SCC edge for `fdc_select_drive_cylinder_head`, so this remains a
suspected explanation, not a confirmed cause. The other three functions are
explicitly classified as multi-context by the pass. Do not infer static-frame
safety for functions reachable from the floppy ISR.

The frame-policy contribution is now measured for one safe diagnostic
candidate, but the full +292 B raw and +180 B compressed regression is not
causally accounted for. The remaining function-level codegen differences and
any frontend effects still need separate attribution.

## Machine-outliner A/B control

I rebuilt two copies of the same archived source with the same 46-byte banner,
compiler checkout (including the temporary address-space-2 restoration), and
build flags. The only difference was default machine outlining versus
`-mllvm -enable-machine-outliner=never`; both ZX0 payloads round-trip exactly.

| Variant | Raw `.text` | ZX0 payload | ROM image |
|---|---:|---:|---:|
| Outliner enabled | 3685 B | 2095 B | 2214 B |
| Outliner disabled | 3684 B | 2092 B | 2211 B |
| Enabled minus disabled | **+1 B** | **+3 B** | **+3 B** |

With outlining enabled, the listing contains a 7-byte
`_OUTLINED_FUNCTION_1` (`LD (IX-2),L; LD (IX-1),H; RET`) called from two
locations. Two 3-byte calls plus that helper replace two 6-byte instruction
pairs, accounting for the measured +1 B raw result. In this build, disabling
the machine outliner is 3 B better after ZX0; it does not explain the
historical +180 B payload regression.

The enabled raw, compressed, and ROM hashes are respectively
`165a6fa31118a794a5f9ebed66ee87bb4276b90c5f490247a0fabcb60c40bf7b`,
`282deff3564df9bc4c8670b08a50acbd25bad40c643e2504401dc6d9cba3bf8f`, and
`0db6ab1a66620d1e505875c0893ea26cd600b3b851dee5748be4dd805b5ee631`.
The disabled hashes are
`69539c5000044a604b229fdf3460a80830cbd39019b4b9b0d51ca64b7873cb47`,
`a9f764ec581f552a97d2283d97061d45cfd9dfee8a7c207325bc4b45ffd684c1`, and
`428fdd43bfa6da03cfb23fae676c52c244ba5b6d298f654528cbefce61520a4a`.
The builds are preserved under `current-d6658ad-asio/outliner-enabled/` and
`current-d6658ad-asio/outliner-disabled/`.

## Forced-inline diagnostic

I marked `load_chargen_font`, `display_banner_and_start_crt`,
`display_sw1_status`, and `draw_qr` as `always_inline` in a diagnostic source
copy. The emitted listing still has all four helper symbols and their calls;
the raw `.text`, ZX0 payload, and ROM are byte-identical to the outliner-
enabled baseline (3685 B, 2095 B, and 2214 B). Applying LLVM's
`always-inline` pass directly to the emitted IR also left the calls intact.
The inliner remarks identify the reason as conflicting target features. In
this fork, `Z80TTIImpl::areInlineCompatible` rejects a callee unless it has
`InlineHint` or at most 10 IR instructions
(`llvm-z80/llvm/lib/Target/Z80/Z80TargetTransformInfo.h`); the inliner
checks target compatibility before honoring `alwaysinline`
(`llvm-z80/llvm/lib/Analysis/InlineCost.cpp`). Therefore this
source-attribute probe did not test actual inlining.

A second, matched IR-to-image diagnostic added `inlinehint` to those four
functions in a diagnostic IR copy, then ran LLVM's `always-inline` pass. Its
remarks confirm that all four bodies were inlined into `_main_relocated`.
Both variants use the same IR-to-object/link/compress pipeline and both ZX0
round-trips match the extracted ELF `.text` exactly:

| Variant | `_main_relocated` | Helper bodies | Raw `.text` | ZX0 payload | ROM image |
|---|---:|---:|---:|---:|---:|
| No-inline control | 194 B | 175 B | 3666 B | 2086 B | 2205 B |
| Forced-inline diagnostic | 353 B | 0 B | 3650 B | 2074 B | 2193 B |
| Forced-inline minus control | +159 B | −175 B | **−16 B** | **−12 B** | **−12 B** |

SHA-256 hashes for the matched diagnostic outputs:

| Artifact | No-inline control | Forced-inline diagnostic |
|---|---|---|
| `text_raw.bin` | `3522767010685f244162275178eaef42734113650c06084ea73bcf7c7408dd56` | `ae76bea9d3e87b33d19dde580c59e59d7ffd9b2088a5cbbb6e0b2924bfc2cfe8` |
| `text_compressed.zx0` | `a6d91f09ab7845325a5078614a5a8e438dfeb85e9742dd5c5c5cf261b428370f` | `e9c67d843b62ee34898a82bd49b8c3cbbbf20bdf3e238512ffa5e4518c422550` |
| `prom.bin` | `eca6247600149f2d0fd5ec1da70e253aa1817e3719043550ff2379d9b8f4d50c` | `a19ac7ff24adfee990a324eaafbd56c870a703d7c4514dbd290729e5bfbfbb0c` |

The no-inline IR-to-image control is already 19 B raw and 9 B compressed
smaller than the direct-C current baseline above. Thus the valid result is
only the matched −16 B raw / −12 B compressed / −12 B ROM delta; comparing
either absolute diagnostic image to the historical image would mix pipeline
differences into the result. This counterfactual shows that inlining these
bodies can save 12 B in this matched pipeline, but does not establish why the
historical compiler emitted them inline or explain the full image delta.
Artifacts, including both IR files, pass remarks, ELFs, listings, raw and
compressed payloads, and ROMs, are preserved under
`current-d6658ad-asio/always-inline-probe/inline-diagnostics/`.

The structural budget above accounts for where all +292 raw `.text` bytes
appear in the listings; it does not provide a per-function decomposition of
the +180 B ZX0 payload. ZX0 compresses one continuous image, so its byte count
is not the sum of independently attributable function sizes. The measured
whole-image counterfactuals remain limited to −6 B compressed for the
`check_sysfile` static-frame probe, −3 B for disabling machine outlining, and
−12 B for this matched forced-inline probe. The +174 B remaining after the
`check_sysfile` probe is not causally assigned to individual functions here.

## Artifacts

- `evidence/prom.clang.lis` — historical annotated disassembly.
- `current-d6658ad-asio/prom.current-overcap.lis` — current annotated
  disassembly for direct side-by-side inspection.
- `current-d6658ad-asio/prom.current-overcap.elf` — current final-layout
  inspection ELF; not a bootable 2 KB PROM build.
- `current-d6658ad-asio/text_raw.bin` and `text_compressed.zx0` — current
  payloads; the saved decompression round-trip matches the raw payload.
- `current-d6658ad-asio/check-sysfile-static-frame-full-build/` — complete
  `check_sysfile` counterfactual source copy, ELF, listing, binary, and payloads.
  Its binary SHA-256 is `24372f9e016df6ac33782063a459b83d3084189b8547dd0a8f501152d7dc99c0`;
  raw payload SHA-256 is `85dc812ae5ff0e4bac631f7423345dbd905553765911387dde6cf65bceb89a80`;
  compressed payload SHA-256 is `d394d06bb25b973a9716ffc89d092d33d762fe598a8f5a8189a2ddf4f9c71e8d`.
- `current-d6658ad-asio/always-inline-probe/` — source-attribute counterfactual
  and `inline-diagnostics/` matched IR-to-image artifacts with exact ZX0
  round-trips.
- `current-d6658ad-asio/current-backend-port-io.patch` — temporary backend
  patch used only in the isolated worktree.
- `../../build-logs/current-asio-ninja-clang-llc.log` and
  `../../build-logs/autoload-c863c55-current-d6658ad-asio.log` — toolchain
  and firmware build logs.

SHA-256 hashes for the current inspection artifacts:

| Artifact | SHA-256 |
|---|---|
| `prom.current-overcap.bin` | `0db6ab1a66620d1e505875c0893ea26cd600b3b851dee5748be4dd805b5ee631` |
| `prom.current-overcap.elf` | `f7dd77fd40de846224ed0d2fea803a7275111477feae0c9d300487d2594c3e9c` |
| `prom.current-overcap.lis` | `d2def7be007c303d652d37ed7198b2b952081bf414b618229964c61e0b2c6502` |
| `text_raw.bin` | `165a6fa31118a794a5f9ebed66ee87bb4276b90c5f490247a0fabcb60c40bf7b` |
| `text_compressed.zx0` | `282deff3564df9bc4c8670b08a50acbd25bad40c643e2504401dc6d9cba3bf8f` |
| `current-backend-port-io.patch` | `5bebc56789f6b01b293490cd8e23dc8f99d95237d5d8c465b32a32c5d6710b23` |
