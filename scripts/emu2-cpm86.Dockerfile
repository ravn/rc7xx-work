# emu2-cpm86 (ravn fork) -- CP/M-86 and DOS emulator for the terminal.
#
# Build context: the emu2-cpm86/ source directory.
# The binary must already be built (run `make` there first).
#
# Usage:
#   docker build -f scripts/emu2-cpm86.Dockerfile -t emu2-cpm86:latest emu2-cpm86/
#   docker run --rm -it -v "$PWD":/work emu2-cpm86:latest emu2 myprog.cmd
FROM debian:stable-slim

LABEL org.opencontainers.image.title="emu2-cpm86 (ravn fork)" \
      org.opencontainers.image.source="https://github.com/ravn/emu2-cpm86" \
      org.opencontainers.image.description="CP/M-86 and DOS emulator for the terminal (ravn fork of johnsonjh/emu2-cpm86)"

COPY emu2 /usr/local/bin/emu2

WORKDIR /work
CMD ["bash"]
