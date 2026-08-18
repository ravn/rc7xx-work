# Shared config for the per-compiler CP/M-86 code-size comparison. Each compiler
# builds the SAME sources in src/ from its own subdir, standing alone -- no
# compiler is ever combined with another's runtime. Included by every Makefile;
# CMPDIR resolves to this directory whether included from here or a subdir.
CMPDIR  := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
ROOT    := $(abspath $(CMPDIR)/..)
SRCDIR  := $(CMPDIR)/src
TOOLS   := $(CMPDIR)/tools
OWROOT  := $(ROOT)/open-watcom-v2
CROSS   := $(OWROOT)/contrib/ravn/cpm86-crossdev
BENCHES := sieve dhry whet aes256
SIZE     = python3 $(TOOLS)/omfsize.py --code   # OMF CODE bytes -> one integer
