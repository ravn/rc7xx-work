# Reference archives — RC750 / RC759 software (datamuseum.dk)

Canonical online archive of original Regnecentralen diskette images and
documentation, maintained by Datamuseum (DK). Use these when hunting for tools
not present on the four local RC759 disks (disk1–4) — e.g. **LINK-86**, which is
NOT on the local disks (disk1 ships only ASM86 + GENCMD + DDT86).

## Keyword index pages
- RC750 (Piccoline family, 152 artifacts): https://datamuseum.dk/wiki/Bits:Keyword/RC/RC750
- RC759 (188 artifacts):                    https://datamuseum.dk/wiki/Bits:Keyword/RC/RC759

## How the archive is addressed
Each artifact has a numeric Bits id `300NNNNN`:
- Wiki page:            https://datamuseum.dk/wiki/Bits:300NNNNN
- Raw bitstore blob:    https://datamuseum.dk/bits/300NNNNN
- Auto-analysis / file listing (shows disk directory, filenames, hex):
                        https://datamuseum.dk/aa/rc759/300NNNNN.html   (rc759)
                        https://datamuseum.dk/aa/rc750/300NNNNN.html   (rc750)

## Finding LINK-86 (or any named file) across the archive
The per-artifact `aa/rc7xx/<id>.html` page lists the disk's directory contents,
so a targeted sweep works:
    for id in <ids from keyword page>; do
      curl -s https://datamuseum.dk/aa/rc759/$id.html | grep -iE 'LINK|L86' && echo "  ^ $id"
    done
The keyword page HTML contains all ids as `Bits:300NNNNN` anchors.

Saved 2026-08-13 per user (@xthra): "Alle de disketter jeg kender til rc750
ligger under .../RC/RC750, og dem til rc759 .../RC/RC759. Gem gerne referencen."
