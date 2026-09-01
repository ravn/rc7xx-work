---
name: project_ow_docker_multiarch
description: Open Watcom CP/M-86 Docker image multi-arch status og kendte problemer (2026-09-01)
metadata:
  type: project
---

Multi-arch Docker image for Open Watcom + CP/M-86 (alle 4 modeller s/m/c/l) implementeret 2026-09-01.

**Why:** Standard OW Docker-image manglede CP/M-86 clib og understøttede kun linux/amd64. Mål: ét image der virker på begge platforme, med alle memory modeller inkl. LARGE.

**State:**
- `scripts/open-watcom.Dockerfile`: `ARG BINDIR=binl64` -- understøtter amd64 og arm64
- `scripts/build_open_watcom_docker.sh`: `--arch amd64|arm64`, auto-detect, clib bygget med native host-tools (macOS bruger armo64/bino64 -- 8086 OMF er host-uafhængigt)
- `ravn/open-watcom-v2-ccpm86`: `.github/workflows/docker-cpm86.yml` + `.github/docker/Dockerfile`
- CI pusher til `ghcr.io/ravn/open-watcom-v2-ccpm86:{amd64,arm64,latest}`

**Kendte problemer:**
- #43: Image-størrelse 500-624 MB (bør slimmes til ~50-80 MB ved at filtrere rel/)
- #44: bld/ cross-arch kontaminering -- stale host-binaries bryder næste build for anden arch

**bld/ cleanup workaround (lokal):**
```python
import os, struct
for root, dirs, files in os.walk('open-watcom-v2/bld'):
    for f in files:
        path = os.path.join(root, f)
        try:
            with open(path, 'rb') as fh: hdr = fh.read(20)
            # Mach-O: magic i {0xFEEDFACE, 0xCEFAEDFE, 0xFEEDFACF, 0xCFFAEDFE}
            # ELF aarch64: hdr[:4]==b'\x7fELF' and e_machine==0xB7 (offset 18, LE)
            # ELF x86-64:  hdr[:4]==b'\x7fELF' and e_machine==0x3E
        except: pass
```
CI undgår problemet via fresh checkout pr. job.

**How to apply:** Før man bygger Docker-imaget for en ny arch lokalt, kør Python-cleanup for den forrige archs stale binaries. På CI sker det automatisk.
