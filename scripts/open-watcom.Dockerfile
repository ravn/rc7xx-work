# Open Watcom v2 (ravn fork) toolchain image, packaged from a Linux-x64 `rel/`
# build artifact (as produced by scripts/build_open_watcom.sh on a Linux host,
# equivalent to the GitHub CI's linux-x64 artifact).
#
# The build CONTEXT is the OW `rel/` directory; see build_open_watcom_docker.sh.
# The linux-x64 tools in binl64/ are STATICALLY linked, so the base only needs a
# shell -- no runtime libraries.
FROM debian:stable-slim

LABEL org.opencontainers.image.title="open-watcom-cpm86 (ravn fork)" \
      org.opencontainers.image.source="https://github.com/ravn/open-watcom-v2" \
      org.opencontainers.image.description="Open Watcom v2 toolchain (Linux x64) from the ravn fork; CP/M-86 first-class (owcc -bcpm86 turnkey)"

# Unpack the rel/ artifact into the conventional install prefix.
COPY . /opt/watcom

# Open Watcom runtime environment (mirrors owsetenv for a Linux install).
# binl64 = 64-bit host tools (preferred), binl = 32-bit host tools (fallback).
ENV WATCOM=/opt/watcom \
    PATH=/opt/watcom/binl64:/opt/watcom/binl:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    EDPATH=/opt/watcom/eddat \
    WIPFC=/opt/watcom/wipfc \
    INCLUDE=/opt/watcom/h
# INCLUDE = the classic Watcom headers (h/), correct for the 16-bit DOS/CP/M-86
# targets (owcc -bcpm86).  For a Linux/Unix target instead, override at runtime:
# `docker run -e INCLUDE=/opt/watcom/lh ...`.

WORKDIR /work
CMD ["bash"]
