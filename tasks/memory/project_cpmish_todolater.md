---
name: project-cpmish-todolater
description: TODO-later: investigate cpmish (davidgiven/cpmish) as distribution vehicle for rc702-8dd, rc702-5dd, rc703-qd disk images
metadata:
  type: project
---

**Task:** Undersøg om `https://github.com/davidgiven/cpmish` er et godt projekt til at distribuere software til RC702 (8" DD og 5" DD) og RC703 (QD) via færdige diskbilleder.

**Why:** Bruger ønsker at gøre RC702/RC703-software tilgængeligt til andre. cpmish er et moderne open-source CP/M-lignende OS med build-infrastruktur til at producere diskbilleder til diverse retro-maskiner. Det kan potentielt være en vej til rc702-8dd / rc702-5dd / rc703-qd distributions.

**How to apply:** Når dette undersøges, kig på:
- Hvilke maskiner understøtter cpmish allerede (target-liste)?
- Er der et RC702/RC703-target eller noget der ligner (8080/Z80, sektorstørrelser)?
- Hvad er build-infrastrukturen (Makefile, platform-ports)?
- Ville det give mening at tilføje et rc702-target vs. blot distribuere .imd-filer direkte?
- Alternativt: er rcbios-kildekoden + SYSGEN + imd-billeder en bedre distributions-model?

Dato for todo: 2026-07-28.
