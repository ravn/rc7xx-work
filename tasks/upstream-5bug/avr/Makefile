# AVR cross-target re-evaluation of upstream-candidate bugs.
# Each bug has a checked-in test case here.  Targets named bugN-test build
# + run the AVR side under simavr and print a verdict; targets named
# bugN-codegen dump the AVR codegen to stdout for shape inspection.
#
# Docker invocation policy (HARD rule [[feedback_docker_shim_batch]]):
# one `docker run sh -c "..."` per target — link + simavr in the same call.
# Tally tracked under [[feedback_docker_invocation_budget]].

CLANG    ?= /Users/ravn/z80/llvm-z80/build-macos/bin/clang
LLC      ?= /Users/ravn/z80/llvm-z80/build-macos/bin/llc
MCU      := atmega328p
HERE     := $(CURDIR)

DOCKER_RUN := docker run --rm --platform linux/amd64 \
              -v /Users/ravn/z80:/Users/ravn/z80 \
              -v /tmp:/tmp \
              -w $(HERE) \
              avr-tools sh -c

AVR_CFLAGS := --target=avr -mmcu=$(MCU) -Os \
              -std=c89 -Wno-deprecated-non-prototype \
              -I/Users/ravn/z80/simavr/simavr/sim

.PHONY: all clean \
        bug2-test bug2-codegen \
        bug3-codegen \
        bug4-test bug4-codegen \
        bug5-test bug5-codegen \
        bug164-codegen \
        bug182-test \
        sound-gate-220-test sound-gate-220-codegen

all: bug2-test bug4-test bug5-test bug182-test sound-gate-220-test

# ----- Bug 2: K&R vs ANSI rotl -----
bug2.o: bug2_argument_leaf.c
	$(CLANG) $(AVR_CFLAGS) -c $< -o $@
bug2-test: bug2.o
	@$(DOCKER_RUN) 'avr-gcc -mmcu=$(MCU) bug2.o -o bug2.elf && avr-size bug2.elf && echo "--- simavr ---" && timeout 5 simavr bug2.elf'
bug2-codegen: bug2_argument_leaf.c
	@$(CLANG) $(AVR_CFLAGS) -S $< -o - | sed -n '/^rotl_knr:/,/.size.*rotl_knr/p; /^rotl_ansi:/,/.size.*rotl_ansi/p'

# ----- Bug 3: branch vs select (codegen only) -----
bug3-codegen: bug3_twoentry_phi.ll
	@$(LLC) -O2 -mtriple=avr -mcpu=$(MCU) $< -o - | sed -n '/^branch_form:/,/.size.*branch_form/p; /^select_form:/,/.size.*select_form/p'

# ----- Bug 4: gf_log K&R vs ANSI -----
bug4.o: bug4_outside_user.c
	$(CLANG) $(AVR_CFLAGS) -c $< -o $@
bug4-test: bug4.o
	@$(DOCKER_RUN) 'avr-gcc -mmcu=$(MCU) bug4.o -o bug4.elf && avr-size bug4.elf && echo "--- simavr ---" && timeout 8 simavr bug4.elf'
bug4-codegen: bug4_outside_user.c
	@$(CLANG) $(AVR_CFLAGS) -S $< -o - | sed -n '/^gf_log_knr:/,/.size.*gf_log_knr/p; /^gf_log_ansi:/,/.size.*gf_log_ansi/p'

# ----- Bug 5: 8-byte memcpy -----
bug5.o: bug5_memcpy_illegal.c
	$(CLANG) --target=avr -mmcu=$(MCU) -Os -I/Users/ravn/z80/simavr/simavr/sim -c $< -o $@
bug5-test: bug5.o
	@$(DOCKER_RUN) 'avr-gcc -mmcu=$(MCU) bug5.o -o bug5.elf && avr-size bug5.elf && echo "--- simavr ---" && timeout 5 simavr bug5.elf'
bug5-codegen: bug5_memcpy_illegal.c
	@$(CLANG) --target=avr -mmcu=$(MCU) -Os -I/Users/ravn/z80/simavr/simavr/sim -S $< -o - | sed -n '/^copy8:/,/.size.*copy8/p'

# ----- #164: zext re-insertion cost (codegen only) -----
bug164-codegen: bug164_zext_reinsertion.ll
	@echo "=== AVR ==="; $(LLC) -O2 -mtriple=avr -mcpu=$(MCU) $< -o - | sed -n '/^wide_form:/,/.size.*wide_form/p; /^narrow_form:/,/.size.*narrow_form/p'
	@echo "=== Z80 ==="; $(LLC) -O2 -mtriple=z80 $< -o - | sed -n '/^_wide_form:/,/.End function/p; /^_narrow_form:/,/.End function/p'

# ----- #182: SCEV crash repro (compile-only check) -----
bug182-test: bug182_scev_crash.c
	@echo "=== AVR -O1 (should NOT crash; pipeline lacks Z80LoopIdiomFill) ==="
	@$(CLANG) --target=avr -mmcu=$(MCU) -O1 -c $< -o /tmp/bug182_avr.o && echo "PASS (no crash)" || echo "FAIL (crash)"

clean:
	rm -f *.o *.elf

# ----- #128 LICM/CSE (codegen on/off comparison) -----
bug128-codegen: bug128_licm_cse.ll
	@echo "=== AVR -O2 default ==="; $(LLC) -O2 -mtriple=avr -mcpu=$(MCU) $< -o - | sed -n '/^licm_bait:/,/.size.*licm_bait/p'
	@echo "=== AVR -O2 LICM+CSE OFF ==="; $(LLC) -O2 -mtriple=avr -mcpu=$(MCU) -disable-machine-licm -disable-machine-cse $< -o - | sed -n '/^licm_bait:/,/.size.*licm_bait/p'


# ----- #179 MachineScheduler reload-after-test (codegen only) -----
bug179-codegen: bug179_test_then_dec.ll
	@echo "=== AVR ==="; $(LLC) -O2 -mtriple=avr -mcpu=$(MCU) $< -o - | sed -n '/^test_then_dec_pattern:/,/.size.*test_then_dec_pattern/p'

# ----- icmp-narrow sound-gate cross-target soundness witness -----
# AggressiveInstCombine is target-independent middle-end, so the same
# narrowing decision applies under AVR.  PASS here = sound on both
# 8-bit targets.
sound_gate_220.o: sound_gate_220_soundness.c
	$(CLANG) $(AVR_CFLAGS) -c $< -o $@
sound-gate-220-test: sound_gate_220.o
	@$(DOCKER_RUN) 'avr-gcc -mmcu=$(MCU) sound_gate_220.o -o sound_gate_220.elf && avr-size sound_gate_220.elf && echo "--- simavr ---" && timeout 5 simavr sound_gate_220.elf'
sound-gate-220-codegen: sound_gate_220_soundness.c
	@$(CLANG) $(AVR_CFLAGS) -S $< -o - | sed -n '/^pick_var:/,/.size.*pick_var/p; /^pick_const:/,/.size.*pick_const/p'
