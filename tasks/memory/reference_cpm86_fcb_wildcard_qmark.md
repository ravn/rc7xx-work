# CP/M-86 FCB-wildcard: BDOS search matcher kun '?', ikke '*'

2026-08-21 (bruger-påmindelse under zip-porten). BDOS Search First / Search Next
(functions 17 / 18, INT E0h med et FCB) matcher filnavne med **'?' pr.
tegnposition** i FCB'ens 8-tegns navn + 3-tegns type. **'*' eksisterer IKKE på
FCB-niveau** — det er en ren CCP/parser-bekvemmelighed: når CCP (eller
`parse_filename`, BDOS 152) læser en streng som `*.TXT`, ekspanderer den `*` til
'?' der udfylder RESTEN af det pågældende felt. Selve BDOS-søgningen ser kun '?'.

Følge for zip's `wild()`/enhver directory-scan der bruger BDOS 17/18:
- Konvertér selv `*` → '?'-padding før FCB'en fyldes: `*.txt` → navn
  `????????`, type `TXT` (eller `*` → alle 8 '?' i navnefeltet, `*.* ` → 11 '?').
- Et FCB-felt fyldes med '?' fra positionen hvor '*' stod og resten ud.
- Alternativt (unzip-precedent, `unzip60/cpm86/cpm86.c` do_wild): DROP globbing
  helt og behandl hvert argument som et literalt navn — CP/M-86 har ingen
  opendir/readdir, og det er den dokumenterede fallback for porte uden læsbart
  katalog. Enklest for zip M4; `[[reference_zip_cpm86_needs_large_model]]`.

Se ZIP_CPM86_PLAN.md M4 (`wild`/`filetime`).
