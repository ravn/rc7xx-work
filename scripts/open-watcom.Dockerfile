# Open Watcom v2 (ravn fork) toolchain image, packaged from a Linux `rel/`
# build artifact.  Supports linux/amd64 (binl64) and linux/arm64 (arml64).
#
# The build CONTEXT is the OW `rel/` directory; see build_open_watcom_docker.sh.
# Host tools are statically linked, so the base only needs a shell.
#
# Build args:
#   BINDIR  -- host-tool subdirectory inside /opt/watcom/
#              amd64: binl64 (default)   arm64: arml64
FROM debian:stable-slim

ARG BINDIR=binl64

LABEL org.opencontainers.image.title="open-watcom-cpm86 (ravn fork)" \
      org.opencontainers.image.source="https://github.com/ravn/open-watcom-v2-ccpm86" \
      org.opencontainers.image.description="Open Watcom v2 toolchain from the ravn fork; CP/M-86 first-class with all memory models (owcc -bcpm86)"

# Unpack the rel/ artifact into the conventional install prefix.
COPY . /opt/watcom

# Open Watcom runtime environment (mirrors owsetenv for a Linux install).
# BINDIR selects the host-architecture tool directory (binl64 or arml64).
# The plain binl/ fallback covers the (rare) 32-bit arm case.
ENV WATCOM=/opt/watcom \
    EDPATH=/opt/watcom/eddat \
    WIPFC=/opt/watcom/wipfc \
    INCLUDE=/opt/watcom/h
ENV PATH=/opt/watcom/${BINDIR}:/opt/watcom/binl:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# INCLUDE = the classic Watcom headers (h/), correct for the 16-bit DOS/CP/M-86
# targets (owcc -bcpm86).  For a Linux/Unix target instead, override at runtime:
# `docker run -e INCLUDE=/opt/watcom/lh ...`.

WORKDIR /work
CMD ["bash"]
