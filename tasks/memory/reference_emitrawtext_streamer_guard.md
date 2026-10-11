---
name: reference-emitrawtext-streamer-guard
description: emitRawText virker kun på MCAsmStreamer (-S); object streamer (-c) kalder report_fatal_error — guard med hasRawTextSupport()
metadata:
  type: reference
---

**Mønster:** enhver kode der kalder `OutStreamer->emitRawText(...)` i
en `AsmPrinter`-subklasse skal først tjekke
`OutStreamer->hasRawTextSupport()`.

**Hvorfor:**

- `MCAsmStreamer` (aktiveret af `clang -S` eller `llc` uden
  `-filetype=obj`) understøtter `emitRawText` — bruges til at skrive
  arbitrary tekst-direktiver til `.s`-filen (fx z88dk's C_LINE).
- `MCObjectStreamer` (aktiveret af `clang -c` eller
  `llc -filetype=obj`) understøtter **ikke** `emitRawText`. Default
  `emitRawTextImpl` i `llvm/lib/MC/MCStreamer.cpp:1283` kalder
  `report_fatal_error` → clang-crash.

**Standard-guard:**

```cpp
if (OutStreamer->hasRawTextSupport())
    OutStreamer->emitRawText(...);
```

**Historik (ravn/llvm-z80#410, fix d081b0d):** Z80AsmPrinter havde
denne guard korrekt på linje 354 (end-of-function hook) men manglede
den på linje 117 (per-instruction C_LINE emission). Konsekvens:
`--target=z80-unknown-none-z88dk -g -c` crashede clang. `--target=z80`
var upåvirket fordi `MAI.isZ88DK()` var false. Lit-regression
tilføjet i `z80asm-c-line-debug.ll` med `-filetype=obj` RUN-linje.

**Afledt observation:** når emission dropped under `-c` kan debug-info
gå tabt uden erstatning (DWARF-sektioner er disabled under
Z88DK-triple — [[reference_z88dk_triple_tradeoffs]]). Guard'en stopper
crashet men lukker ikke debug-info-pathen.

**Mal check (unprompted) når du reviewer en ny AsmPrinter-ændring:**
grep for `emitRawText` i Z80-kildekoden; hver forekomst skal have
tilhørende `hasRawTextSupport()`-guard eller være i en kontekst hvor
object-streamer aldrig når frem (fx dedikerede `-S`-only paths).

Relateret: issue ravn/llvm-z80#410 (close commit d081b0d),
[[reference_z88dk_triple_tradeoffs]].
