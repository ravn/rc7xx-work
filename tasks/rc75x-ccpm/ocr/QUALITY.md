# OCR-kvalitetsvurdering — PICCOLINE Programmers Guide v2

## Sammenligning: Embedded (iText) vs Tesseract 5 (dan+eng)

Side 97 (§8.2 Floppy Disk Controller) er det bedste direkte sammenligningsgrundlag,
fordi vi har MAME-kilden som uafhængig verifikation.

### Hex-adresser (ground truth: MAME rc759.cpp)

| Original (MAME) | Embedded OCR | Tesseract 5 |
|-----------------|--------------|-------------|
| `0280H` | `02808` ✗ | `0280H` ✓ |
| `0282H` | `02828` ✗ (H→8) | `0282H` ✓ |
| `0284H` | `0284H` ✓ | `0284H` ✓ |
| `0286H` | `0286H` ✓ | `0286H` ✓ |
| `0288H` | `0288B` ✗ (H→B) | `0288H` ✓ |
| `028EH` | `028EH` ✓ | `028EH` ✓ |
| `0290H` | `0290H` ✓ | `02908` ✗ (H→8) |

Tesseract 5: **6/7 korrekt** (86%). Embedded: **4/7 korrekt** (57%).

### Dansk tekst — side 4 (forord)

Original tekst (visuel læsning):
> "Udgivet af A/S Regnecentralen af 1979, København.
>  Brugere af denne manual gøres opmærksom på, at specifikationerne
>  heri uden varsel kan ændres af RC."

Embedded OCR udtræk:
> (ingen dansk tekst overhovedet — ÆØÅ ikke ekstraheret)

Tesseract 5 udtræk:
> "Udgivet of A/S Regnecentraien af 1979, København
>  Srugere of denne manual geves opmasrisom på, at spectinationer-
>  32 heri aden varsel han ændres at RC."

Tesseract: fejl på ~30% af ord i scannet dansk tekst, men fanger
`København`, `ændres`, `på` korrekt. Embedded: 0% dansk.

### Assembler-kode (side 85-86)

Tesseract fanger hex-konstanter (`0E4H`, `0BFH`) og assembler-syntax
næsten perfekt. Embedded OCR er ligeledes god til dette.

## Konklusion

**For teknisk indhold**:
- Tesseract 5 er markant bedre (86% vs 57% hex-adresser)
- Begge fejler lejlighedsvist (H → 8/B stadig problem)

**For dansk tekst**:
- Tesseract 5 er brugbar — ÆØÅ ekstraheres, 70% ordkorrekthed
- Embedded OCR er ubrugelig til dansk (ÆØÅ mangler helt)

**Anbefaling**: Brug `pages/p-NNN.txt` fra Tesseract 5 som primær reference,
men verificér kritiske værdier mod MAME-kilden og visuel læsning.

## Artefakter

- `pages/p-NNN.png` — 252 PNG-sider (300 dpi)
- `pages/p-NNN.txt` — Tesseract 5 OCR per side
- `docker/Dockerfile` — Debian 12 + tesseract-ocr-dan/eng + poppler-utils
- `ocr-batch.sh` — batch-script der kan gentages
- `compare_ocr.py` — kvantitativ sammenligning
