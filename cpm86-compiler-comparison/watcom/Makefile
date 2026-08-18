include ../common.mk

OWCC := $(OWROOT)/rel/armo64/owcc
export WATCOM  := $(OWROOT)/rel
export INCLUDE := $(OWROOT)/rel/h
export PATH    := $(OWROOT)/rel/armo64:$(PATH)

# One-step owcc -bcpm86 throughout (compile+link in a single command). -d1 emits
# line-number debug WITHOUT disabling optimization (unlike -d2/-g), so ONE object
# yields both the true -Wc,-os code size AND wdis source-interleaved disassembly.
CC   = $(OWCC) -bcpm86 -Wc,-ms -Wc,-fpc -Wc,-os -Wc,-d1
MAIN = $(wildcard $(SRCDIR)/$*_main.c)   # kernel driver, if the kernel has no main

.PHONY: all sizes clean
all:   $(BENCHES:=.dis) $(BENCHES:=.CMD)
%.o:   $(SRCDIR)/%.c ; $(CC) -c -o $@ $< 2>/dev/null
%.dis: %.o           ; wdis -s -a $< > $@
# `-` so a program the CP/M-86 target can't yet link (e.g. whet: no FP runtime)
# reports the linker error but does not abort the rest of the build.
%.CMD: $(SRCDIR)/%.c ; -$(CC) -o $@ $< $(MAIN)
sizes: $(BENCHES:=.o)
	@for b in $(BENCHES); do echo "$$b|Open Watcom|-os|`$(SIZE) $$b.o`"; done
speed: ; @for b in $(SPEEDBENCHES); do sh $(TOOLS)/speed.sh watcom $$b; done
clean: ; @rm -f *.o *.dis *.CMD *.err *.lst
