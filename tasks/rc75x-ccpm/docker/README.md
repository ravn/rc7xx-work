# Docker Build Instructions: rc759-nasm

Dette bibliotek indeholder opsætningen til Docker-imaget `rc759-nasm`, som anvendes til deterministisk gen-assemblering af Concurrent CP/M-86 kernen (`ccpm.sys`) for RC759 Piccoline med NASM under Linux.

---

## 1. Byg Docker-image (`rc759-nasm`)

Kør følgende kommando fra projektets rodmappe:

```bash
docker build -t rc759-nasm tasks/rc75x-ccpm/docker
```

Eller kør det medfølgende script:

```bash
./tasks/rc75x-ccpm/docker/build_image.sh
```

### Dockerfile indhold
```dockerfile
FROM ubuntu:22.04
RUN apt-get update -qq && apt-get install -qq -y nasm && rm -rf /var/lib/apt/lists/*
WORKDIR /work
```

---

## 2. Kør assemblering og verifikation

For at samle `tasks/rc75x-ccpm/ccpm.asm` og verificere 100% byte-identitet mod den originale `scratch/tmp/ccpm.sys` (77.568 bytes):

```bash
docker run --rm -v "$(pwd):/work" -w /work/tasks/rc75x-ccpm rc759-nasm \
    nasm -f bin -o /work/scratch/tmp/ccpm_final.sys ccpm.asm && \
cmp scratch/tmp/ccpm_final.sys scratch/tmp/ccpm.sys && \
echo "PASS: 100% BYTE-IDENTICAL"
```

Eller kør det automatiske verifikationsscript:

```bash
./tasks/rc75x-ccpm/rebuild_and_verify.sh
```

---

## 3. Bemærkning vedr. macOS Docker Socket

På macOS kan Docker daemon-stien kræve eksplicit angivelse af socket, hvis standard-miljøet ikke har den sat i PATH:

```bash
DOCKER_HOST="unix://$HOME/.docker/run/docker.sock" /Users/ravn/.docker/bin/docker ...
```
