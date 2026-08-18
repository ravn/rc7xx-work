# Shared config for the per-compiler CP/M-86 code-size comparison. Each compiler
# builds the SAME sources in src/ from its own subdir, standing alone -- no
# compiler is ever combined with another's runtime. Included by every Makefile;
# CMPDIR resolves to this directory whether included from here or a subdir.
CMPDIR  := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
ROOT    := $(abspath $(CMPDIR)/..)
SRCDIR  := $(CMPDIR)/src
TOOLS   := $(CMPDIR)/tools
OWROOT  := $(ROOT)/open-watcom-v2
CROSS   := $(ROOT)/cpm86-crossdev
BENCHES := sieve dhry whet aes256
SIZE     = python3 $(TOOLS)/omfsize.py --code   # OMF CODE bytes -> one integer
# Runtime (differential 80186-clock) comparison. sieve/aes256 ship a driver
# (sieve_main.c / aes256_main.c); dhry carries its own main() but is measured too
# (speed_mame.sh handles single-source kernels). whet is EXCLUDED here -- it needs
# floating point and only the Watcom soft-float (-fpc) port links it, so it has no
# 4-way row; measure it with `make speed-whet` (one full run, Watcom only).
SPEEDBENCHES := sieve dhry aes256
