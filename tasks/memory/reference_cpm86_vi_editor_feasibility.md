# Lille vi/vi-klon til CP/M-86 (Watcom) — feasibility (2026-08, målt)

Bruger ønsker en lille, brugbar vi/vi-klon oversat med Watcom til CP/M-86.
Undersøgte to kandidater mod det kendte loft (ét 64 KB kodesegment + én 64 KB
DGROUP, small-model near-only clib, ingen termios/termcap, BDOS-konsol).

## Kandidater
- **STEVIE (udo-munk/stevie)** — public domain, vims forfader, **allerede CP/M-80-
  bevist** (Philips P2000C, Aztec C). Terminal-søm = kun `windgoto(r,c)` +
  `windclear()` i window.c. Alle 8 core-filer (2631 linjer) oversætter RENT med
  `owcc -bcpm86`. MEN readme advarer: "very slow and has a few bugs" (gammel
  1987/88-kodebase på langsom HW) — bruger vil hellere have noget mere robust.
- **levee (Orc/levee)** — permissiv BSD-agtig licens, "tiny, fast" (forfatter:
  "somewhat erratic"), aktivt vedligeholdt. Ren OS-søm: ~12 `os_`-display-fns +
  getKey/set_input + rå fil-I/O; har allerede `doscall.c` + **`flexcall.c`**
  (FlexOS = DRI/CP/M-slægtning) som skabelon for et `cpmcall.c`. **ANBEFALET.**

## levee — målt feasibility (håndlavet config.h, owcc -bcpm86 -ms -Os)
- **13/14 core-filer oversætter rent.** Kun `find.c` fejler: parameter hedder
  `errno` (kolliderer med clibs errno-makro) → én-linje-rename el. `#undef errno`.
- config.h-nøgler: OS_DOS=1, USING_STDIO=1, LOGGING=0, USING_MKTEMP=0,
  USING_GLOB=0, HAVE_STRDUP=1, HAVE_BASENAME=1, `typedef int os_pid_t;`,
  `#include <unistd.h>` (getopt: optarg/optind).
- **Kodesegment `_TEXT` = 32.526 B** — passer LET (halvdelen af 64 KB), masser af
  plads til find.c + OS-lag. (Modsat Zip, hvor _TEXT alene var 69 KB.)
- **DGROUP er begrænsningen, IKKE koden.** BSS ved naiv build = 88 KB (27,6 KB
  over). Sammensætning (målt ved at variere EDITSIZE):
  - `core[EDITSIZE+1]` (globals.c:80) = edit-bufferen; `#ifndef EDITSIZE` så
    override med **`-DEDITSIZE=N`** uden kildeændring (default 32760).
    EDITSIZE 32760→8000 sparede PRÆCIS 24.760 B (1:1).
  - **~54 KB FAST BSS** tilbage uanset EDITSIZE: clib-tabeller (ctype/alphabet
    ~8 KB, printf-float ~2 KB, stdio FILE-buffere, tmpfile) + levees yank
    (SBUFSIZE 4096) / undo (~2 KB) / find-buffere.
  - Ved EDITSIZE=8000 stadig 2864 B over → naiv build efterlader kun ~5 KB til
    edit-bufferen (= kun bittesmå filer redigerbare).

## Verdikt
levee er **viable** (koden passer med stor margen; modsat Zip er der intet
kodeloft). Den reelle opgave er at **generobre ~27 KB DGROUP** fra det faste
BSS (trim clib: undgå float-printf, evt. slankere ctype/stdio, drop tmpfile) så
en brugbar EDITSIZE (~20-30 KB → rediger filer op til den størrelse) kan få
plads. Præcis reclaim-fordeling er ikke verificeret endnu.

## Åben beslutning før fuld port
Målterminal og dens escape-sekvenser til `os_gotoxy`/clear (RC759-firmware vs
emu2's ANSI-konsol vs VT52/VT100) — kan ikke afgøres uden brugerinput; afgør
også hvordan man tester fuldskærms-editoren (emu2-konsollen kan være begrænset).

## Næste skridt (fuld port, når retning bekræftet)
1. Vælg levee; fix find.c `errno`-param (rename/`#undef`).
2. Skriv `cpmcall.c` (~250 linjer, spejl flexcall.c): rå fil-I/O → clibs
   open/read/write/lseek/close; getKey/set_input → BDOS fn 6 (rå, ingen echo);
   os_gotoxy/clear/highlight → målterminalens escape-sekvenser.
3. Trim clib-BSS; sæt EDITSIZE så DGROUP passer; link + test under emu2.
4. Uafhængig oracle: rediger en fil, gem, verificér byte-indhold på host.

Repos: github.com/udo-munk/stevie, github.com/Orc/levee.
