include ../common.mk
export PATH := $(CROSS)/bin:$(PATH)

# Aztec C86 4.2 (ANSI) stands alone: its own compiler + object dumper. obd is
# Aztec's native code dump -- the closest thing to a disassembly it offers.
CC    := aztec42_cc
OBD   := aztec42_obd
LABEL := Aztec C86 4.2

.PHONY: all sizes clean
all:   $(BENCHES:=.dis)
%.o:   $(SRCDIR)/%.c ; cp $< $*.c && $(CC) $*.c >/dev/null 2>&1
%.dis: %.o           ; $(OBD) $< > $@ 2>/dev/null
sizes: $(BENCHES:=.o)
	@for b in $(BENCHES); do echo "$$b|$(LABEL)|default|`$(OBD) $$b.o 2>/dev/null | python3 $(TOOLS)/azsize.py`"; done
clean: ; @rm -f *.c *.o *.dis
