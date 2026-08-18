# CP/M-86 C compiler comparison -- one shared C source in src/, built by each
# compiler in its own subdir. No compiler is combined with another's runtime:
#   watcom/  one-step owcc -bcpm86 (production), size + wdis source-interleaved dis
#   drc/     genuine DR C 1.11 oracle, size + wdis dis
#   aztec42/ Aztec C86 4.2, size + obd dump
#   aztec34/ Aztec C86 3.40a, size + obd dump
#
# Targets:  make compare  -> per-benchmark code-size table across all compilers
#           make speed    -> per-benchmark runtime table (80186 clocks/iteration,
#                            differential; sieve + aes256 kernels)
#           make dis      -> generate every compiler's disassembly of every source
#           make clean
include common.mk
SUBDIRS := watcom drc aztec42 aztec34

.PHONY: all compare speed dis clean
all: compare
compare:
	@{ for d in $(SUBDIRS); do $(MAKE) -s -C $$d sizes; done; } | python3 tools/table.py
speed:
	@{ for d in $(SUBDIRS); do $(MAKE) -s -C $$d speed; done; } | \
	  python3 tools/table.py "80186 clocks/iteration (differential, lower is faster)" "clk/iter"
dis:
	@for d in $(SUBDIRS); do $(MAKE) -s -C $$d all; done
clean:
	@for d in $(SUBDIRS); do $(MAKE) -s -C $$d clean; done
