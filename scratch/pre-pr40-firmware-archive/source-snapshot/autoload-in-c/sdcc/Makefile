# sdcc/Makefile — Clean target for SDCC PROM build artifacts
# Build is handled by parent Makefile (z88dk Docker needs parent as workdir).

.PHONY: clean

clean:
	rm -f *.o prom0 prom0_*.bin prom.bin prom0.map prom0.lis
	rm -f zcc_opt.def *.c.lis *.c.asm build_stamp.h
