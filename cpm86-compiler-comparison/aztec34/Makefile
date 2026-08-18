include ../common.mk
export PATH := $(CROSS)/bin:$(ROOT)/emu2-cpm86:$(PATH)

# Aztec C86 3.40a (K&R) stands alone: its own compiler + object dumper. obd is
# Aztec's native code dump -- the closest thing to a disassembly it offers.
CC    := aztec34_cc
OBD   := aztec34_obd
LABEL := Aztec C86 3.40a

.PHONY: all sizes speed clean
all:   $(BENCHES:=.dis)
%.o:   $(SRCDIR)/%.c ; cp $< $*.c && $(CC) $*.c >/dev/null 2>&1
%.dis: %.o           ; $(OBD) $< > $@ 2>/dev/null
sizes: $(BENCHES:=.o)
	@for b in $(BENCHES); do echo "$$b|$(LABEL)|default|`$(OBD) $$b.o 2>/dev/null | python3 $(TOOLS)/azsize.py`"; done
speed: ; @for b in $(SPEEDBENCHES); do sh $(TOOLS)/speed.sh aztec34 $$b; done
clean: ; @rm -f *.c *.o *.dis
