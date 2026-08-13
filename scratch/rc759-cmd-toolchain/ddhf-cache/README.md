# DDHF artifact cache (datamuseum.dk)

Local, in-repo cache of diskette images and metadata fetched from the Datamuseum
(Dansk Datahistorisk Forening) archive, so **nothing is ever re-downloaded** and
we keep provenance for every artifact we rely on.

Populate with `../fetch-ddhf.sh` (fetch-if-missing). See archive addressing and
the RC750/RC759 keyword pages in `../docs/datamuseum-rc750-rc759-archive.md`.

## Layout
- `index/<KEYWORD>.html` — cached keyword listing pages (RC750.html, RC759.html).
  These list every artifact id (`Bits:300NNNNN`) for that machine.
- `bits/<id>.bin`        — raw bitstore blob for artifact `<id>` (the disk image).
- `aa/<coll>/<id>.html`  — Datamuseum auto-analysis page (directory listing/metadata)
  for `<id>`, where `<coll>` is `rc759` or `rc750`.

## Usage
```
../fetch-ddhf.sh --index RC759          # refresh the keyword index
../fetch-ddhf.sh 30003020               # cache one artifact (blob + analysis)
../fetch-ddhf.sh --coll rc750 30002660  # rc750-collection analysis page
```

## Provenance
- `index/RC750.html`, `index/RC759.html` seeded 2026-08-13 from
  https://datamuseum.dk/wiki/Bits:Keyword/RC/{RC750,RC759}
  per user (@xthra): "jeg vil gerne have at de disketter du henter fra ddhf
  caches lokalt i repoet".
