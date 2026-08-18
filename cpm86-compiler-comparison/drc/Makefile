include ../common.mk
export WATCOM := $(OWROOT)/rel
export PATH   := $(OWROOT)/rel/armo64:$(PATH)

# Genuine Digital Research C 1.11 -- the ORACLE for how CP/M-86 programs should
# be built. Stands alone: DR C's own compiler + runtime, run headless under
# emu2-cpm86, never combined with Open Watcom. Its Intel-OMF object is sized with
# omfsize (agrees with DR C's own `code:` report) and disassembled with wdis
# (small model; DR C 1.11 char is unsigned).
BUILD := sh $(TOOLS)/drc-build.sh

.PHONY: all sizes clean
all:   $(BENCHES:=.dis)
%.obj: $(SRCDIR)/%.c ; $(BUILD) $< $@
%.dis: %.obj         ; wdis -a $< > $@
sizes: $(BENCHES:=.obj)
	@for b in $(BENCHES); do echo "$$b|DR C 1.11|small|`$(SIZE) $$b.obj`"; done
clean: ; @rm -f *.obj *.dis
