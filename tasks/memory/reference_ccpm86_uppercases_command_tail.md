# CCP/M-86 folder kommando-halen til UPPERCASE (MAME-verificeret)

**Fakta (rigtig RC759 CCP/M-86 3.1 på MAME, PICCOLINE XIOS 2.3, 2026-08-25):**
kommando-halen der leveres til et transient program er **foldet til uppercase**,
selvom konsollen *ekkoer* det du tastede i original case.

Verificeret empirisk (ikke emu2-antagelse): tastede `taildump abcXYZ` (små) på
`A>` via natkeyboard; konsollen ekkoede småt, men programmet fik
`RAWTAIL len=7 [ ABCXYZ]` og `argv1=[ABCXYZ]`. Foldningen sker i CCP'ens
P_CLI/F_PARSE-sti *mellem* konsol-input og base-page-halens opbygning.

**Dok vs. virkelighed:** Concurrent CP/M Programmer's Reference Guide §6.2.7
dokumenterer at F_PARSE upper-caser, men **kun for FCB/filnavn-felterne**
(0x5C/0x6C) — den siger IKKE at 0x80-halen foldes. Guiden lod det åbent; MAME
afgjorde det.

**Ingen vej udenom:** intet BDOS-kald/struktur giver et transient program den
pre-foldede oprindelige kommandolinje. Originalen lever i forælder-TMP'ens CLBUF
(ikke tilgængelig for barnet); barnet ser kun base-page (0x80-hale + FCB'er, begge
foldet). `P_PDADR` (fn 156) → RSP Command Queue Message har en 129-byte COMMAND
TAIL, men kun for RSP'er, ikke transiente CMD-programmer.

**Konsekvens:** zips ~13 case-distinkte option-par (`-d`/`-D`, `-t`/`-T` …) kan
ikke skelnes via tastede options — den lowercase-variant ankommer uppercased.
Fornuftig håndtering: korte optioner → map til lowercase-betydning i argv-laget
(`cpm86/cpm86.c`); sjældne uppercase-varianter → case-insensitive lange optioner.

Reproduktion + fuld writeup + snapshot:
`infozip-cpm86-builds/CCPM86_COMMAND_LINE_CASE_2026-08-25.md` +
`infozip-cpm86-builds/tools/taildump/`. Metode-slægtning:
`[[reference_rc759_mame_c_verification]]` (MAME = eneste sandhedsvidne, ikke emu2).
